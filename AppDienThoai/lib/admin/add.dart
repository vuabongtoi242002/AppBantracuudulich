import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

import '../service/database.dart';
import '../widget/widget_support.dart';

class AddCountry extends StatefulWidget {
  const AddCountry({super.key});

  @override
  State<AddCountry> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddCountry> {
  final List<String> countryitems = ['chau_a', 'chau_dai_duong', 'nam_mi', 'chau_au'];
  String? value;
  TextEditingController namecontroller = new TextEditingController();
  // TextEditingController pricecontroller = new TextEditingController();
  TextEditingController detailcontroller = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    selectedImage = File(image!.path);
    setState(() {});
  }

  uploadItem() async {
    if (selectedImage != null &&
        namecontroller.text != "" &&
        //pricecontroller.text != "" &&
        detailcontroller.text != "") {
      String addId = randomAlphaNumeric(10);

      Reference firebaseStorageRef =
      FirebaseStorage.instanceFor(bucket: "gs://manhapp-68c3e.appspot.com").ref().child("blogImages").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

      var downloadUrl = await (await task).ref.getDownloadURL();

      Map<String, dynamic> addItem = {
        "Image": downloadUrl,
        "Name": namecontroller.text,
        // "Price": pricecontroller.text,
        "Detail": detailcontroller.text
      };
      await DatabaseMethods().addWordItem(addItem, value!).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Thêm thành công hãy vào Firebase kiểm tra",
              style: TextStyle(fontSize: 18.0),
            )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color(0xFF373866),
            )),
        centerTitle: true,
        title: Text(
          "Add",
          style: AppWidget.HeadLineTextFeildStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tải hình ảnh",
                style: AppWidget.semBooldTextFeildStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              selectedImage == null
                  ? GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Center(
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border:
                        Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
                  : Center(
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Name",
                style: AppWidget.semBooldTextFeildStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Name",
                      hintStyle: AppWidget.LightTextFeildStyle()),
                ),
              ),
              // SizedBox(
              //   height: 30.0,
              // ),
              // Text(
              //   "Item Price",
              //   style: AppWidget.semBooldTextFeildStyle(),
              // ),
              // SizedBox(
              //   height: 10.0,
              // ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20.0),
              //   width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //       color: Color(0xFFececf8),
              //       borderRadius: BorderRadius.circular(10)),
              //   child: TextField(
              //     controller: pricecontroller,
              //     decoration: InputDecoration(
              //         border: InputBorder.none,
              //         hintText: "Enter Item Price",
              //         hintStyle: AppWidget.LightTextFeildStyle()),
              //   ),
              // ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Detail",
                style: AppWidget.semBooldTextFeildStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  maxLines: 6,
                  controller: detailcontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Detail",
                      hintStyle: AppWidget.LightTextFeildStyle()),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Chọn châu lục",
                style: AppWidget.semBooldTextFeildStyle(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: countryitems
                          .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style:
                            TextStyle(fontSize: 18.0, color: Colors.black),
                          )))
                          .toList(),
                      onChanged: ((value) => setState(() {
                        this.value = value;
                      })),
                      dropdownColor: Colors.white,
                      hint: Text("Chọn châu lục"),
                      iconSize: 36,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: value,
                    )),
              ),
              SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: (){
                  uploadItem();
                },
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Thêm quốc gia",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}