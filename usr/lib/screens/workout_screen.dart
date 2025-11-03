import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../models/models.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout workout;
  const WorkoutScreen({super.key, required this.workout});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() => _isCameraInitialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.workout.name)),
      body: ListView.builder(
        itemCount: widget.workout.exercises.length,
        itemBuilder: (context, index) {
          final exercise = widget.workout.exercises[index];
          return Card(
            child: ListTile(
              title: Text(exercise.name),
              subtitle: Text('${exercise.sets} séries x ${exercise.reps} repetições'),
              trailing: exercise.requiresCamera == true && _isCameraInitialized
                  ? SizedBox(
                      width: 100,
                      height: 100,
                      child: CameraPreview(_cameraController!),
                    )
                  : const Icon(Icons.fitness_center),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Finalizar treino e salvar progresso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Treino concluído! Progresso salvo.')),
          );
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}