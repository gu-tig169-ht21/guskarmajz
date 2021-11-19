import 'package:flutter/material.dart';

//import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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

class TodoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoPageState();
  }
}

class TodoPageState extends State<StatefulWidget> {
  int _counter = 0;
  List<TodoObject> todoObjects = [
    TodoObject('Write a book', false),
    TodoObject('Do homework', false),
    TodoObject('Tidy room', true),
    TodoObject('Watch TV', false),
    TodoObject('Nap', false),
    TodoObject('Shop groceries', false),
    TodoObject('Have fun', false),
    TodoObject('Meditate', false),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TIG169 TODO'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: Center(
        child: Container(
            //color: Colors.amber,
            //width: double.infinity,
            //height: 48.0,
            child: Column(
          children: [
            // fixa nycklar till parametrarna kanske?
            for (var todoTile in todoObjects)
              TodoWidget(todoTile.todoText, todoTile.completed, todoTile),

            Text('$_counter'),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigator.push(context,
          //    MaterialPageRoute(builder: (context) => AddTaskScreen()));
          setState(() {
            ++_counter;
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey,
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
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
            ),
          ),
          TextButton.icon(
            onPressed: () {},
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
                    todoObject.completed = finished;
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
          trashCan()
        ],
      ),
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
Container trashCan() {
  return Container(
    width: 72,
    child: Center(
      child: Text("Delete"),
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
