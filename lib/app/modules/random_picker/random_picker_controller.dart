import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RandomPickerController extends GetxController {
  final _rand = Random();

  // Dice
  final diceCount = 1.obs;
  final diceResults = <int>[].obs;

  void rollDice() {
    diceResults.assignAll(List.generate(diceCount.value, (_) => _rand.nextInt(6) + 1));
  }

  void setDiceCount(int count) => diceCount.value = count;

  // Coin
  final coinResult = ''.obs;
  final isFlipping = false.obs;

  void flipCoin() {
    isFlipping.value = true;
    Future.delayed(const Duration(milliseconds: 400), () {
      coinResult.value = _rand.nextBool() ? 'Heads' : 'Tails';
      isFlipping.value = false;
    });
  }

  // Number
  final minController = TextEditingController(text: '1');
  final maxController = TextEditingController(text: '100');
  final numberResult = Rxn<int>();

  void generateNumber() {
    final min = int.tryParse(minController.text) ?? 1;
    final max = int.tryParse(maxController.text) ?? 100;
    if (min >= max) {
      Get.snackbar('Invalid range', 'Max must be greater than min');
      return;
    }
    numberResult.value = min + _rand.nextInt(max - min + 1);
  }

  // List picker
  final listController = TextEditingController();
  final pickedItem = ''.obs;

  void pickFromList() {
    final items = listController.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (items.isEmpty) {
      Get.snackbar('Empty list', 'Enter at least one item, one per line');
      return;
    }
    pickedItem.value = items[_rand.nextInt(items.length)];
  }

  @override
  void onClose() {
    minController.dispose();
    maxController.dispose();
    listController.dispose();
    super.onClose();
  }
}
