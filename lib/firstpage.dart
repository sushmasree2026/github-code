import 'package:flutter/material.dart';
import 'package:github_code/secondpage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController ctrl = TextEditingController();
  Map<String,dynamic> userData = {};
  Map<String,dynamic> data = {};
  bool _isloading = false;
  void _Load () async{
    setState(() {
      _isloading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isloading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 100,
                width: 100,
                child: ClipRRect(
                  child: Image(image: NetworkImage("https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png",),fit: BoxFit.cover,),
                ),
              ),
            ),
            Center(child: Text("GitHub",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)),
            SizedBox(height: 10,),
            TextField(
              controller: ctrl,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 2),
                )
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: GestureDetector(
                onTap: () async{
                  _Load();
                  await Future.delayed(Duration(seconds: 2));
                  if(ctrl.text.trim().isNotEmpty){
                    data = await getUserDetails(ctrl.text.trim());
                  }
                  if(data.isNotEmpty){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondScreen(userData: data)));
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.black,content: Text("Enter Valid Details",style: TextStyle(color: Colors.white),)));
                  }
                },
                child: Container(
                  height: 50,
                  width:120,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: _isloading==true ? 
                  Center(child: CircularProgressIndicator(color: Colors.white,),):
                  Center(child: Text("Search",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Map<String,dynamic>> getUserDetails(String userId) async{
    try{
      Uri url = Uri.parse("https://api.github.com/users/$userId");
      final res = await http.get(url);
      print(res);
      if(res.statusCode == 200){
        userData = jsonDecode(res.body);
        setState(() {
          
        });
        return jsonDecode(res.body);
      }
      return {};
      
    }catch(err){
      return {};
    }
  }
}