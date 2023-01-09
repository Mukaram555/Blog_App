import 'dart:io' as i;
import 'package:bolg_app/const/round_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors/colors.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    i.File? imageFile;
    final formKey = GlobalKey<FormState>();
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    void dialog(context){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                InkWell(
                  onTap: (){

                  },
                  child: const ListTile(
                    title: Text("Camera",style: TextStyle(fontWeight: FontWeight.bold),),
                    leading: Icon(Icons.camera_alt),
                  ),
                ),

                InkWell(
                  onTap: (){

                  },
                  child: const ListTile(
                    title: Text("Gallery",style: TextStyle(fontWeight: FontWeight.bold),),
                    leading: Icon(Icons.photo),
                  ),
                ),
              ],
            )
          ),
        );
      });
    }

    return Scaffold(
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
                onTap: (){
                  dialog(context);
                },
                child: Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * 1,
                    child: imageFile == null
                        ? Container(
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
                          )
                        : Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.04,
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
                      return value!.isEmpty ? "Please Enter Blog Title" : null;
                    },
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.04,
                  ),

                  TextFormField(
                    controller: descriptionController,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: "Enter the Details here...",
                      labelText: "Description",
                      labelStyle: const TextStyle(color: Colors.black38,),
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
                      return value!.isEmpty ? "Please Enter Blog Title" : null;
                    },
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.04,
                  ),

                  RoundButton(title: "Upload Blog",sizeOfText: 20, onPressed: (){
                    if(formKey.currentState!.validate()){
                    }
                  }),
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
