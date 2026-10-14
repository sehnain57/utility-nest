import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../widgets/tool_header.dart';
import '../../widgets/glass_card.dart';
import 'random_picker_controller.dart';

class RandomPickerScreen extends StatelessWidget {
  const RandomPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<RandomPickerController>();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(180),
          child: Column(
            children: [
              ToolHeader(title: 'Random Picker', subtitle: 'Dice, coin, numbers & lists', gradient: AppColors.gradViolet, icon: Icons.casino_rounded),
              const TabBar(
                isScrollable: true,
                labelColor: AppColors.violet,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.violet,
                tabs: [Tab(text: 'Dice'), Tab(text: 'Coin'), Tab(text: 'Number'), Tab(text: 'List')],
              ),
            ],
          ),
        ),
        body: TabBarView(children: [_diceTab(c), _coinTab(c), _numberTab(c), _listTab(c)]),
      ),
    );
  }

  Widget _diceTab(RandomPickerController c) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [1, 2, 3, 4, 5].map((n) {
              return Obx(() => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text('$n'),
                      selected: c.diceCount.value == n,
                      onSelected: (_) => c.setDiceCount(n),
                      selectedColor: AppColors.violet,
                    ),
                  ));
            }).toList(),
          ),
          const SizedBox(height: 30),
          Obx(() => Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: c.diceResults.map((value) => _diceFace(value)).toList(),
              )),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: c.rollDice,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.violet, foregroundColor: Colors.white),
            child: const Text('Roll Dice'),
          ),
        ],
      ),
    );
  }

  Widget _diceFace(int value) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.gradViolet),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text('$value', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
    );
  }

  Widget _coinTab(RandomPickerController c) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: AppColors.gradAmber),
                  boxShadow: [BoxShadow(color: AppColors.amber.withOpacity(0.4), blurRadius: 30, spreadRadius: 4)],
                ),
                alignment: Alignment.center,
                child: c.isFlipping.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(c.coinResult.value.isEmpty ? '?' : c.coinResult.value,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
              )),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: c.flipCoin,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.amber, foregroundColor: Colors.black),
            child: const Text('Flip Coin'),
          ),
        ],
      ),
    );
  }

  Widget _numberTab(RandomPickerController c) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: TextField(controller: c.minController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Min'))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: c.maxController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Max'))),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() => GlassCard(
                child: Center(
                  child: Text(c.numberResult.value?.toString() ?? '—', style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w800)),
                ),
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: c.generateNumber,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.violet, foregroundColor: Colors.white),
            child: const Text('Generate Number'),
          ),
        ],
      ),
    );
  }

  Widget _listTab(RandomPickerController c) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: c.listController,
            maxLines: 5,
            decoration: const InputDecoration(hintText: 'Enter items, one per line\ne.g.\nPizza\nBurger\nSushi'),
          ),
          const SizedBox(height: 20),
          Obx(() => GlassCard(
                child: Center(
                  child: Text(c.pickedItem.value.isEmpty ? '—' : c.pickedItem.value,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
                ),
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: c.pickFromList,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.violet, foregroundColor: Colors.white),
            child: const Text('Pick Random Item'),
          ),
        ],
      ),
    );
  }
}
