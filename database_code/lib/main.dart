import 'package:firebase_core/firebase_core.dart';
import 'AuthChange.dart';
import 'firebase_options.dart';
import 'firestore_db.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthChange(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _taskType = TextEditingController();
  final _taskName = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
        ),
        body:
        StreamBuilder(
          stream: FirestoreDB().fetchAllTeasks(),
          builder: (context,snap){
            if(snap.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            else if(snap.hasData){
              return ListView.builder(
                  itemCount: snap.data!.docs.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      leading: Checkbox(
                        value: snap.data!.docs[index]['isDone'],
                        onChanged: (bool? value){
                          FirestoreDB().toggleIsDone(snap.data!.docs[index].id, value!);
                        },
                      ),
                      title: Text("${snap.data!.docs[index]["taskType"] ?? ""}",
                        style: TextStyle(fontSize: 20),),
                      subtitle: Text("${snap.data!.docs[index]["task"] ?? ""}",
                        style: TextStyle(fontSize: 20),),
                      trailing: IconButton(
                        onPressed: () async{
                          await FirestoreDB().deleteTask(snap.data!.docs[index].id);
                        },
                        icon: Icon(Icons.delete_outline,),
                      ),
                    );
                  });
            }
            else{
              return Center(
                child: Text("No data found"),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          showAddNewTaskPopUp();
        },child: Icon(Icons.add),),
      ),
    );
  }

  void showAddNewTaskPopUp() {
    setState(() {
      _taskType.clear();
      _taskName.clear();
    });
    showDialog(context: context, builder:(context){
      return Form(
        key: _key,
        child: AlertDialog(
          title: Text("Add New Task"),
          content: Column(
            children: [
              TextFormField(
                controller: _taskType,
                decoration: InputDecoration(
                    hintText: "Class",
                    border: OutlineInputBorder()
                ),
                validator: (val)=> val!.isEmpty ? "please enter the Task type" : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _taskName,
                maxLines: 3,
                validator: (val)=> val!.isEmpty ? "please enter the Task" : null,
                decoration: InputDecoration(
                    hintText: "Drive Ready Flutter",
                    border: OutlineInputBorder()
                ),
              )
            ],
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Cancel")),
            TextButton(onPressed: () async{
              if(_key.currentState!.validate()){
                await FirestoreDB().addTodo(
                    _taskType.text.trim(),
                    _taskName.text.trim()
                );
                Navigator.pop(context);
              }

            }, child: Text("Add")),
          ],
        ),
      );
      });
    }
}