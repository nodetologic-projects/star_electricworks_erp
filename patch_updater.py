import re

with open('lib/core/updater/updater_service.dart', 'r') as f:
    content = f.read()

content = content.replace(
    "static const String _versionUrl = 'https://raw.githubusercontent.com/nodetologic-projects/star_electricworks_erp/main/version.json';",
    "static const String _versionUrl = 'https://www.nodetologic.com/version.json';"
)

with open('lib/core/updater/updater_service.dart', 'w') as f:
    f.write(content)
