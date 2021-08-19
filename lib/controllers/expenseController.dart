import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gider_defteri/controllers/authController.dart';
import 'package:gider_defteri/models/expense.dart';
import 'package:gider_defteri/services/database.dart';
import 'package:gider_defteri/utils/static_functions.dart';
import 'package:gider_defteri/widgets/add_expense.dart';
import 'package:gider_defteri/widgets/edit_expense.dart';

class ExpenseController extends GetxController {
  DatabaseService _databaseService = DatabaseService();
  late AuthController _authController;

  final titleControllerForInsert = TextEditingController();
  final amountControllerForInsert = TextEditingController();
  Rxn<DateTime> _selectedDateForInsert = Rxn<DateTime>();

  final titleControllerForEdit = TextEditingController();
  final amountControllerForEdit = TextEditingController();
  Rxn<DateTime> _selectedDateForEdit = Rxn<DateTime>();

  RxList<ExpenseModel> _expenses = <ExpenseModel>[].obs;

  String get enteredTitleForInsert => titleControllerForInsert.text;
  double get enteredAmountForInsert =>
      double.parse(amountControllerForInsert.text);
  DateTime? get selectedDateForInsert => _selectedDateForInsert.value;
  set enteredTitleForInsert(value) => titleControllerForInsert.text = value;
  set enteredAmountForInsert(value) => amountControllerForInsert.text = value;
  set selectedDateForInsert(value) => _selectedDateForInsert.value = value;

  String get enteredTitleForEdit => titleControllerForEdit.text;
  double get enteredAmountForEdit => double.parse(amountControllerForEdit.text);
  DateTime? get selectedDateForEdit => _selectedDateForEdit.value;
  set enteredTitleForEdit(value) => titleControllerForEdit.text = value;
  set enteredAmountForEdit(value) => amountControllerForEdit.text = value;
  set selectedDateForEdit(value) => _selectedDateForEdit.value = value;

  List<ExpenseModel> get expenses => _expenses;

  void getExpensesAndBind() {
    _expenses.bindStream(_databaseService.expenseStream());
  }

  void clearExpenses() {
    _expenses.clear();
  }

  void clearControllersForInsert() {
    titleControllerForInsert.clear();
    amountControllerForInsert.clear();
    selectedDateForInsert = null;
  }

  void clearControllersForEdit() {
    titleControllerForEdit.clear();
    amountControllerForEdit.clear();
    selectedDateForEdit = null;
  }

  Future<void> addExpense() async {
    _authController = Get.find<AuthController>();
    if (enteredTitleForInsert.isEmpty ||
        enteredAmountForInsert <= 0 ||
        selectedDateForInsert == null) {
      StaticFunctions.showError(
          'Girilen başlık, tutar bilgisi veya tarih geçerli değil.');
      return;
    }
    ExpenseModel _expense = ExpenseModel(
        title: enteredTitleForInsert,
        amount: enteredAmountForInsert,
        date: selectedDateForInsert);

    bool isAdded = await _databaseService.addExpense(
        _expense, _authController.userCredential!.user!.uid);
    if (isAdded) {
      clearControllersForInsert();
      Get.back();
      StaticFunctions.showInformation(
          '${_expense.title} gideri başarıyla eklendi.');
    }
  }

  Future<void> editExpense(ExpenseModel expense) async {
    _authController = Get.find<AuthController>();
    if (enteredTitleForEdit.isEmpty ||
        enteredAmountForEdit <= 0 ||
        selectedDateForEdit == null) {
      StaticFunctions.showError(
          'Girilen başlık, tutar bilgisi veya tarih geçerli değil.');
      return;
    }
    ExpenseModel _expense = ExpenseModel(
        docId: expense.docId,
        title: enteredTitleForEdit,
        amount: enteredAmountForEdit,
        date: selectedDateForEdit);
    await _databaseService.updateExpense(
        _expense, _authController.userCredential!.user!.uid);
    Get.back();
    StaticFunctions.showInformation('Gider başarıyla düzenlendi.');
  }

  Future<bool> removeExpense(String docId) async {
    _authController = Get.find<AuthController>();
    bool result = await _databaseService.removeExpense(
        docId, _authController.userCredential!.user!.uid);
    Get.back();
    StaticFunctions.showInformation('Gider başarıyla silindi.');
    return result;
  }

  void showAddExpenseModal(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: AddExpense(),
          );
        });
  }

  void showEditExpenseModal(BuildContext ctx, ExpenseModel expense) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: EditExpense(expense),
          );
        });
  }
}
