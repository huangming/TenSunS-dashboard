local g = import './g.libsonnet';
local var = g.dashboard.variable;

{
  datasource:
    var.datasource.new('datasource', 'prometheus')
    + var.datasource.withRegex('(P|p)rometheus'),

    // + var.datasource.withRegex('(ops|dev)-cortex'),

  // cluster:
  //   var.query.new('cluster')
  //   + var.query.withDatasourceFromVariable(self.datasource)
  //   + var.query.queryTypes.withLabelValues(
  //     'cluster',
  //     'process_cpu_seconds_total',
  //   )
  //   + var.query.withRefresh('time')
  //   + var.query.selectionOptions.withMulti()
  //   + var.query.selectionOptions.withIncludeAll(),

  // namespace:
  //   var.query.new('namespace')
  //   + var.query.withDatasourceFromVariable(self.datasource)
  //   + var.query.queryTypes.withLabelValues(
  //     'namespace',
  //     'process_cpu_seconds_total{cluster=~"$%s"}' % self.cluster.name,
  //   )
  //   + var.query.withRefresh('time'),

  vendor:
    var.query.new('vendor')
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.generalOptions.withLabel('云厂商')
    + var.query.queryTypes.withLabelValues(
      'vendor',
      'node_uname_info',
    )
    + var.query.withSort(i=5)
    + var.query.refresh.onLoad()
    + var.query.withRefresh('time'),

  account:
    var.query.new('account')
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.generalOptions.withLabel('账户')
    + var.query.queryTypes.withLabelValues(
      'account',
      'node_uname_info{vendor=~"$%s"}' % self.vendor.name,
    )
    + var.query.withSort(i=5)
    + var.query.refresh.onLoad()
    + var.query.withRefresh('time'),

  group:
    var.query.new('group')
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.generalOptions.withLabel('分组')
    + var.query.queryTypes.withLabelValues(
      'group',
      'node_uname_info{vendor=~"$%s",account=~"$%s"}' 
      % [
        self.vendor.name,
        self.account.name,
      ],
    )
    + var.query.withSort(i=5)
    + var.query.selectionOptions.withIncludeAll()
    + var.query.refresh.onLoad()
    + var.query.withRefresh('time'),

  name:
    var.query.new('name')
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.generalOptions.withLabel('名称')
    + var.query.queryTypes.withLabelValues(
      'name',
      'node_uname_info{vendor=~"$%s",account=~"$%s",group=~"$%s"}' 
      % [
        self.vendor.name,
        self.account.name,
        self.group.name,
      ],
    )
    + var.query.withSort(i=5)
    + var.query.selectionOptions.withIncludeAll()
    + var.query.refresh.onLoad()
    + var.query.withRefresh('time'),

  instance:
    var.query.new('instance')
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.generalOptions.withLabel('IP')
    + var.query.queryTypes.withLabelValues(
      'instance',
      'node_uname_info{vendor=~"$%s",account=~"$%s",group=~"$%s",name=~"$%s"}' 
      % [
        self.vendor.name,
        self.account.name,
        self.group.name,
        self.name.name,
      ],
    )
    + var.query.withRegex('/(.*):.*/')
    + var.query.withSort(i=5)
    + var.query.refresh.onLoad()
    + var.query.withRefresh('time'),

  interval:
    var.interval.new('interval',["30s","1m","2m","3m","5m","10m","30m"])
    + var.interval.generalOptions.withLabel('间隔'),

  total:
    var.query.new('total') 
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.generalOptions.withLabel('主机数')
    + var.query.queryTypes.withLabelValues(
      'total',
      "count(node_uname_info{vendor=~\"$%s\",account=~\"$%s\",group=~\"$%s\",name=~\"$%s\",name=~\".*$%s.*\"})" 
      % [
              self.vendor.name,
              self.account.name,
              self.group.name,
              self.name.name,
              self.sname.name,
      ],
    )
    // + var.query.withRefresh(2)
    + var.query.generalOptions.showOnDashboard.withNothing()
    + var.query.withRegex('/{} (.*) .*/')
    // + var.query.withSort(i=0)
    + var.query.refresh.onLoad()
    + var.query.withRefresh('time'),

  device:
    var.query.new('device')
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.generalOptions.withLabel('网卡')
    + var.query.queryTypes.withLabelValues(
      'device',
      "node_network_info{vendor=~\"$%s\",account=~\"$%s\",group=~\"$%s\",name=~\"$%s\",instance=~\"$%s:.+\",device!~'tap.*|veth.*|br.*|docker.*|virbr.*|lo.*|cni.*'}"
      % [
        self.vendor.name,
        self.account.name,
        self.group.name,
        self.name.name,
        self.instance.name,
      ],
    )
    + var.query.withSort(i=5)
    + var.query.refresh.onLoad()
    + var.query.withRefresh('time')
    + var.query.selectionOptions.withIncludeAll()
    + var.query.selectionOptions.withMulti(),

  sname:
    var.textbox.new('sname')
    + var.textbox.generalOptions.withLabel('查询')
    + var.textbox.generalOptions.withDescription('总览表名称字段支持筛选，可以使用正则，如：.*aa.*bb.*')
    + var.textbox.generalOptions.showOnDashboard.withLabelAndValue(),

  job:
    var.query.new('job')
    + var.query.withDatasourceFromVariable(self.datasource)
    + var.query.queryTypes.withLabelValues(
      'job',
      'node_uname_info',
    )
    + var.query.refresh.onLoad()
    + var.query.withRefresh('time'),
}
