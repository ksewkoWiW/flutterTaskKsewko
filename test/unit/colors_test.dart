import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task_ksekwo/constants/colors.dart';

void main() {
  group('AppColors Tests', () {
    test('should have correct brand colors', () {
      expect(AppColors.textColor, const Color(0xFF045373));
      expect(AppColors.btnBgColor, const Color(0xFF059DBF));
      expect(AppColors.lightBg, const Color(0xFFD0ECF2));
      expect(AppColors.lightTextColor, const Color(0xFF059DBF));
    });

    test('should have lighter variations', () {
      expect(AppColors.textColorLight, isA<Color>());
    });
  });
}
