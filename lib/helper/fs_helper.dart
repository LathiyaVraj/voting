import 'package:cloud_firestore/cloud_firestore.dart';

class FsHelper {
  FsHelper._();
  static FsHelper fsHelper = FsHelper._();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addingmyData(
      {required String VoterName, required Map<String, dynamic> myData}) async {
    await firebaseFirestore
        .collection("$VoterName")
        .doc("${myData['id']}")
        .set(myData);
  }

  Stream<QuerySnapshot> attachmyData({required String VoterName}) {
    return firebaseFirestore.collection(VoterName).snapshots();
  }

  Future<void> NewlyRec(
      {required String id,
      required Map<String, dynamic> myData,
      required String VoterName}) async {
    await firebaseFirestore.collection(VoterName).doc(id).update(myData);
  }

  Future<void> RemoveRec(
      {required String id,
      required Map<String, dynamic> myData,
      required String VoterName}) async {
    await firebaseFirestore.collection(VoterName).doc(id).delete();
  }

  Stream<QuerySnapshot> attachC() {
    return firebaseFirestore.collection("partyName").snapshots();
  }

  Future<void> NewlyCT(
      {required Map<String, dynamic> myData, required String VoterName}) async {
    await firebaseFirestore
        .collection("partyName")
        .doc(VoterName)
        .update(myData);
  }
}
