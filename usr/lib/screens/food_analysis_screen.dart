import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'dart:io';

class FoodAnalysisScreen extends StatefulWidget {
  const FoodAnalysisScreen({super.key});

  @override
  _FoodAnalysisScreenState createState() => _FoodAnalysisScreenState();
}

class _FoodAnalysisScreenState extends State<FoodAnalysisScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _analysisResult;
  bool _isAnalyzing = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      _analysisResult = null;
    });
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;
    setState(() => _isAnalyzing = true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final result = await userProvider.analyzeFoodImage(_image);
    setState(() {
      _analysisResult = result;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final analyzedFoods = Provider.of<UserProvider>(context).analyzedFoods;

    return Scaffold(
      appBar: AppBar(title: const Text('Análise de Alimentos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera),
              label: const Text('Tirar Foto do Alimento'),
            ),
            if (_image != null) ...[
              Image.file(File(_image!.path), height: 200),
              ElevatedButton(
                onPressed: _isAnalyzing ? null : _analyzeImage,
                child: _isAnalyzing
                    ? const CircularProgressIndicator()
                    : const Text('Analisar Calorias'),
              ),
            ],
            if (_analysisResult != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_analysisResult!, style: const TextStyle(fontSize: 18)),
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Text('Histórico de Análises', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: analyzedFoods.length,
                itemBuilder: (context, index) {
                  final food = analyzedFoods[index];
                  return ListTile(
                    title: Text(food.name),
                    subtitle: Text('${food.calories.toStringAsFixed(0)} calorias - ${food.date.day}/${food.date.month}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}