
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screen/add_todo.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/screen/edite_todo.dart';
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading=true;
  List items=[];

@override
  void initState() {
   fetchTodo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Todo App",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
      ),
      floatingActionButton:FloatingActionButton.extended(onPressed: (){ navigateToAddPage();}, label:Text("add") ),
      body: Visibility(
         visible: isLoading,
         child:  Center(child: CircularProgressIndicator(),),
         replacement:
         RefreshIndicator(
           onRefresh: fetchTodo,
          child: ListView.builder(
             itemCount: items.length,
              itemBuilder:(context,index){
                final item=items[index] as Map;
                final id=item['_id'] as String ;

                return ListTile(
                  leading: CircleAvatar(child: Text('${index+1}'),),
                  title: Text(item['title']),
                  subtitle: Text(item["description"]),
                  trailing: PopupMenuButton(
                        onSelected:(value) {
                          if(value=='edit'){
                            navigateToEditeToto();
                          } else if(value=='delete'){
                            //deleta and remouve
                            deleteById(id);
                          }
                        },
                      itemBuilder: (context){

                      return [
                        PopupMenuItem(
                            child: Text("Edite"),
                           value: 'edit',

                        ),
                        PopupMenuItem(
                            child: Text("Delete"),
                          value: 'delete',
                        ),
                      ];
                    }
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
 Future<void>  navigateToAddPage()async{
    final route=MaterialPageRoute(
      builder: (context)=>AddTodo(),

    );
   await Navigator.push(context as BuildContext, route);
   setState(() {
     isLoading=true;
   });
   fetchTodo();
  }
  void navigateToEditeToto( ){
    final route=MaterialPageRoute(
      builder: (context)=>EditeTodo(),

    );
    Navigator.push(context as BuildContext, route);
  }
 Future<void> deleteById( String id)async{
     final url="https://api.nstack.in/v1/todos/$id";
     final uri=Uri.parse(url);
     final respose= await http.delete(uri);
     if(respose.statusCode==200){
       final filtered=items.where((element) => element['_id'] !=id).toList();
        setState(() {
          items=filtered;
        });
       print("todo deleted successfully");
     }else{
     }
  }
  Future<void> fetchTodo()async{
    setState(() {
      isLoading=true;
    });
    final url="https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri=Uri.parse(url);
    final response=await http.get(uri);
    if(response.statusCode==200){
      final json=jsonDecode(response.body) as Map;
      final result=json['items'] as List;
      setState(() {
        items=result;
      });
    }
    setState(() {
      isLoading=false;
    });


  }
  void showErrorMessage(String message){
    final snackbar=SnackBar(content: Text(message,style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

