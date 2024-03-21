import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future addUser(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<List<double>> getDataFromFirebase() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    List<double> dataTime = [];

    try {
      // Get data from Firebase Firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      // Loop through documents and extract data
      querySnapshot.docs.forEach((doc) {
        // Assuming the field in Firestore is named 'dataTime'
        double value = doc['dataTime'] ??
            0; // Default to 0 if dataTime field is not found or null
        dataTime.add(value);
      });
    } catch (error) {
      print("Error fetching data: $error");
      // Handle error accordingly
    }

    return dataTime;
  }
}
