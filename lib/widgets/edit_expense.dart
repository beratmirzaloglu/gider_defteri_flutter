import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gider_defteri/controllers/expenseController.dart';
import 'package:gider_defteri/models/expense.dart';
import 'package:intl/intl.dart';

class EditExpense extends StatefulWidget {
  final ExpenseModel expense;

  EditExpense(this.expense);

  @override
  _EditExpenseState createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  final _expenseController = Get.find<ExpenseController>();

  void _submitData() {
    _expenseController.editExpense(widget.expense);
  }

  @override
  void initState() {
    setTextFields();
    super.initState();
  }

  void _presentDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: widget.expense.date!,
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) return;
      _expenseController.selectedDateForEdit = pickedDate;
    });
  }

  void setTextFields() {
    _expenseController.titleControllerForEdit.value = TextEditingValue(
      text: widget.expense.title.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.expense.title!.length),
      ),
    );
    _expenseController.amountControllerForEdit.value = TextEditingValue(
      text: widget.expense.amount.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.expense.amount!.toString().length),
      ),
    );
    _expenseController.selectedDateForEdit = widget.expense.date;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Başlık'),
              controller: _expenseController.titleControllerForEdit,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Tutar'),
              controller: _expenseController.amountControllerForEdit,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Obx(() => Expanded(
                        child: Text(_expenseController.selectedDateForEdit ==
                                null
                            ? 'Tarih Seçilmedi!'
                            : 'Tarih: ${DateFormat.yMd('tr-TR').format(_expenseController.selectedDateForEdit!)}'),
                      )),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    child: Text(
                      'Tarih Seç',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => _presentDatePicker(context),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: Text(
                'Düzenle',
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: _submitData,
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
