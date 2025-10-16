import 'package:extract_text/extract_text.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExtractTextExampleApp());
}

class ExtractTextExampleApp extends StatelessWidget {
  const ExtractTextExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Extract Text Example',
      home: ExtractTextHomePage(),
    );
  }
}

class ExtractTextHomePage extends StatefulWidget {
  const ExtractTextHomePage({super.key});

  @override
  State<ExtractTextHomePage> createState() => _ExtractTextHomePageState();
}

class _ExtractTextHomePageState extends State<ExtractTextHomePage> {
  String? filePath;
  String? extractedText;
  bool isLoading = false;

  Future<void> _pickAndExtract() async {
    setState(() {
      extractedText = null;
      isLoading = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        filePath = result.files.single.path!;
        final text = await ExtractText.fromFile(filePath!);
        setState(() => extractedText = text);
      } else {
        setState(() => extractedText = 'No file selected.');
      }
    } catch (e) {
      setState(() => extractedText = 'Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Extract Text Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: isLoading ? null : _pickAndExtract,
                icon: const Icon(Icons.upload_file),
                label: const Text('Select File'),
              ),
              const SizedBox(height: 20),
              if (isLoading) const CircularProgressIndicator(),
              if (filePath != null) ...[
                Text(
                  'Selected File:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  filePath!,
                  style: const TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(height: 20),
              ],
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    extractedText ?? 'No text extracted yet.',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
