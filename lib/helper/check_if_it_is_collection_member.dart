import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkItIsCollectionMember(
    String userName, CollectionReference collectionReference) async {
  QuerySnapshot adminsCollection = await collectionReference.get();
  List<QueryDocumentSnapshot> adminsDocs = adminsCollection.docs;
  for (var admin in adminsDocs) {
    if (userName == admin["name"]) {
      return true;
    }
  }
  return false;
}
