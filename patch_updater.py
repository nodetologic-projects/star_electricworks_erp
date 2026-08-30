import sys

with open("lib/core/updater/updater_service.dart", "r") as f:
    content = f.read()

target = """    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await http.get(Uri.parse(_versionUrl)).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {"""

patch = """    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      print("UpdaterService: Fetching version from $_versionUrl");
      final response = await http.get(Uri.parse(_versionUrl)).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {"""
content = content.replace(target, patch)


target2 = """        );
      }
    } catch (e) {
      // Silent failure as requested
    }
    return null;"""

patch2 = """        );
      } else {
        print("UpdaterService: HTTP Error ${response.statusCode}");
        throw Exception("HTTP Error ${response.statusCode}");
      }
    } catch (e, st) {
      print("UpdaterService Error: $e");
      print(st);
      rethrow;
    }"""
content = content.replace(target2, patch2)


with open("lib/core/updater/updater_service.dart", "w") as f:
    f.write(content)

