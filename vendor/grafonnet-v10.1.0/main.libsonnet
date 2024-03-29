// This file is generated, do not manually edit.
{
  '#': {
    filename: 'main.libsonnet',
    help: 'Jsonnet library for rendering Grafana resources\n## Install\n\n```\njb install github.com/grafana/grafonnet/gen/grafonnet-v10.1.0@main\n```\n\n## Usage\n\n```jsonnet\nlocal grafonnet = import "github.com/grafana/grafonnet/gen/grafonnet-v10.1.0/main.libsonnet"\n```\n',
    'import': 'github.com/grafana/grafonnet/gen/grafonnet-v10.1.0/main.libsonnet',
    installTemplate: '\n## Install\n\n```\njb install %(url)s@%(version)s\n```\n',
    name: 'grafonnet',
    url: 'github.com/grafana/grafonnet/gen/grafonnet-v10.1.0',
    usageTemplate: '\n## Usage\n\n```jsonnet\nlocal %(name)s = import "%(import)s"\n```\n',
    version: 'main',
  },
  accesspolicy: import 'raw/accesspolicy.libsonnet',
  dashboard: import 'clean/dashboard.libsonnet',
  folder: import 'raw/folder.libsonnet',
  librarypanel: import 'raw/librarypanel.libsonnet',
  playlist: import 'raw/playlist.libsonnet',
  preferences: import 'raw/preferences.libsonnet',
  publicdashboard: import 'raw/publicdashboard.libsonnet',
  role: import 'raw/role.libsonnet',
  rolebinding: import 'raw/rolebinding.libsonnet',
  team: import 'raw/team.libsonnet',
  panel: import 'panel.libsonnet',
  query: import 'query.libsonnet',
  util: import 'custom/util/main.libsonnet',
  alerting: import 'alerting.libsonnet',
}
