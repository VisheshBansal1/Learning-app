import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLang = "English";

  final languages = ["English", "Hindi", "Spanish", "French"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0B1E),
        title: const Text("Select Language"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final lang = languages[index];
          return RadioListTile<String>(
            value: lang,
            groupValue: selectedLang,
            onChanged: (val) {
              setState(() => selectedLang = val!);
              Navigator.pop(context, val);
            },
            title: Text(lang, style: const TextStyle(color: Colors.white)),
            activeColor: Colors.purpleAccent,
          );
        },
      ),
    );
  }
}
