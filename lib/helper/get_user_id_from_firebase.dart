import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habat_khardal/helper/save_user_id.dart';
import '../constants.dart';

Future<void> getUserIDFromFirebaseAndSave() async {
  CollectionReference dailyRecords =
      FirebaseFirestore.instance.collection(kDailyRecords);
  var dailyRecordsCollection = await dailyRecords.get();
  for (var doc in dailyRecordsCollection.docs) {
    if (doc["name"] == kUserName) {
      await saveUserId(doc.id);
      return;
    }
  }
}
