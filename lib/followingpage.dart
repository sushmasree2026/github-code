import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class User_Following extends StatefulWidget {
  final String userId;
  const User_Following({Key? key, required this.userId}) : super(key: key);

  @override
  State<User_Following> createState() => _User_FollowingState();
}

class _User_FollowingState extends State<User_Following> {
  List<dynamic> following = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFollowing();
  }
  Future<void> fetchFollowing() async {
    try {
      Uri url = Uri.parse("https://api.github.com/users/${widget.userId}/following");
      final res = await http.get(url);
      if (res.statusCode == 200) {
        setState(() {
          following = jsonDecode(res.body);
          isLoading = false;
        });
      }
    } catch (err) {
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
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_outlined),color: Colors.white,),
        title: Text("${widget.userId}'s Following",style: TextStyle(color:Colors.white),),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : following.isEmpty
          ? Center(child: Text("No following found."))
          : Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
                    itemCount: following.length,
                    itemBuilder: (context, index) {
            final follower = following[index];
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
          ),
    );
  }
}