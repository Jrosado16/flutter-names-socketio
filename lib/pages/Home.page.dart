import 'package:bandnames_socketio/models/Bands.model.dart';
import 'package:bandnames_socketio/services/socket.service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
// import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Bands> list = [
    // Bands(id: 1, name: 'John Mayer', votes: 2),
    // Bands(id: 2, name: 'Beatles', votes: 5),
    // Bands(id: 3, name: 'Morat', votes: 3),
    // Bands(id: 4, name: 'Mana', votes: 4),
  ];

  bandsmodify(){
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', (payload) {
      this.list = (payload as List)
      .map((e) => Bands.fromMap(e))
      .toList();
      setState(() {});
    });
  }

  @override
  void initState() {
    bandsmodify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final status = Provider.of<SocketService>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'BanDs NaMes',
          style: TextStyle(color: Colors.black54),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: (status.serverStatus == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.blue[300],)
                : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: Container(
        height: size.height * 1,
        // color: Colors.red[100],
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _pieChart(),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return newBands(list[index]);
                },
              ),
            ),
            // Text('hola')
          ],
        ),
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

  _pieChart(){

    Map<String, double> dataMap = new Map();
    list.forEach((e) => {
      dataMap.putIfAbsent(e.name, () => e.votes.toDouble())
    });

    return Container(
      // width: double.infinity,
      height: 200.0,
      child: PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      chartType: ChartType.ring,
      centerText: "VOTOS",
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: false,
      ),
    )
    );

  }

  Widget newBands(Bands bands) {
    final socketService = Provider.of<SocketService>(context);

    return Dismissible(
      key: Key(bands.id.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        socketService.socket.emit('delete-band', {'id': bands.id});
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
            child: Text(bands.name.substring(0, 2))),
        title: Text(bands.name),
        trailing: Text(bands.votes.toString()),
        onTap: () {
          print(bands.votes);
          socketService.socket.emit('vote-band', {'id': bands.id});
        },
      ),
    );
  }

  addBands() {
    TextEditingController bandsController = TextEditingController();
    final socketService = Provider.of<SocketService>(context, listen: false);
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
                socketService.socket.emit('add-band', {'name': bandsController.text});
                Navigator.pop(context);
                setState(() {});
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
