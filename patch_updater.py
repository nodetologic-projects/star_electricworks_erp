import sys

with open("lib/core/updater/updater_service.dart", "r") as f:
    content = f.read()

target = """    } catch (e, st) {
      print("UpdaterService Error: $e");
      print(st);
      rethrow;
    }"""

patch = """    } catch (e, st) {
      print("UpdaterService Error: $e");
      if (e is TimeoutException) {
        throw Exception("Update check timed out after 10 seconds. Check your connection.");
      }
      rethrow;
    }"""

if target in content:
    content = content.replace("import 'package:url_launcher/url_launcher.dart';", "import 'package:url_launcher/url_launcher.dart';\nimport 'dart:async';")
    content = content.replace(target, patch)
    with open("lib/core/updater/updater_service.dart", "w") as f:
        f.write(content)
    print("Patched updater_service.dart")
else:
    print("Could not find target")
