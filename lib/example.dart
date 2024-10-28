import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class apiiintegrationn extends StatefulWidget {
  const apiiintegrationn({super.key});

  @override
  State<apiiintegrationn> createState() => _HomeState();
}

class _HomeState extends State<apiiintegrationn> {
  final userCtrl = TextEditingController();
  Map<String, dynamic> userData = {};
  bool isLoading = false; // Loading indicator state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Image(
              image: NetworkImage(
                  "https://tse4.mm.bing.net/th?id=OIP.8SVgggxQcO5L6Dw_61ac4QHaEK&pid=Api&P=0&h=180"),
              height: 200,
              width: 200,
            ),
            Text('Git Hub', style: TextStyle(fontSize: 15)),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: userCtrl,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "gharshitha1712",
                    focusColor: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  if (userCtrl.text.isNotEmpty) {
                    setState(() {
                      isLoading = true; // Show loading indicator
                    });
                    Map<String, dynamic> data =
                    await getUserDetails(userCtrl.text.trim());
                    setState(() {
                      isLoading = false; // Hide loading indicator
                    });
                    if (data.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsPage(userData: data),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  height: 55,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(
                      "Get Details",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      Uri url = Uri.parse("https://api.github.com/users/$userId");
      final res = await http.get(url);
      print(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      return {};
    } catch (err) {
      return {};
    }
  }
}

class UserDetailsPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserDetailsPage({Key? key, required this.userData}) : super(key: key);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  List<dynamic> repositories = [];
  bool isLoadingRepos = true;

  @override
  void initState() {
    super.initState();
    fetchRepositories();
  }

  Future<void> fetchRepositories() async {
    try {
      Uri url = Uri.parse("https://api.github.com/users/${widget.userData["login"]}/repos");
      final res = await http.get(url);
      if (res.statusCode == 200) {
        setState(() {
          repositories = jsonDecode(res.body);
          isLoadingRepos = false;
        });
      }
    } catch (err) {
      setState(() {
        isLoadingRepos = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Visibility(
            visible: widget.userData.isNotEmpty,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Image(
                          image: NetworkImage("${widget.userData["avatar_url"] ?? ""}"),
                          height: 100,
                          width: 100,
                        ),
                        Text("${widget.userData["login"] ?? "User NotFound"}"),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FollowersPage(
                                          userId: widget.userData["login"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "${widget.userData["followers"] ?? "User NotFound"}",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text("Followers")
                              ],
                            ),
                            SizedBox(width: 70),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FollowingPage(
                                          userId: widget.userData["login"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "${widget.userData["following"] ?? "User NotFound"}",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text("Following")
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text("Repositories - ${widget.userData["public_repos"] ?? 0}"),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                isLoadingRepos
                    ? CircularProgressIndicator()
                    : repositories.isEmpty
                    ? Text("No repositories found.")
                    : ListView.builder(
                  shrinkWrap: true,
                  itemCount: repositories.length,
                  itemBuilder: (context, index) {
                    final repo = repositories[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(80)),
                            child: ListTile(
                              title: Text(
                                repo["name"],
                                style: TextStyle(color: Colors.white), // Set text color to white
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10), // Add space between list items
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class FollowersPage extends StatefulWidget {
  final String userId;

  const FollowersPage({Key? key, required this.userId}) : super(key: key);

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  List<dynamic> followers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFollowers();
  }

  Future<void> fetchFollowers() async {
    try {
      Uri url = Uri.parse("https://api.github.com/users/${widget.userId}/followers");
      final res = await http.get(url);
      if (res.statusCode == 200) {
        setState(() {
          followers = jsonDecode(res.body);
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
      appBar: AppBar(backgroundColor: Colors.black,
        title: Text("${widget.userId}'s Followers",style: TextStyle(color:Colors.white),),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : followers.isEmpty
          ? Center(child: Text("No followers found."))
          : ListView.builder(
        itemCount: followers.length,
        itemBuilder: (context, index) {
          final follower = followers[index];
          return Container(
            color: Colors.black, // Set background color to black
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(follower["avatar_url"]),
              ),
              title: Text(
                follower["login"],
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          );
        },
      ),
    );
  }
}

class FollowingPage extends StatefulWidget {
  final String userId;

  const FollowingPage({Key? key, required this.userId}) : super(key: key);

  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
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
      appBar: AppBar(backgroundColor: Colors.black,
        title: Text("${widget.userId}'s Following",style: TextStyle(color:Colors.white),), // Fixed the title
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : following.isEmpty
          ? Center(child: Text("No following found."))
          : ListView.builder(
        itemCount: following.length,
        itemBuilder: (context, index) {
          final follower = following[index];
          return Container(
            color: Colors.black, // Set background color to black
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(follower["avatar_url"]),
              ),
              title: Text(
                follower["login"],
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          );
        },
      ),
    );
  }
}