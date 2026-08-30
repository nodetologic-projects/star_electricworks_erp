import sys

with open("lib/features/settings/settings_screen.dart", "r") as f:
    content = f.read()

target = """                          onTap: () async {
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Checking for updates...')),
                              );
                              final updater = ref.read(updaterServiceProvider);
                              final updateInfo = await updater.checkForUpdates();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                if (updateInfo == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to check for updates. Check your connection.')),
                                  );
                                } else if (updateInfo.hasUpdate) {"""

patch = """                          onTap: () async {
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Checking for updates...')),
                              );
                              final updater = ref.read(updaterServiceProvider);
                              final updateInfo = await updater.checkForUpdates();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                if (updateInfo == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to check for updates. Check your connection.')),
                                  );
                                } else if (updateInfo.hasUpdate) {"""
content = content.replace(target, patch)

target2 = """                                      );
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('You are on the latest version.')),
                                  );
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to check for updates. Check your connection.')),
                                );
                              }
                            }
                          },"""

patch2 = """                                      );
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('You are on the latest version.')),
                                  );
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to check for updates: $e')),
                                );
                              }
                            }
                          },"""
content = content.replace(target2, patch2)

with open("lib/features/settings/settings_screen.dart", "w") as f:
    f.write(content)
