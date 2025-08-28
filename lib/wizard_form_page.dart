import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'steps/video_step.dart';
import 'steps/wheel_step.dart';
import 'steps/pain_choice_step.dart';
import 'constants/colors.dart';

class WizardFormPage extends StatefulWidget {
  const WizardFormPage({super.key});

  @override
  State<WizardFormPage> createState() => _WizardFormPageState();
}

class _WizardFormPageState extends State<WizardFormPage> {
  Map<String, dynamic>? jsonData;
  List<dynamic> stages = [];
  
  int currentStageIndex = 0;
  int currentStepIndex = 0;
  
  bool isLoading = true;
  
  Map<String, dynamic> userResponses = {
    'userId': 'user123',
    'timestamp': DateTime.now().toIso8601String(),
    'responses': {},
  };

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    try {
      final String response = await rootBundle.loadString('lumbar_painTest.json');
      final data = await json.decode(response);
      setState(() {
        jsonData = data;
        stages = data['stages'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      print('Error loading JSON: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<dynamic> get currentStageSteps {
    if (stages.isEmpty || currentStageIndex >= stages.length) return [];
    return stages[currentStageIndex]['steps'] ?? [];
  }

  int get totalStepsInCurrentStage => currentStageSteps.length;

  String get currentStageHeader {
    if (stages.isEmpty || currentStageIndex >= stages.length) return '';
    return stages[currentStageIndex]['header'] ?? 'Stage ${currentStageIndex + 1}';
  }

  void _nextStep() {
    _collectCurrentStepData();
    
    if (currentStepIndex < totalStepsInCurrentStage - 1) {
      setState(() {
        currentStepIndex++;
      });
    } else {
      if (currentStageIndex < stages.length - 1) {
        setState(() {
          currentStageIndex++;
          currentStepIndex = 0;
        });
      } else {
        _completeWizard();
      }
    }
  }
  
  void _storeStepResponse(String responseType, dynamic responseValue) {
    final stepKey = 'stage_${currentStageIndex}_step_$currentStepIndex';
    
    // Initialize step data if it doesn't exist
    if (!userResponses['responses'].containsKey(stepKey)) {
      final currentStageSteps = stages[currentStageIndex]['steps'] ?? [];
      final currentStep = currentStageSteps[currentStepIndex];
      final stepType = currentStep['selectedOption'] ?? '';
      
      userResponses['responses'][stepKey] = {
        'stageIndex': currentStageIndex,
        'stepIndex': currentStepIndex,
        'stepType': stepType,
        'description': currentStep['description'] ?? '',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
    
    userResponses['responses'][stepKey][responseType] = responseValue;
  }
  
  void _collectCurrentStepData() {
    final stepKey = 'stage_${currentStageIndex}_step_$currentStepIndex';
    final currentStageSteps = stages[currentStageIndex]['steps'] ?? [];
    final currentStep = currentStageSteps[currentStepIndex];
    final stepType = currentStep['selectedOption'] ?? '';
    
    if (stepType == 'video_step') {
      userResponses['responses'][stepKey] = {
        'stageIndex': currentStageIndex,
        'stepIndex': currentStepIndex,
        'stepType': stepType,
        'description': currentStep['description'] ?? '',
        'videoUrl': (currentStep['videoUrls'] as Map<String, dynamic>?)?.values.first ?? '',
        'completed': true,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  void _completeWizard() {
    // Collect data from the final step
    _collectCurrentStepData();
    
    // Generate final JSON with all user responses
    final finalJson = {
      ...userResponses,
      'completedAt': DateTime.now().toIso8601String(),
      'totalStages': stages.length,
      'totalSteps': userResponses['responses'].length,
    };
    
    // Print JSON to console
    print('=== WIZARD COMPLETION - USER RESPONSES ===');
    print(JsonEncoder.withIndent('  ').convert(finalJson));
    print('=== END OF USER RESPONSES ===');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Assessment Complete! 🎉',
          style: TextStyle(color: AppColors.textColor),
        ),
        content: Text(
          'Your form has been completed successfully!\n\nCheck the console for the JSON output.',
          style: TextStyle(color: AppColors.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.btnBgColor,
            ),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (stages.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(
          'Error',
          style: TextStyle(color: AppColors.textColor),
        )),
        body: Center(
          child: Text(
            'Unable to load assessment data',
            style: TextStyle(color: AppColors.textColor),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentStageHeader,
          style: TextStyle(color: AppColors.textColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Stage Progress Indicator
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
            child: Column(
              children: [
                // Stage indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${currentStageHeader} - ${currentStepIndex + 1} of $totalStepsInCurrentStage steps',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Current Stage Stepper (horizontal)
                _buildCurrentStageStepper(),
                
                const SizedBox(height: 12),
                
                // Overall Progress (all stages)
                _buildOverallProgress(),
              ],
            ),
          ),
          
          // Step content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildCurrentStepContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStageStepper() {
    return Row(
      children: List.generate(totalStepsInCurrentStage, (index) {
        final isCompleted = index < currentStepIndex;
        final isCurrent = index == currentStepIndex;
        
        return Expanded(
          child: Row(
            children: [
              // Step circle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted 
                      ? Colors.green 
                      : isCurrent 
                          ? Theme.of(context).colorScheme.primary 
                          : Colors.grey.shade300,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
              
              // Connecting line (except for last step)
              if (index < totalStepsInCurrentStage - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    color: index < currentStepIndex 
                        ? Colors.green 
                        : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOverallProgress() {
    return Row(
      children: List.generate(stages.length, (index) {
        final isCompleted = index < currentStageIndex;
        final isCurrent = index == currentStageIndex;
        
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: isCompleted 
                  ? Colors.green 
                  : isCurrent 
                      ? Theme.of(context).colorScheme.primary 
                      : Colors.grey.shade300,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStepContent() {
    if (currentStageSteps.isEmpty || currentStepIndex >= currentStageSteps.length) {
      return const Center(child: Text('No step data available'));
    }

    final currentStep = currentStageSteps[currentStepIndex];
    final stepType = currentStep['selectedOption'] ?? '';

    switch (stepType) {
      case 'video_step':
        return VideoStep(
          key: ValueKey('video_${currentStageIndex}_$currentStepIndex'),
          description: currentStep['description'] ?? '',
          imageUrl: currentStep['imageUrl'],
          videoUrl: (currentStep['videoUrls'] as Map<String, dynamic>?)?.values.first,
          onNext: _nextStep,
        );
      case 'wheel_step':
        return WheelStep(
          key: ValueKey('wheel_${currentStageIndex}_$currentStepIndex'),
          buttonText: currentStep['buttonText'] ?? '',
          onNext: _nextStep,
          onPainLevelChanged: (painLevel) {
            _storeStepResponse('painLevel', painLevel);
          },
        );
      case 'pain_choice_step':
        return PainChoiceStep(
          key: ValueKey('pain_choice_${currentStageIndex}_$currentStepIndex'),
          description: currentStep['description'] ?? '',
          imageUrl: currentStep['imageUrl'],
          choices: List<Map<String, dynamic>>.from(currentStep['choices'] ?? []),
          onNext: _nextStep,
          onSelectionChanged: (choice) {
            _storeStepResponse('selectedChoice', choice);
          },
        );
      default:
        return _buildDefaultStep(currentStep);
    }
  }

  Widget _buildDefaultStep(Map<String, dynamic> step) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.help_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Unknown Step Type',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Step type: ${step['selectedOption'] ?? 'undefined'}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
