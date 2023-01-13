import 'dart:io';
import 'package:bolg_app/const/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../colors/colors.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {

    final postReference = FirebaseDatabase.instance.ref().child("Posts");
    // firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
    File? image;
    final formKey = GlobalKey<FormState>();
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    final picker = ImagePicker();
    FirebaseAuth auth = FirebaseAuth.instance;
    bool showSpinner = false;
    Future getImageGallery()async{
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if(pickedFile != null){
          image = File(pickedFile.path);
        }
        else{
          toastMessage("No Image Selected");
        }
      });
    }

    Future getCameraImage() async{
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        if(pickedFile != null){
          image = File(pickedFile.path);
        }
        else{
          toastMessage("No Image Selected");
        }
      });
    }

    void dialog(context) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        getCameraImage();
                        Navigator.pop(context);
                      },
                      child: const ListTile(
                        title: Text(
                          "Camera",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(Icons.camera_alt),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        getImageGallery();
                        Navigator.pop(context);
                      },
                      child: const ListTile(
                        title: Text(
                          "Gallery",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(Icons.photo),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appbarBackgroundColorAddBlog,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            "Add Blog",
            style: GoogleFonts.playfairDisplay(
              color: appBarTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width * 1,

                      child: image != null ? Image.file(
                        image!.absolute,
                      width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ): Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: containerBackgroundColor,
                              ),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: iconColorForImage,
                                size: 90,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Enter Blog Title here...",
                          labelText: "Title",
                          labelStyle: const TextStyle(color: Colors.black38),
                          hintStyle: const TextStyle(color: Colors.black38),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          errorStyle: TextStyle(color: textColor),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black54),
                          ),
                        ),
                        validator: (value) {
                          return value!.isEmpty
                              ? "Please Enter Blog Title"
                              : null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 5,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Enter the Details here...",
                          labelText: "Description",
                          labelStyle: const TextStyle(
                            color: Colors.black38,
                          ),
                          hintStyle: const TextStyle(color: Colors.black38),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          errorStyle: TextStyle(color: textColor),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black54),
                          ),
                        ),
                        validator: (value) {
                          return value!.isEmpty
                              ? "Please Enter Blog Title"
                              : null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      RoundButton(
                          title: "Upload Blog",
                          sizeOfText: 20,
                          onPressed: () async{

                            setState(() {
                              showSpinner = true;
                            });
                            try{

                              int date = DateTime.now().millisecondsSinceEpoch;

                              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref("/BlogApp $date");
                              UploadTask uploadTask = ref.putFile(image!.absolute);

                              await Future.value(uploadTask);
                              final User? user = auth.currentUser;

                              var newUrl = await ref.getDownloadURL();
                              postReference.child("Post List").child(date.toString()).set({

                                "pID" : date.toString(),
                                "pImage" : newUrl.toString(),
                                "pTime" : date.toString(),
                                "pTitle" : titleController.text.toString(),
                                "pDescription" : descriptionController.text.toString(),
                                "uEmail" : user!.email.toString(),
                                "uID" : user.uid.toString(),

                              }).then((value){
                                toastMessage("Post Published");
                                setState(() {
                                  showSpinner = false;
                                });
                              }).onError((error, stackTrace) {
                                setState(() {
                                  showSpinner = false;
                                });
                                toastMessage(error.toString());
                              });

                            }catch(e){
                              setState(() {
                                showSpinner = false;
                              });
                              toastMessage(e.toString());
                            }
                          }
        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: roundButtonBorderColor,
        textColor: textColor,
        fontSize: 16.0
    );
  }
}
