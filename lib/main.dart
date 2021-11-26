//import 'dart:js'; //????

//import 'dart:html';

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());

  //getTodos();
}

// testfunktion
Future<void> getTodos() async {
  const String apiKey = '?key=47a3ee96-cd50-4bac-9f54-e2c6719e7c65';
  const String apiServer = 'https://todoapp-api-pyq5q.ondigitalocean.app/todos';

  var object = {"id": "", "title": "hello", "done": false};

  var body = jsonEncode(object);

  var response = await http.post(Uri.parse('$apiServer$apiKey'),
      headers: {"Content-Type": "application/json"}, body: body);
  http.Response todoList = await http.get(Uri.parse('$apiServer$apiKey'));
  var list = jsonDecode(todoList.body);
  print(list);
  print('stuff');
}

// koden lika stökig som lägenheten haahaahahahahahahahaa 🤣🤣🤣🤣🤣🤣

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIG169 TODO',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: TodoPage(),
      debugShowCheckedModeBanner: false, // ful och äcklig, bort med dig
    );
  }
}

class TodoState extends ChangeNotifier {
  List<TodoObject> todoObjects = [];
  // om man gör bool till nullable kan den tekniskt sett ha 3 värden
  // säkert jätteharam men det skiter jag i :)
  // null = visa alla, true = visa klara, false = visa icke klara
  bool? filterMode;
  HTTPHandler httpHandler = HTTPHandler();

  TodoState() {
    updateTodo();
  }

  void addTodo(String todoText) {
    httpHandler.addTodo(todoText).then((_) => updateTodo());
  }

  void removeTodo(TodoObject todoObject) {
    httpHandler.deleteTodo(todoObject).then((_) => updateTodo());
  }

  void updateTodo() {
    //print('starting update');
    httpHandler.getTodos().then((jsonList) {
      //print('doing update');
      todoObjects = jsonList.map((i) => TodoObject.fromJson(i)).toList();
      //print('did update');
      notifyListeners();
    });

    //print('finished update');
  }

  void changeTodo(TodoObject todoObject) {
    httpHandler.updateTodo(todoObject).then((_) => updateTodo());
  }

  void updateFilter(bool? newFilter) {
    filterMode = newFilter;
    notifyListeners();
  }
}

class TodoPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoState(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text('TIG169 TODO'),
          centerTitle: true,
          actions: [
            PopupMenuButton(itemBuilder: (_) {
              TodoState todoState =
                  Provider.of<TodoState>(context, listen: false);
              return <PopupMenuItem>[
                PopupMenuItem(
                  child: Text('Done'),
                  onTap: () => todoState.updateFilter(true),
                ),
                PopupMenuItem(
                  child: Text('Not done'),
                  onTap: () => todoState.updateFilter(false),
                ),
                PopupMenuItem(
                  child: Text('All'),
                  onTap: () => todoState.updateFilter(null),
                ),
              ];
            }),
          ],
        ),
        body: Center(
          child: Container(
              //color: Colors.amber,
              //width: double.infinity,
              //height: 48.0,
              child: Consumer<TodoState>(
            builder: (context, state, child) => Column(
              children: [
                // filterfunktion, väldigt cringe
                for (var todoTile in state.todoObjects)
                  if (state.filterMode == null)
                    TodoWidget(todoTile.todoText, todoTile.completed, todoTile)
                  else if (state.filterMode == todoTile.completed)
                    TodoWidget(todoTile.todoText, todoTile.completed, todoTile),
              ],
            ),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            TodoState theTodoState = Provider.of<TodoState>(
              context,
              listen: false,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                // provider som parameter, känns ultra-haram
                builder: (context) => AddTaskScreen(theTodoState),
              ),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  String _todoText = '';
  final TodoState _todoState;

  AddTaskScreen(this._todoState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new TODO'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'New TODO',
              ),
              onChanged: (text) {
                _todoText = text;
              },
            ),
          ),
          TextButton.icon(
            onPressed: () {
              if (_todoText != '') {
                _todoState.addTodo(_todoText);
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.add, size: 18),
            label: Text("Add TODO"),
          )
        ],
      ),
    );
  }
}

