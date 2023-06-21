import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Constraints/Colors.dart';
import 'package:flutter_application_1/todo.dart';
import 'package:flutter_application_1/todo_item.dart';
void main() {
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor:Colors.transparent ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoApp(),
    );
  }
}

class ToDoApp extends StatefulWidget {
   ToDoApp({super.key});

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
   final todoList = ToDo.todoList();
   List<ToDo> foundToDo = []; 
   final todoController = TextEditingController();

   @override
  void initState() {
    foundToDo = todoList;
    super.initState();
  } 

  void deleteToDoItem(String id){
      setState(() {
        todoList.removeWhere((item) => item.id == id);
      });
  }

   void handleToDoChange(ToDo todo){
      setState(() {
        todo.isDone = !todo.isDone;
      });
    }
  
  void addToDoItem(String toDo ) {
    setState(() {
      todoList.add(ToDo(id: DateTime.now().microsecondsSinceEpoch.toString(), todoText: toDo));
    });
    todoController.clear();
  }

  void runFilter(String enteredKeyword){
    List<ToDo> results = [];
    if(enteredKeyword.isEmpty){
      results = todoList;
    } else {
      results = todoList.where((item) => item.todoText!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    setState(() {
     foundToDo = results; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
               
                Container(
      
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextField(
                    onChanged: ((value) => runFilter(value) ),
                    controller: todoController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(
                        Icons.search,
                        color: tdBlack,
                        size: 20,
                        ),
                        prefixIconConstraints: BoxConstraints(
                          maxHeight: 20,
                          minWidth: 25
                          ),
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(color: tdGrey),
      
                    ),
                  ),
                ),
                 Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 20,
                          bottom: 20
                          ),
                        child: Text(
                          'All ToDos',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,),)
                        ),
                        for(ToDo todoo in foundToDo)
                        ToDoItem(
                          todo: todoo,
                          onToDoChanged: handleToDoChange,
                          onDeleteItem: deleteToDoItem,
                        )
                        
                    ],
                  ),
                )
              ]
              ,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(child: Container(
              margin: EdgeInsets.only(
                bottom: 20,
                right: 20,
                left: 20
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0,0.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                   )],
              borderRadius: BorderRadius.circular(10)
              ),
                child: TextField(
                  controller: todoController,
                  decoration: InputDecoration(
                    hintText: 'Add a new todo item',
                    border: InputBorder.none
                  ),
                ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  child:Text('+', style: TextStyle(fontSize: 40),), 
                  onPressed: (){
                    addToDoItem(todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: tdBlue,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),
              ),
            ],)
          ),
        ],
      ),          
      appBar: AppBar(

        backgroundColor: tdBGColor,
        title: Row(children: [
          Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,),
          Container(
            height: 40,
            width: 40,)
        ],),
      )
      
    );
    // ignore: dead_code
    
  }
}
