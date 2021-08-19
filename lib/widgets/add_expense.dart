import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gider_defteri/controllers/expenseController.dart';
import 'package:gider_defteri/utils/validator.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatelessWidget {
  final _expenseController = Get.find<ExpenseController>();
  static final _formKey = GlobalKey<FormState>();

  void _submitData() {
    if (_formKey.currentState!.validate()) _expenseController.addExpense();
  }

  void _presentDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) return;
      _expenseController.selectedDateForInsert = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Başlık'),
                controller: _expenseController.titleControllerForInsert,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tutar'),
                validator: Validator.validateAmount,
                controller: _expenseController.amountControllerForInsert,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Obx(
                      () => Expanded(
                        child: Text(_expenseController.selectedDateForInsert ==
                                null
                            ? 'Tarih Seçilmedi!'
                            : 'Tarih: ${DateFormat.yMd('tr-TR').format(_expenseController.selectedDateForInsert!)}'),
                      ),
                    ),
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
                  'Gider Ekle',
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
      ),
    );
  }
}
