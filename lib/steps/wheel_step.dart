import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/colors.dart';

class WheelStep extends StatefulWidget {
  final String buttonText;
  final VoidCallback? onNext;
  final Function(int)? onPainLevelChanged;

  const WheelStep({
    Key? key,
    required this.buttonText,
    this.onNext,
    this.onPainLevelChanged,
  }) : super(key: key);

  @override
  State<WheelStep> createState() => _WheelStepState();
}

class _WheelStepState extends State<WheelStep> {
  double? _selectedValue;
  bool _hasSelectedValue = false;

  Color _getPainColor(int level) {
    // Create gradient from green (0) to red (10)
    double ratio = level / 10.0;
    return Color.lerp(Colors.green, Colors.red, ratio) ?? Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.buttonText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            Text(
              'Select a number from 0 to 10:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '0 = No pain, 10 = Worst possible pain',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textColorLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            Container(
              height: 250,
              width: double.infinity,
              child: Center(
                child: Container(
                  width: 240, 
                  height: 240,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade50,
                            border: Border.all(color: Colors.blue.shade200, width: 2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _hasSelectedValue 
                                    ? _selectedValue!.toInt().toString()
                                    : 'Pain Scale',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: _hasSelectedValue ? null : 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (!_hasSelectedValue) ...[
                                Text(
                                  'Select a number',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.blue.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ] else ...[
                                Text(
                                  'Poziom bólu',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.blue.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      ...List.generate(11, (index) {
                        final double radius = 95.0;
                        final double angleRad = (270 + (index * 32.7)) * (math.pi / 180);
                        
                        final x = 120 + radius * math.cos(angleRad);
                        final y = 120 + radius * math.sin(angleRad);
                        
                        final Color buttonColor = _getPainColor(index);
                        final bool isSelected = _selectedValue != null && _selectedValue == index;
                        
                        return Positioned(
                          left: x - 20,
                          top: y - 20,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedValue = index.toDouble();
                                _hasSelectedValue = true;
                              });
                              if (widget.onPainLevelChanged != null) {
                                widget.onPainLevelChanged!(index);
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: buttonColor,
                                border: Border.all(
                                  color: isSelected ? Colors.black : Colors.grey.shade400,
                                  width: isSelected ? 3 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  index.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            if (_hasSelectedValue) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Selected value: ${_selectedValue!.toInt()}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _hasSelectedValue ? widget.onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasSelectedValue 
                    ? AppColors.btnBgColor
                    : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'next'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
