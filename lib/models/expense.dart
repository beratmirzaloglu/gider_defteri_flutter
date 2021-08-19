import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String? docId;
  String? title;
  double? amount;
  DateTime? date;

  ExpenseModel({
    this.docId,
    this.title,
    this.amount,
    this.date,
  });

  ExpenseModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    this.docId = doc.id;
    this.title = doc['title'];
    this.amount = doc['amount'];
    this.date = doc['date'].toDate();
  }
}
