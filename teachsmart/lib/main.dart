import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeachSmart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TeachSmart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _feedbackController = TextEditingController();
  String _analysis = '';

  Future<void> _analyzeFeedback() async {
    final feedback = _feedbackController.text;
    if (feedback.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/analyze_feedback'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'feedback': feedback}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          _analysis = jsonResponse['analysis'];
        });
      } else {
        setState(() {
          _analysis = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _analysis = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _feedbackController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                hintText: 'Enter student feedback here...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _analyzeFeedback,
              child: const Text('Analyze Feedback'),
            ),
            const SizedBox(height: 16),
            Text(
              _analysis,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
