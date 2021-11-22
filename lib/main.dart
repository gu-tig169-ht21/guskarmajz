import 'dart:js';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

// ber om ursäkt till vem det än är som behöver läsa igenom denna tågkrasch :)

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

  TodoState() {
    todoObjects = [
      TodoObject('Write a book', false),
      TodoObject('Do homework', false),
      TodoObject('Tidy room', true),
      TodoObject('Watch TV', false),
      TodoObject('Nap', false),
      TodoObject('Shop groceries', false),
      TodoObject('Have fun', false),
      TodoObject('Meditate', false),
    ];
  }

  void addTodo(String todoText) {
    todoObjects.add(TodoObject(todoText, false));
    notifyListeners();
  }

  void removeTodo(String todoText) {
    // tar bort alla objekt med samma namn, oj då!
    todoObjects.removeWhere((todo) => todo.todoText == todoText);
    notifyListeners();
  }

  void updateTodo() {
    notifyListeners();
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
  String todoText;
  bool completed;

  TodoObject(this.todoText, this.completed);
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
                        state.updateTodo();
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
              trashCan(state, todoText)
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
Container trashCan(TodoState state, String todoText) {
  return Container(
    width: 72,
    child: Center(
      child: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => state.removeTodo(todoText),
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
