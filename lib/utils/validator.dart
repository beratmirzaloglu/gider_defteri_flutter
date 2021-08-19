import 'package:get/get.dart';

class Validator {
  static String? validateMail(String? value) {
    if (value == null || value.isEmpty || !GetUtils.isEmail(value))
      return 'Lütfen geçerli bir mail adresi giriniz.';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen geçerli bir şifre giriniz.';
    } else if (value.length < 7) {
      return 'Şifre 7 karakterden daha az olamaz.';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen tutar kısmını boş bırakmayınız.';
    } else if (!value.isNum) {
      return 'Lütfen miktar kısmına sadece sayı giriniz.';
    }
    return null;
  }
}
