import 'dart:math';
import 'package:get/get.dart';

class EmiCalculatorController extends GetxController {
  final loanAmount = ''.obs;
  final interestRate = ''.obs; // annual %, e.g. 12
  final tenureMonths = ''.obs;

  final monthlyEmi = 0.0.obs;
  final totalInterest = 0.0.obs;
  final totalPayment = 0.0.obs;
  final hasResult = false.obs;

  void setLoanAmount(String v) => loanAmount.value = v;
  void setInterestRate(String v) => interestRate.value = v;
  void setTenureMonths(String v) => tenureMonths.value = v;

  void calculate() {
    final p = double.tryParse(loanAmount.value);
    final annualRate = double.tryParse(interestRate.value);
    final n = int.tryParse(tenureMonths.value);

    if (p == null || annualRate == null || n == null || p <= 0 || n <= 0) {
      Get.snackbar('Invalid input', 'Please fill in all fields with valid numbers');
      return;
    }

    final monthlyRate = annualRate / 12 / 100;
    double emi;
    if (monthlyRate == 0) {
      emi = p / n;
    } else {
      final factor = pow(1 + monthlyRate, n);
      emi = p * monthlyRate * factor / (factor - 1);
    }

    monthlyEmi.value = emi;
    totalPayment.value = emi * n;
    totalInterest.value = totalPayment.value - p;
    hasResult.value = true;
  }
}
