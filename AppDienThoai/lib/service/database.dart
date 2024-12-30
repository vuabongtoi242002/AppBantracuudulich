import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async{
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  UpdateUserwallet(String id, String amount)async{
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Wallet": amount});
  }

  Future addWordItem(Map<String, dynamic> userInfoMap, String name) async{
    return await FirebaseFirestore.instance
        .collection(name)
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getWordItem(String name) async{
    return  await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future addCountry(Map<String, dynamic> userInfoMap, String id) async{
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Cart")
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getCountyCart(String id) async{
    return  await FirebaseFirestore.instance.collection("user").doc(id).collection("Cart").snapshots();
  }

  Future<void> deleteUserInformation(String userId) async {
    try {
      // Assuming you have a collection named 'users' where each document ID is the userId
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .delete();
      print("User information deleted successfully.");
    } catch (e) {
      print("Failed to delete user information: $e");
    }
  }
}