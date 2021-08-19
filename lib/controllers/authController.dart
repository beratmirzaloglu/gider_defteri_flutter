import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gider_defteri/controllers/expenseController.dart';
import 'package:gider_defteri/services/database.dart';
import 'package:gider_defteri/utils/static_functions.dart';

class AuthController extends GetxController {
  Rxn<UserCredential> _userCredential = Rxn<UserCredential>();
  final _databaseService = DatabaseService();
  final _expenseController = Get.find<ExpenseController>();

  UserCredential? get userCredential => _userCredential.value;
  set userCredential(value) => _userCredential.value = value;

  signInWithEmail(String email, String password) async {
    userCredential = await _databaseService.signInWithEmail(email, password);
    if (userCredential != null) {
      _expenseController.getExpensesAndBind();
      Get.offAllNamed('/root');
      StaticFunctions.showInformation('Başarıyla giriş yaptınız!');
    }
  }

  signUpWithEmail(String email, String password) async {
    userCredential = await _databaseService.signUpWithEmail(email, password);
    if (userCredential != null) {
      _expenseController.getExpensesAndBind();
      Get.offAllNamed('/root');
      StaticFunctions.showInformation('Başarıyla kayıt oldunuz!');
    }
  }

  Future<void> signInWithGoogle() async {
    userCredential = await _databaseService.signInWithGoogle();

    if (userCredential != null) {
      _expenseController.getExpensesAndBind();
      Get.offAllNamed('/root');
      StaticFunctions.showInformation('Başarıyla giriş yaptınız!');
    }
  }

  signOutWithGoogle() async {
    await _databaseService.signOutWithGoogle();
    _expenseController.clearExpenses();
    userCredential = null;
    Get.offAllNamed('/root');
    StaticFunctions.showInformation('Başarıyla çıkış yaptınız!');
  }
}
