import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//enum para definir los estados del server

enum ServerStatus { Online, Offline, Connecting }

//ChangeNotifier notifica a los que este usando mi clase (hace que se redibujen)
class SocketService with ChangeNotifier {
  //se define la variable como privada para controlar que nadie mas cambie el valor
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  //retornamos el valor de nuestra variable privada
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;


  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    String urlSockets = 'http://10.0.2.2:5000';
    this._socket = IO.io(urlSockets, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true
    });

    this._socket.on("connect", (_) {
      print('Connected');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on("disconnect", (_) {
      print('Disconnected');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // this._socket.on("nuevo-mensaje", (payload) {
    //   print('nuevo-mesnaje: $payload');
    // });
  }
}
