import os

org = "com.wolfram180"
name = "icecream_shop_app"
cmd = "flutter create --org " + org + " --project-name " + name + " .";

packages = [
  "provider",
  "intl",
  "http",
  "shared_preferences"
];

for p in packages: 
	cmd += " && flutter pub add " + packages[packages.index(p)]

# Create project
os.system(cmd);

# Replace main file
main = """import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Center(child: FlutterLogo()),
    );
  }
}"""

mainPath = "lib/main.dart"; 
os.remove(mainPath);
f = open(mainPath, "a")
f.write(main)
f.close()