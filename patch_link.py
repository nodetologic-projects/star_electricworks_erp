import re

with open('lib/features/settings/settings_screen.dart', 'r') as f:
    content = f.read()

replacement = """                          Center(
                            child: InkWell(
                              onTap: () async {
                                final uri = Uri.parse('https://www.nodetologic.com');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Made by nodetologic IT Solutions By Taiyeb Khumri',
                                  style: TextStyle(
                                    color: Colors.blue, 
                                    fontSize: 13, 
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),"""

content = content.replace("""                          Center(
                            child: Text(
                              'Made by nodetologic IT Solutions By Taiyeb Khumri',
                              style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),""", replacement)

with open('lib/features/settings/settings_screen.dart', 'w') as f:
    f.write(content)
