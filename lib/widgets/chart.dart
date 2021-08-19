import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gider_defteri/controllers/expenseController.dart';
import 'package:gider_defteri/models/expense.dart';
import 'package:gider_defteri/widgets/chart_bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final _expenseController = Get.find<ExpenseController>();

  List<ExpenseModel> get _recentTransactions {
    return _expenseController.expenses.where((t) {
      return t.date!.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  List<Map<String, dynamic>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var i = 0; i < _recentTransactions.length; i++) {
        if (_recentTransactions[i].date?.day == weekDay.day &&
            _recentTransactions[i].date?.month == weekDay.month &&
            _recentTransactions[i].date?.year == weekDay.year) {
          totalSum += _recentTransactions[i].amount ?? 0;
        }
      }

      return {'day': DateFormat.E('tr-TR').format(weekDay), 'amount': totalSum};
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(
        0.0, (sum, item) => sum + item['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var t in groupedTransactionValues)
                  Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                        label: t['day'].toString(),
                        spendingAmount: t['amount'],
                        spendingPercentageOfTotal: totalSpending == 0.0
                            ? 0.0
                            : t['amount'] / totalSpending),
                  )
              ],
            )),
      ),
    );
  }
}
