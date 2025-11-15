import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Este gestor usa connectivity_plus para notificar el estado de la red.
class PWAManager extends ChangeNotifier {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  
  // Es online si la conexion es WiFi, Movil o Ethernet, excluyendo Bluetooth.
  bool get isOnline => _connectionStatus != ConnectivityResult.none && _connectionStatus != ConnectivityResult.bluetooth;

  PWAManager() {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (_connectionStatus != result) {
        _connectionStatus = result;
        notifyListeners(); 
      }
      
      if (isOnline) {
        print('Conexion recuperada.');
      } else {
        print('Trabajando en modo Offline.');
      }
    });
  }
}