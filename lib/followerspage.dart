import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class User_Followers extends StatefulWidget {
  final String userId;
  const User_Followers({Key? key, required this.userId}) : super(key: key);

  @override
  State<User_Followers> createState() => _User_FollowersState();
}

class _User_FollowersState extends State<User_Followers> {
  List<dynamic> followers = [];
  bool isLoading = true;
  @override
  void initState(){
      super.initState();
      fetchfollowers();
  }

  Future<void> fetchfollowers() async{
    try{
      Uri url = Uri.parse("https://api.github.com/users/${widget.userId}/followers");
      final res = await http.get(url);
      if(res.statusCode==200){
        setState(() {
          followers = jsonDecode(res.body);
          isLoading = false;
        });
      }
    }
    catch (err){
      setState(() {
        isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_outlined), color: Colors.white,),
        title: Text("${widget.userId}'s Followers",style: TextStyle(color:Colors.white),),
      ),
      body: isLoading
      ? Center(child: CircularProgressIndicator(),)
      : followers.isEmpty
      ? Center(child: Text("No followers found"),)
      : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: ListView.builder(
          itemCount: followers.length,
          itemBuilder: (context,index){
            final follower = followers[index];
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
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(follower["avatar_url"]),
                  ),
                  title: Text(
                    follower["login"],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      )
    ,);
  }
}