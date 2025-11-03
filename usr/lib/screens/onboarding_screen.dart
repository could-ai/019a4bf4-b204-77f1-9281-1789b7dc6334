import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/models.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _goal;
  String? _fitnessLevel;
  List<String> _equipment = [];
  bool _smallSpace = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bem-vindo ao Fitness IA')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Sua meta'),
                items: const [
                  DropdownMenuItem(value: 'perder_peso', child: Text('Perder peso')),
                  DropdownMenuItem(value: 'ganhar_massa', child: Text('Ganhar massa muscular')),
                  DropdownMenuItem(value: 'melhorar_resistencia', child: Text('Melhorar resistência')),
                ],
                onChanged: (value) => _goal = value,
                validator: (value) => value == null ? 'Selecione uma meta' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Nível de condicionamento'),
                items: const [
                  DropdownMenuItem(value: 'iniciante', child: Text('Iniciante')),
                  DropdownMenuItem(value: 'intermediario', child: Text('Intermediário')),
                  DropdownMenuItem(value: 'avancado', child: Text('Avançado')),
                ],
                onChanged: (value) => _fitnessLevel = value,
                validator: (value) => value == null ? 'Selecione um nível' : null,
              ),
              CheckboxListTile(
                title: const Text('Treino em espaço pequeno (ex: apartamento)?'),
                value: _smallSpace,
                onChanged: (value) => setState(() => _smallSpace = value ?? false),
              ),
              // TODO: Adicionar campos para equipamentos e restrições
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final user = User(
                      goal: _goal,
                      fitnessLevel: _fitnessLevel,
                      smallSpace: _smallSpace,
                      equipment: _equipment,
                    );
                    Provider.of<UserProvider>(context, listen: false).setUser(user);
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  }
                },
                child: const Text('Gerar Treino Personalizado'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}