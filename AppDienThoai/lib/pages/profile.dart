import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

import '../service/auth.dart';
import '../service/shared_pref.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      profile = await SharedPreferenceHelper().getUserProfile();
      name = await SharedPreferenceHelper().getUserName();
      email = await SharedPreferenceHelper().getUserEmail();
      setState(() {});
    } catch (e) {
      // Handle any errors that occur during data loading
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading user data: $e")),
      );
    }
  }

  Future<void> _getImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      setState(() {
        _uploadImage();
      });
    }
  }

  Future<void> _uploadImage() async {
    if (selectedImage != null) {
      try {
        final addId = randomAlphaNumeric(10);
        final storageRef = FirebaseStorage.instance.ref().child("profileImages").child(addId);
        final uploadTask = storageRef.putFile(selectedImage!);

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        await SharedPreferenceHelper().saveUserProfile(downloadUrl);

        setState(() {
          profile = downloadUrl;
        });
      } catch (e) {
        // Handle any errors that occur during image upload
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading image: $e")),
        );
      }
    }
  }

  Future<void> _deleteUser() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Delete the user's account from Firebase
        await user.delete();

        // Clear any stored user data
        await SharedPreferenceHelper().clearUserData();

        // Navigate to the login page
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LogIn()),
              (Route<dynamic> route) => false,
        );
      } else {
        // Handle case where user is not signed in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No user is currently signed in.")),
        );
      }
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting account: $e")),
      );
    }
  }



  Future<void> _signOut() async {
    try {
      await AuthMethods().SignOut(); // Ensure method name matches implementation
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 40.0),
                    height: MediaQuery.of(context).size.height / 4.5,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width, 105.0
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5.5),
                      child: Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(60),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: selectedImage == null
                              ? GestureDetector(
                            onTap: _getImage,
                            child: profile == null
                                ? Image.asset("images/boy.jpg", height: 115, width: 115, fit: BoxFit.cover,)
                                : Image.network(profile!, height: 115, width: 115, fit: BoxFit.cover,),
                          )
                              : Image.file(selectedImage!, height: 115, width: 115, fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              _buildInfoCard(Icons.person, "Name", name!),
              SizedBox(height: 10.0),
              _buildInfoCard(Icons.email, "Email", email!),
              SizedBox(height: 10.0),
              _buildActionCard(Icons.delete, "Delete Account", _deleteUser),
              SizedBox(height: 10.0),
              _buildActionCard(Icons.logout, "Log Out", _signOut),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String content) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.black),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
