import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bolg_app/colors/colors.dart';
import 'package:bolg_app/const/round_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'home_page.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  final postRef = FirebaseDatabase.instance.ref().child("Posts");
  FirebaseStorage storage = FirebaseStorage.instance;

  File? _image;
  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        toastMessage("No Image Selected");
      }
    });
  }

  Future getCameraImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        toastMessage("No Image Selected");
      }
    });
  }
  
  void dialogAlert(context){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: SizedBox(
          height: 120,
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  getCameraImage();
                  Navigator.pop(context);
                },
                child: const ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Camera"),
                ),
              ),
              InkWell(
                onTap: (){
                  getImageGallery();
                  Navigator.pop(context);
                },
                child: const ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("Gallery"),
                ),
              )
            ],
          ),
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(title: const Text("Upload Blog"),
        centerTitle: true,
        backgroundColor: appbarBackgroundColorAddBlog,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    dialogAlert(context);
                  },
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width *1,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: _image != null ? ClipRRect(
                        child: Image.file(
                          _image!.absolute,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ):Container(
                        decoration: BoxDecoration(
                          color: containerBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 100,
                        height: 100,
                        child: const Icon(Icons.camera_alt_outlined,size: 80,color: Colors.blue,),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Form(
                  key: _formKey,
                    child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: "Title...",
                        labelText: "Title",
                        labelStyle: TextStyle(color: appBarTextColor,fontSize: 18,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue,width: 1,),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.greenAccent,width: 1,),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder:  OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue,width: 1,),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 6,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Description...",
                          labelText: "Description",
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          labelStyle: TextStyle(color: appBarTextColor,fontSize: 18,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue,width: 1,),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent,width: 1,),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        enabledBorder:  OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue,width: 1,),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    RoundButton(title: "Post Blog", onPressed: () async{
                      setState(() {
                        showSpinner = true;
                      });
                      try{
                        int date = DateTime.now().millisecondsSinceEpoch;

                        var refer = await FirebaseStorage.instance.ref("/blogapp$date").child('images').putFile(_image!.absolute);
                        TaskSnapshot uploadTask = refer;
                        await Future.value(uploadTask);
                        var newUrl =await refer.ref.getDownloadURL();
                        final User? user = _auth.currentUser;
                        postRef.child("Post List").child(date.toString()).set({
                          "pPostID": date.toString(),
                          "pImage" : newUrl.toString(),
                          "pTime": date.toString(),
                          "pTitle": titleController.text.toString(),
                          "pDescription": descriptionController.text.toString(),
                          "pEmail": user!.email,
                          "pId": user.uid,
                        }).then((value){
                          setState(() {
                            showSpinner = false;
                          });
                          toastMessage("Post Published");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage(),),);
                        }).onError((error, stackTrace) {
                          setState(() {
                            showSpinner = false;
                          });
                          toastMessage(error.toString());
                        });

                      }catch(e){
                        toastMessage(e.toString());
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },sizeOfText: 24,),
                  ],
                ),),
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
