import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../widgets/tool_header.dart';
import '../../widgets/glass_card.dart';
import 'typing_test_controller.dart';

class TypingTestScreen extends StatelessWidget {
  const TypingTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TypingTestController>();

    return Scaffold(
      appBar: ToolHeader(title: 'Typing Test', subtitle: 'Check your typing speed', gradient: AppColors.gradAmber, icon: Icons.keyboard_rounded),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${c.secondsElapsed.value}s', style: const TextStyle(fontWeight: FontWeight.w700)),
                    TextButton.icon(onPressed: c.restart, icon: const Icon(Icons.refresh_rounded, size: 18), label: const Text('New text')),
                  ],
                )),
            const SizedBox(height: 8),
            Obx(() => GlassCard(child: _buildHighlightedText(c))),
            const SizedBox(height: 20),
            Obx(() => TextField(
                  controller: c.inputController,
                  maxLines: 4,
                  enabled: !c.isFinished.value,
                  onChanged: c.onTextChanged,
                  decoration: const InputDecoration(hintText: 'Start typing here...'),
                )),
            const SizedBox(height: 24),
            Obx(() {
              if (!c.isFinished.value) return const SizedBox.shrink();
              return GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _resultStat('WPM', '${c.wpm.value}', AppColors.amber),
                    _resultStat('Accuracy', '${c.accuracy.value}%', AppColors.mint),
                    _resultStat('Time', '${c.secondsElapsed.value}s', AppColors.sky),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedText(TypingTestController c) {
    final target = c.targetText.value;
    final typed = c.typedText.value;
    final spans = <TextSpan>[];
    for (int i = 0; i < target.length; i++) {
      Color color = Colors.grey;
      if (i < typed.length) {
        color = typed[i] == target[i] ? AppColors.mint : AppColors.coral;
      }
      spans.add(TextSpan(text: target[i], style: TextStyle(color: color, fontWeight: i < typed.length ? FontWeight.w700 : FontWeight.w400)));
    }
    return RichText(text: TextSpan(style: const TextStyle(fontSize: 16, height: 1.5), children: spans));
  }

  Widget _resultStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }
}
