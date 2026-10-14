import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TypingTestController extends GetxController {
  final samples = [
    'The quick brown fox jumps over the lazy dog while the sun sets slowly behind the hills.',
    'Success is not final, failure is not fatal, it is the courage to continue that counts.',
    'Technology has changed the way people communicate, work, and live their everyday lives.',
    'A journey of a thousand miles begins with a single step taken with confidence and hope.',
    'Consistency and practice are the two most important habits for mastering any new skill.',
  ];

  final targetText = ''.obs;
  final inputController = TextEditingController();
  final typedText = ''.obs;
  final secondsElapsed = 0.obs;
  final isRunning = false.obs;
  final isFinished = false.obs;
  final wpm = 0.obs;
  final accuracy = 0.obs;

  Timer? _ticker;

  @override
  void onInit() {
    super.onInit();
    _pickNewSample();
  }

  void _pickNewSample() {
    targetText.value = samples[Random().nextInt(samples.length)];
  }

  void onTextChanged(String value) {
    typedText.value = value;

    if (!isRunning.value && value.isNotEmpty) {
      _startTimer();
    }

    if (value.length >= targetText.value.length) {
      _finish();
    }
  }

  void _startTimer() {
    isRunning.value = true;
    secondsElapsed.value = 0;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => secondsElapsed.value++);
  }

  void _finish() {
    _ticker?.cancel();
    isRunning.value = false;
    isFinished.value = true;

    final minutes = (secondsElapsed.value / 60).clamp(1 / 60, double.infinity);
    final wordsTyped = targetText.value.split(' ').length;
    wpm.value = (wordsTyped / minutes).round();

    int correctChars = 0;
    final typed = typedText.value;
    for (int i = 0; i < typed.length && i < targetText.value.length; i++) {
      if (typed[i] == targetText.value[i]) correctChars++;
    }
    accuracy.value = targetText.value.isEmpty ? 0 : ((correctChars / targetText.value.length) * 100).round();
  }

  void restart() {
    _ticker?.cancel();
    inputController.clear();
    typedText.value = '';
    secondsElapsed.value = 0;
    isRunning.value = false;
    isFinished.value = false;
    wpm.value = 0;
    accuracy.value = 0;
    _pickNewSample();
  }

  @override
  void onClose() {
    _ticker?.cancel();
    inputController.dispose();
    super.onClose();
  }
}
