import 'package:bolg_app/colors/colors.dart';
import 'package:bolg_app/screens/add_post.dart';
import 'package:bolg_app/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final reference = FirebaseDatabase.instance.ref().child('Posts');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();
  String search = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.drag_handle),
          actions: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPostScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            InkWell(
              onTap: () {
                _auth.signOut().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                });
              },
              child: const Icon(
                Icons.logout,
                size: 30,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
          ],
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Blog App",
            style: GoogleFonts.playfairDisplay(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: searchController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    hintText: "Search with Blog Title...",
                    hintStyle: const TextStyle(color: Colors.black38),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 30,
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    errorStyle: TextStyle(color: textColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.purple),
                    )),
                onChanged: (String value) {
                  search = value;
                  setState(() {
                  });
                },
                validator: (value) {
                  return 'no Search Found';
                },
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query: reference.child('Post List'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  String tempTitle = snapshot.child("pTitle").value.toString();
                  if(searchController.text.isEmpty){
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width * 1,
                                    height:
                                    MediaQuery.of(context).size.height * 0.25,
                                    placeholder: "assets/placeholder.png",
                                    image:
                                    snapshot.child("pImage").value.toString(),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.02,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Title",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                      Text(
                                        snapshot.child("pTitle").value.toString(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Description",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                      Text(
                                        snapshot.child("pDescription").value.toString(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    );

                  }else if(tempTitle.toLowerCase().contains(searchController.text.toString())){
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width * 1,
                                    height:
                                    MediaQuery.of(context).size.height * 0.25,
                                    placeholder: "assets/placeholder.png",
                                    image:
                                    snapshot.child("pImage").value.toString(),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.02,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    snapshot.child("pTitle").value.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    snapshot.child("pDescription").value.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    );
                  }else{
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
