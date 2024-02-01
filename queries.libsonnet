local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;

local variables = import './variables.libsonnet';

{
  ############################################
  ## table start
  ############################################
  nodeUname:
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        node_uname_info{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"} - 0
      |||
    )
    + prometheusQuery.withLegendFormat('主机名')
    + prometheusQuery.withInstant()
    + prometheusQuery.withFormat('table'),

  totalMemory:
        prometheusQuery.new(
          '$datasource',
          'node_memory_MemTotal_bytes{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"} - 0',
        )
        + prometheusQuery.withLegendFormat('总内存')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  totalCpuCore:
        prometheusQuery.new(
          '$datasource',
          'count(node_cpu_seconds_total{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",mode="system",name=~".*$sname.*"}) by (instance)',
        )
        + prometheusQuery.withLegendFormat('总核数')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  UpTime:
        prometheusQuery.new(
          '$datasource',
          'sum(time() - node_boot_time_seconds{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"})by(instance)/86400',
        )
        + prometheusQuery.withLegendFormat('运行时间')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  CpuLoad5:
        prometheusQuery.new(
          '$datasource',
          'node_load5{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"}',
        )
        + prometheusQuery.withLegendFormat('5分钟负载')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  CpuUsage:
        prometheusQuery.new(
          '$datasource',
          '(1 - avg(rate(node_cpu_seconds_total{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",mode="idle",name=~".*$sname.*"}[$interval])) by (instance)) * 100',
        )
        + prometheusQuery.withLegendFormat('CPU使用率')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  MemoryUsage:
        prometheusQuery.new(
          '$datasource',
          '(1 - (node_memory_MemAvailable_bytes{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"} / (node_memory_MemTotal_bytes{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"})))* 100',
        )
        + prometheusQuery.withLegendFormat('内存使用率')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  PartitionUsage:
        prometheusQuery.new(
          '$datasource',
          'max((node_filesystem_size_bytes{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*",fstype=~"ext.?|xfs"}-node_filesystem_free_bytes{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*",fstype=~"ext.?|xfs"}) *100/(node_filesystem_avail_bytes {vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*",fstype=~"ext.?|xfs"}+(node_filesystem_size_bytes{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*",fstype=~"ext.?|xfs"}-node_filesystem_free_bytes{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*",fstype=~"ext.?|xfs"})))by(instance)',
        )
        + prometheusQuery.withLegendFormat('分区使用率')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  MaxRead:
        prometheusQuery.new(
          '$datasource',
          'max(rate(node_disk_read_bytes_total{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"}[$interval])) by (instance)',
        )
        + prometheusQuery.withLegendFormat('最大写入')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),
  MaxWrite:
        prometheusQuery.new(
          '$datasource',
          'max(rate(node_disk_written_bytes_total{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"}[$interval])) by (instance)',
        )
        + prometheusQuery.withLegendFormat('最大写入')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),
  ConnectionCount:
        prometheusQuery.new(
          '$datasource',
          'node_netstat_Tcp_CurrEstab{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"} - 0',
        )
        + prometheusQuery.withLegendFormat('连接数')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  TimeWait:
        prometheusQuery.new(
          '$datasource',
          'node_sockstat_TCP_tw{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"} - 0',
        )
        + prometheusQuery.withLegendFormat('TIME_WAIT')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  DownloadRate:
        prometheusQuery.new(
          '$datasource',
          'max(rate(node_network_receive_bytes_total{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"}[$interval])*8) by (instance)',
        )
        + prometheusQuery.withLegendFormat('下载带宽')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  UploadRate:
        prometheusQuery.new(
          '$datasource',
          'max(rate(node_network_transmit_bytes_total{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"}[$interval])*8) by (instance)',
        )
        + prometheusQuery.withLegendFormat('上传带宽')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  Health:
        prometheusQuery.new(
          '$datasource',
          '((1-(1 - avg(irate(node_cpu_seconds_total{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*",mode="idle"}[$interval])) by (instance))^1.3)^(1/3)*0.5 + (1-(1 - avg(node_memory_MemAvailable_bytes{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"} / node_memory_MemTotal_bytes{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"})by (instance))^6)^(1/3)*0.3 + (1 - max(irate(node_disk_io_time_seconds_total{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"}[$interval]))by (instance)^1.1)^(1/2)*0.2)*100',
        )
        + prometheusQuery.withLegendFormat('健康评分')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  IOutil:
        prometheusQuery.new(
          '$datasource',
          'max(rate(node_disk_io_time_seconds_total{vendor=~"$vendor",account=~"$account",group=~"$group",name=~"$name",name=~".*$sname.*"}[$interval])) by (instance) *100',
        )
        + prometheusQuery.withLegendFormat('IOutil使用率')
        + prometheusQuery.withInstant()
        + prometheusQuery.withFormat('table'),

  ############################################
  ## table end
  ############################################

  cpuUsage:
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (cluster, namespace, job) (
            rate(
                process_cpu_seconds_total{
                    cluster=~"$cluster",
                    namespace=~"$namespace",
                    job=~"$job"
                }
            [$__rate_interval])
        )
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{cluster}} - {{namespace}}
    |||),

  memUsage:
    [
      prometheusQuery.new(
        '$' + variables.datasource.name,
        |||
          sum by (cluster, namespace, job) (
            process_virtual_memory_bytes{cluster=~"$cluster", namespace=~"$namespace", job=~"$job"}
          )
        |||
      )
      + prometheusQuery.withIntervalFactor(2)
      + prometheusQuery.withLegendFormat(|||
        virtual - {{cluster}} - {{namespace}}
      |||),
      prometheusQuery.new(
        '$' + variables.datasource.name,
        |||
          sum by (cluster, namespace, job) (
            process_resident_memory_bytes{cluster=~"$cluster", namespace=~"$namespace", job=~"$job"}
          )
        |||
      )
      + prometheusQuery.withIntervalFactor(2)
      + prometheusQuery.withLegendFormat(|||
        resident - {{cluster}} - {{namespace}}
      |||),
      prometheusQuery.new(
        '$' + variables.datasource.name,
        |||
          sum by (cluster, namespace, job) (
            go_memstats_heap_inuse_bytes{cluster=~"$cluster", namespace=~"$namespace", job=~"$job"}
          )
        |||
      )
      + prometheusQuery.withIntervalFactor(2)
      + prometheusQuery.withLegendFormat(|||
        go heap - {{cluster}} - {{namespace}}
      |||),
      prometheusQuery.new(
        '$' + variables.datasource.name,
        |||
          sum by (cluster, namespace, job) (
            go_memstats_stack_inuse_bytes{cluster=~"$cluster", namespace=~"$namespace", job=~"$job"}
          )
        |||
      )
      + prometheusQuery.withIntervalFactor(2)
      + prometheusQuery.withLegendFormat(|||
        go stack - {{cluster}} - {{namespace}}
      |||),
    ],

  goroutines:
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (cluster, namespace, job) (
          go_goroutines{cluster=~"$cluster", namespace=~"$namespace", job=~"$job"}
        )
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{cluster}} - {{namespace}}
    |||),

  threads:
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (cluster, namespace, job) (
          go_threads{cluster=~"$cluster", namespace=~"$namespace", job=~"$job"}
        )
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{cluster}} - {{namespace}}
    |||),

  gcDuration:
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (cluster, namespace, job) (
          rate(
            go_gc_duration_seconds_sum{
                cluster=~"$cluster",
                namespace=~"$namespace",
                job=~"$job"
            }
          [$__rate_interval])
        )
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{cluster}} - {{namespace}}
    |||),

  wqDurationOverTime:
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by(cluster, namespace, job, le, name) (
          rate(
            workqueue_queue_duration_seconds_bucket{
                cluster=~"$cluster",
                namespace=~"$namespace",
                job=~"$job"
            }
          [$__rate_interval])
        )
      |||
    )
    + prometheusQuery.withLegendFormat(|||
      {{cluster}} - {{namespace}}
    |||),

  wqDurationQuantile:
    [
      prometheusQuery.new(
        '$' + variables.datasource.name,
        |||
          histogram_quantile(
            0.%s,
            sum by (cluster, namespace, job, le, name) (
              rate(
                workqueue_queue_duration_seconds_bucket{
                    cluster=~"$cluster",
                    namespace=~"$namespace",
                    job=~"$job"
                }
              [$__rate_interval])
            )
          )
        ||| % quantile
      )
      + prometheusQuery.withIntervalFactor(2)
      + prometheusQuery.withLegendFormat(|||
        {{cluster}} - {{namespace}} - {{name}} - %s%%
      ||| % quantile)
      for quantile in ['50', '95']
    ] + [
      prometheusQuery.new(
        '$' + variables.datasource.name,
        |||
          sum by (cluster, namespace, job, name) (
            rate(
              workqueue_queue_duration_seconds_sum{
                  cluster=~"$cluster",
                  namespace=~"$namespace",
                  job=~"$job"
              }
            [$__rate_interval])
          )
        |||
      )
      + prometheusQuery.withIntervalFactor(2)
      + prometheusQuery.withLegendFormat(|||
        {{cluster}} - {{namespace}} - {{name}} - mean
      |||),
    ],

  wqDepth:
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by(cluster, namespace, job, name) (
          workqueue_depth{cluster=~"$cluster", namespace=~"$namespace", job=~"$job"}
        )
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{cluster}} - {{namespace}} - {{name}}
    |||),

  failedRequests:
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        ceil by (cluster, namespace, job, host, method) (
          sum(
            increase(
              rest_client_requests_total{
                  cluster=~"$cluster",
                  namespace=~"$namespace",
                  job=~"$job",
                  code=~"^(4|5).*"
              }
            [$__rate_interval])
          )
        )
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{cluster}} - {{namespace}} - {{host}} - {{method}}
    |||),

  reconcilingLatencyOverTime:
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (cluster, namesapce, job,le,controller) (
          rate(
            controller_runtime_reconcile_time_seconds_bucket{
                cluster=~"$cluster",
                namespace=~"$namespace",
                job=~"$job"
            }
          [$__rate_interval])
        )
      |||
    )
    + prometheusQuery.withLegendFormat(|||
      {{cluster}} - {{namespace}}
    |||),

  reconcilingDurationQuantile:
    [
      prometheusQuery.new(
        '$' + variables.datasource.name,
        |||
          histogram_quantile(
            0.%s,
            sum by (cluster, namespace, job, le, controller) (
              rate(
                controller_runtime_reconcile_time_seconds_bucket{
                    cluster=~"$cluster",
                    namespace=~"$namespace",
                    job=~"$job"
                }
              [$__rate_interval])
            )
          )
        ||| % quantile
      )
      + prometheusQuery.withIntervalFactor(2)
      + prometheusQuery.withLegendFormat(|||
        {{cluster}} - {{namespace}} - {{name}} - %s%%
      ||| % quantile)
      for quantile in ['50', '95']
    ] + [
      prometheusQuery.new(
        '$' + variables.datasource.name,
        |||
          sum by (cluster, namespace, job, controller) (
            rate(
              controller_runtime_reconcile_time_seconds_sum{
                  cluster=~"$cluster",
                  namespace=~"$namespace",
                  job=~"$job"
              }
            [$__rate_interval])
          )
        |||
      )
      + prometheusQuery.withIntervalFactor(2)
      + prometheusQuery.withLegendFormat(|||
        {{cluster}} - {{namespace}} - {{name}} - mean
      |||),
    ],
}

// vim: foldmethod=indent shiftwidth=2 foldlevel=1
