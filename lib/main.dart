import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bandnames_socketio/services/socket.service.dart';
import 'package:bandnames_socketio/pages/Home.page.dart';
import 'package:bandnames_socketio/pages/Status.page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService())
      ],
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
          'status': (_) => StatusPage(),
        }
      ),
    );
  }
}