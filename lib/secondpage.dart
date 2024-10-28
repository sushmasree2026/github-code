import 'package:flutter/material.dart';
import 'package:github_code/firstpage.dart';
import 'package:github_code/followerspage.dart';
import 'followingpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class SecondScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const SecondScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<dynamic> userRepos = [];
  List<Map<String,dynamic>> data =[];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getUserReposDetails();
  }
  Future<void> getUserReposDetails() async{
    try{
      Uri url = Uri.parse("https://api.github.com/users/${widget.userData["login"]}/repos");
      final res = await http.get(url);
      if(res.statusCode == 200){
        setState(() {
          userRepos = jsonDecode(res.body);
          isLoading = false;
        });
      }
    }catch(err){
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://avatars.githubusercontent.com/u/9919?s=280&v=4"),
          ),
        title: Center(child: Text("${widget.userData["login"]}",style: TextStyle(color: Colors.white),)),
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context,MaterialPageRoute(builder: (context)=>FirstScreen()));
          }, icon: Icon(Icons.logout_outlined),color: Colors.white,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image(image: NetworkImage("${widget.userData["avatar_url"]}")),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>User_Following(userId: widget.userData["login"])));
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Following",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),),
                          Text("${widget.userData["following"]}",style: TextStyle(fontSize: 17),),
                        ],
                      ),
                    ),
                  ),
                  IntrinsicHeight(
                    child: Container(
                      height: 45,
                      width: 20,
                      child: VerticalDivider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>User_Followers(userId: widget.userData["login"],)));
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Followers",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),),
                          Text("${widget.userData["followers"]}",style: TextStyle(fontSize: 17),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Repositories:   ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),),
                  Container(
                    height: 50,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Text("${widget.userData["public_repos"]}",style: TextStyle(fontSize: 17,color: Colors.white),))
                  )
                ],
              ),
            ),
            SizedBox(height: 15,),
            Expanded(
              child: ListView.builder(
                itemCount: userRepos.length,
                itemBuilder: (context, index) {
                  final user = userRepos[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                      ),
                      child: ListTile(
                        title: Text(user["name"],style: TextStyle(color: Colors.white),),
                        trailing: IconButton(onPressed: (){}, icon: Icon(Icons.copy_outlined),color: Colors.white,),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  
}