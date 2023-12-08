import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ConnectivityProvider extends ChangeNotifier{

    Connectivity connectivity = new Connectivity();

    bool _isOnline= false;

    bool get isOnline => _isOnline;

    startMonitioring() async{
      await initConnectivity();
      connectivity.onConnectivityChanged.listen((result) async{
        if(result ==ConnectivityResult.none){
          _isOnline = false;
          notifyListeners();
        }else{
            await updateConnectionStatus().then((bool isConnectedd){
            _isOnline = isConnectedd;
                notifyListeners();
            });
        }
      }
      );
    }

    Future<void> initConnectivity() async{
      try{
        var status =await connectivity.checkConnectivity();
        if(status ==  ConnectivityResult.none){
              _isOnline =false;
              notifyListeners();
        }else{
            _isOnline =true;
            notifyListeners();
        }
      }on PlatformException catch(e){
        print("Platform Exception"+ e.toString());
      }
    }

    Future<bool> updateConnectionStatus() async{

      bool isConnected=false;
      try{
        final List<InternetAddress> result =await InternetAddress.lookup('google.com');
        if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
          isConnected = true;
        }
      }on SocketException catch(_){
        isConnected= false;
      }
      return isConnected;

    }
}