// Ett todo-objekt
class TodoObject {
  String todoID;
  String todoText;
  bool completed;

  TodoObject(this.todoID, this.todoText, this.completed);

  factory TodoObject.fromJson(Map<String, dynamic> json) {
    return TodoObject(json['id'], json['title'], json['done']);
  }
}

// En todo-widget
class TodoWidget extends StatelessWidget {
  final String todoText;
  final bool completed;
  TodoObject todoObject;

  TodoWidget(this.todoText, this.completed, this.todoObject);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoState>(
      builder: (context, state, child) {
        return Container(
          width: double.infinity,
          height: 72,
          decoration: todoBorder(),
          child: Row(
            children: [
              Container(
                width: 72,
                child: Center(
                  child: Checkbox(
                    value: completed,
                    onChanged: (finished) {
                      if (finished != null) {
                        // är todoObject en referensvariabel??!?
                        // jag vet inte vad som händer, men dart gör tydligen det, så...
                        todoObject.completed = finished;
                        state.changeTodo(todoObject);
                      }
                    },
                  ),
                ),
              ),
              Text(todoText,
                  // borde kanske brytas ut till en egen funktion med if-sats istället
                  style: (completed)
                      ? TextStyle(decoration: TextDecoration.lineThrough)
                      : null),
              Spacer(),
              trashCan(state, todoObject)
            ],
          ),
        );
      },
    );
  }
}

// Checkboxen till todo-objektet todoObject
Container checkBox(bool completed, TodoObject myParent) {
  return Container(
    width: 72,
    child: Center(
      child: Checkbox(
        value: completed,
        onChanged: (finished) {
          if (finished != null) {
            myParent.completed = finished;
          }
        },
      ),
    ),
  );
}

// Papperskorg till todo-objektet
Container trashCan(TodoState state, TodoObject todoObject) {
  return Container(
    width: 72,
    child: Center(
      child: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => state.removeTodo(todoObject),
      ),
    ),
  );
}

BoxDecoration todoBorder() {
  return const BoxDecoration(
    border: Border(
      bottom: BorderSide(width: 1.0, color: Colors.grey),
    ),
  );
}

class HTTPHandler {
  // 47a3ee96-cd50-4bac-9f54-e2c6719e7c65
  final String apiKey = '?key=47a3ee96-cd50-4bac-9f54-e2c6719e7c65';
  final String apiServer = 'https://todoapp-api-pyq5q.ondigitalocean.app/todos';

  Future<List> getTodos() async {
    http.Response response = await http.get(Uri.parse('$apiServer$apiKey'));

    return jsonDecode(response.body);
  }

  Future<void> addTodo(String todoText) async {
    var todoObject = {"id": "", "title": todoText, "done": false};
    //print('made $todoObject');
    var body = jsonEncode(todoObject);
    //print('encoded $body');
    await http.post(Uri.parse('$apiServer$apiKey'),
        headers: {"Content-Type": "application/json"}, body: body);
    //print('sent todo');
  }

  Future<void> updateTodo(TodoObject todoObject) async {
    String apiObject = '/${todoObject.todoID}';
    // skapar nytt objekt eftersom använder gamla variabelnamn, rip
    var todoJson = {
      "id": todoObject.todoID,
      "title": todoObject.todoText,
      "done": todoObject.completed
    };
    //print('kom inte långt asså');
    await http.put(Uri.parse('$apiServer$apiObject$apiKey'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(todoJson));
  }

  Future<void> deleteTodo(TodoObject todoObject) async {
    String apiObject = '/${todoObject.todoID}';
    await http.delete(Uri.parse('$apiServer$apiObject$apiKey'));
    //print('deleted object');
  }
}

/*
{
  "id": "ca3084de-4424-4421-98af-0ae9e2cb3ee5",
  "title": "Must pack bags",
  "done": false
}
*/