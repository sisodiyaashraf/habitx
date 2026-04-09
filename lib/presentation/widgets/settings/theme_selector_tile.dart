import 'package:flutter/material.dart';

class ThemeSelectorTile extends StatelessWidget {
  const ThemeSelectorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: const Text("App Theme"),
      subtitle: const Text("Switch between light and dark mode"),
      trailing: DropdownButton<ThemeMode>(
        value: ThemeMode.system, // For now; later connect to a ThemeProvider
        items: const [
          DropdownMenuItem(value: ThemeMode.system, child: Text("System")),
          DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),
          DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
        ],
        onChanged: (mode) {
          // Logic to update ThemeProvider
        },
      ),
    );
  }
}
