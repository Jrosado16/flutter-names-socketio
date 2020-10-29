import 'package:bandnames_socketio/models/Bands.model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Bands> list = [
    Bands(id: 1, name: 'John Mayer', votes: 2),
    Bands(id: 2, name: 'Beatles', votes: 5),
    Bands(id: 3, name: 'Morat', votes: 3),
    Bands(id: 4, name: 'Mana', votes: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text('BanDs NaMes',
          style: TextStyle(color: Colors.black54),
        ),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return buildBands(list[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: () {
          addBands();
        },
      ),
    );
  }

  Widget buildBands(bands) {
    return Dismissible(
      key: Key(bands.id.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){

      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10.0),
        color: Colors.red,
        child: Text('Delete bands'),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[200],
          child: Text(bands.name.substring(0, 2))
        ),
        title: Text(bands.name),
        trailing: Text(bands.votes.toString()),
      ),
    );
  }

  addBands() {
    TextEditingController bandsController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('add Bands'),
          content: TextField(
            controller: bandsController,
          ),
          actions: [
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('add'),
              onPressed: () {
                print(bandsController.text);
                list.add(Bands(name: bandsController.text, votes: 5));
                setState(() {
                  
                });
              },
            ),
            MaterialButton(
              child: Text('close'),
              color: Colors.red[200],
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
