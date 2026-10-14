import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../widgets/tool_header.dart';
import '../../widgets/glass_card.dart';
import 'emi_calculator_controller.dart';

class EmiCalculatorScreen extends StatelessWidget {
  const EmiCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<EmiCalculatorController>();

    return Scaffold(
      appBar: ToolHeader(title: 'EMI Calculator', subtitle: 'Plan your loan repayments', gradient: AppColors.gradDeep, icon: Icons.account_balance_rounded),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: c.setLoanAmount,
              decoration: const InputDecoration(labelText: 'Loan Amount', hintText: 'e.g. 500000'),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: c.setInterestRate,
              decoration: const InputDecoration(labelText: 'Annual Interest Rate (%)', hintText: 'e.g. 12'),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: c.setTenureMonths,
              decoration: const InputDecoration(labelText: 'Tenure (months)', hintText: 'e.g. 36'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: c.calculate,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.sky, foregroundColor: Colors.white),
              child: const Text('Calculate EMI'),
            ),
            const SizedBox(height: 24),
            Obx(() {
              if (!c.hasResult.value) return const SizedBox.shrink();
              return GlassCard(
                child: Column(
                  children: [
                    Text('Monthly EMI', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    const SizedBox(height: 6),
                    Text(c.monthlyEmi.value.toStringAsFixed(2), style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.sky)),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statColumn('Total Interest', c.totalInterest.value.toStringAsFixed(2)),
                        _statColumn('Total Payment', c.totalPayment.value.toStringAsFixed(2)),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _statColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }
}
