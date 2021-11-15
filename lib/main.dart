import 'package:flutter/material.dart';

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
      home: MyHomePage(),
      debugShowCheckedModeBanner: false, // ful och äcklig, bort med dig
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
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
            todoObject('Write a book', false),
            todoObject('Do homework', false),
            todoObject('Tidy room', true),
            todoObject('Watch TV', false),
            todoObject('Nap', false),
            todoObject('Shop groceries', false),
            todoObject('Have fun', false),
            todoObject('Meditate', false),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()));
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
Container todoObject(String TodoText, bool Completed) {
  return Container(
    width: double.infinity,
    height: 72,
    decoration: todoBorder(),
    child: Row(
      children: [
        checkBox(Completed),
        Text(TodoText,
            // borde kanske brytas ut till en egen funktion med if-sats istället
            style: (Completed)
                ? TextStyle(decoration: TextDecoration.lineThrough)
                : null),
        Spacer(),
        trashCan()
      ],
    ),
  );
}

// Checkboxen till todo-objektet todoObject
Container checkBox(bool Completed) {
  return Container(
    width: 72,
    child: Center(
      child: Checkbox(
        value: Completed,
        onChanged: null,
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
