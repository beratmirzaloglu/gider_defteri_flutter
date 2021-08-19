import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gider_defteri/controllers/authController.dart';
import 'package:gider_defteri/models/expense.dart';
import 'package:gider_defteri/utils/static_functions.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Future<bool> addExpense(ExpenseModel expense, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .add({
        'title': expense.title,
        'amount': expense.amount,
        'date': expense.date,
      });

      return true;
    } catch (e) {
      print('Kayıt eklenemedi: $e');
      return false;
    }
  }

  Future<bool> updateExpense(ExpenseModel expense, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(expense.docId)
          .update({
        'title': expense.title,
        'amount': expense.amount,
        'date': expense.date,
      });
      return true;
    } catch (e) {
      print('Kayıt güncellenemedi: $e');
      return false;
    }
  }

  Future<bool> removeExpense(String docId, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(docId)
          .delete();
      return true;
    } catch (e) {
      print('Kayıt silinemedi: $e');
      return false;
    }
  }

  Stream<List<ExpenseModel>> expenseStream() {
    String? userId = Get.find<AuthController>().userCredential?.user?.uid;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ExpenseModel> retVal = [];
      for (var doc in query.docs) {
        retVal.add(ExpenseModel.fromDocumentSnapshot(doc));
      }
      return retVal;
    });
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (e) {
      StaticFunctions.showError('Giriş yapma işlemi başarısız!');
    }
  }

  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (e) {
      StaticFunctions.showError('Kayıt olma işlemi başarısız!');
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      StaticFunctions.showError('Google ile giriş yapma işlemi başarısız!');
    }
  }

  signOutWithGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Çıkış yapılamadı.');
    }
  }
}
