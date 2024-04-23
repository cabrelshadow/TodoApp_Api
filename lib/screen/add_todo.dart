import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController=TextEditingController();
  TextEditingController DescriptionController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Add Todo"),
          centerTitle: true,
        ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Tile'),
            controller: titleController,
          ),
          TextField(
            decoration: InputDecoration( hintText: "description"),
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            minLines: 5,
            controller: DescriptionController,
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: submitData, child: Text("submit"),

            ),

        ],

      ),
    );
  }
  Future<void> submitData()async{
    //get the data from form
    final title=titleController.text;
    final description=DescriptionController.text;
    final body1={
        "title": title,
        "description":description,
        "is_completed": false,
    };
    //submit to the server
    final url='https://api.nstack.in/v1/todos';
    final uri=Uri.parse(url);
     final response=await http.post(uri,body: jsonEncode(body1),
       headers: {
         'Content-Type': 'application/json'
       }
     );
    // show success message to users
    if(response.statusCode==201){
      titleController.text="";
      DescriptionController.text="";
      showSuccessMessage('creation success');

    }else{
        showErrorMessage("faild to create");
    }

  }
  void showSuccessMessage(String message){
    final snackbar=SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  void showErrorMessage(String message){
    final snackbar=SnackBar(content: Text(message,style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
