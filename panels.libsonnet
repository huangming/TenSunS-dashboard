local g = import 'g.libsonnet';
local queries = import './queries.libsonnet';

{
  timeSeries: {
    local timeSeries = g.panel.timeSeries,
    local fieldOverride = g.panel.timeSeries.fieldOverride,
    local custom = timeSeries.fieldConfig.defaults.custom,
    local options = timeSeries.options,

    base(title, targets):
      timeSeries.new(title)
      + timeSeries.queryOptions.withTargets(targets)
      + timeSeries.queryOptions.withInterval('1m')
      + options.legend.withDisplayMode('table')
      + options.legend.withCalcs([
        'lastNotNull',
        'max',
      ])
      + custom.withFillOpacity(10)
      + custom.withShowPoints('never'),

    short(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('short')
      + timeSeries.standardOptions.withDecimals(0),

    seconds(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('s')
      + custom.scaleDistribution.withType('log')
      + custom.scaleDistribution.withLog(10),

    cpuUsage: self.seconds,

    bytes(title, targets):
      self.base(title, targets,)
      + timeSeries.standardOptions.withUnit('bytes')
      + custom.scaleDistribution.withType('log')
      + custom.scaleDistribution.withLog(2),

    memoryUsage(title, targets):
      self.bytes(title, targets)
      + timeSeries.standardOptions.withOverrides([
        fieldOverride.byRegexp.new('/(virtual|resident)/i')
        + fieldOverride.byRegexp.withProperty(
          'custom.fillOpacity',
          0
        )
        + fieldOverride.byRegexp.withProperty(
          'custom.lineWidth',
          2
        )
        + fieldOverride.byRegexp.withProperty(
          'custom.lineStyle',
          {
            dash: [10, 10],
            fill: 'dash',
          }
        ),
      ]),

    durationQuantile(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('s')
      + custom.withDrawStyle('bars')
      + timeSeries.standardOptions.withOverrides([
        fieldOverride.byRegexp.new('/mean/i')
        + fieldOverride.byRegexp.withProperty(
          'custom.fillOpacity',
          0
        )
        + fieldOverride.byRegexp.withProperty(
          'custom.lineStyle',
          {
            dash: [8, 10],
            fill: 'dash',
          }
        ),
      ]),
  },

  heatmap: {
    local heatmap = g.panel.heatmap,
    local options = heatmap.options,

    base(title, targets):
      heatmap.new(title)
      + heatmap.queryOptions.withTargets(targets)
      + heatmap.queryOptions.withInterval('1m')
      + options.withCalculate()
      + options.calculation.xBuckets.withMode('size')
      + options.calculation.xBuckets.withValue('1min')
      + options.withCellGap(2)
      + options.color.HeatmapColorOptions.withMode('scheme')
      + options.color.HeatmapColorOptions.withScheme('Spectral')
      + options.color.HeatmapColorOptions.withSteps(128)
      + options.yAxis.withDecimals(0)
      + options.yAxis.withUnit('s'),
  },

  table: {
    local table = g.panel.table,
    local options = table.options,
    local description = |||
      分区使用率、磁盘读取、磁盘写入、下载带宽、上传带宽，如果有多个网卡或者多个分区，是采集的使用率最高的网卡或者分区的数值。

      连接数：CurrEstab - 当前状态为 ESTABLISHED 或 CLOSE-WAIT 的 TCP 连接数。

      健康值是一个新增的指标，根据CPU，内存，IO计算出来的一个值，低于90分说明系统的资源使用情况需要注意了，这是一个正在测试的指标，参数可能需要根据实际情况再优化。
    |||,

    base(title, targets):
      table.new(title)
      + table.panelOptions.withDescription(description)
      + options.withShowHeader(true)
      + g.panel.table.queryOptions.withDatasource('prometheus', '$datasource')
      + g.panel.table.queryOptions.withTargets([
        queries.nodeUname,
        queries.totalMemory,
        queries.totalCpuCore,
        queries.UpTime,
        queries.CpuLoad5,
        queries.CpuUsage,
        queries.MemoryUsage,
        queries.PartitionUsage,
        queries.MaxRead,
        queries.MaxWrite,
        queries.ConnectionCount,
        queries.TimeWait,
        queries.DownloadRate,
        queries.UploadRate,
        queries.Health,
        queries.IOutil,

      ])
      + g.panel.table.queryOptions.withTransformations([
        // Transformation 1: merge
        g.panel.table.transformation.withId(
            'merge'
        ),
        // Transformation 2: filter columns
        g.panel.table.transformation.withId('filterFieldsByName')
        + g.panel.table.transformation.withOptions(
            {
                "include": {"pattern": "/^Value #[^A]|^instance$|^name$|^iid$|^exp$/"},
            }
        ),
        // Transformation 3: rename columns
        g.panel.table.transformation.withId(
            'organize'
        ) +
        g.panel.table.transformation.withOptions(
            {
              renameByName: {
                instance: 'IP',
                'Value #B': '内存',
                'Value #C': 'CPU',
                'Value #D': '启动(天)',
                'Value #E': '5分钟负载',
                'Value #F': 'CPU使用率',
                'Value #G': '内存使用率',
                'Value #H': '分区使用率*',
                'Value #I': '磁盘读取*',
                'Value #J': '磁盘写入*',
                'Value #K': '连接数',
                'Value #L': 'TCP_tw',
                'Value #M': '下载带宽*',
                'Value #N': '上传带宽*',
                'Value #O': '健康值',
                'Value #P': 'IOutil使用率*',
                nodename: '主机名',
              }
            }
        ),
      ]),
  },
}

// vim: foldmethod=marker foldmarker=local,;
