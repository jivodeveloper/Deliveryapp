import 'dart:async';
import 'package:crm_flutter/ui/Dashboard.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crm_flutter/ui/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'DeliveryData.dart';

class SplashScreen extends StatefulWidget {
  var prefs;
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {

  bool _visible = true;


  @override
  void initState() {
   super.initState();
     nextscreen();
    //   Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: LoginScreen()));


    // Timer(
    //        Duration(seconds: 3),
    //            () => Navigator.push(
    //              context,
    //              PageTransition(
    //                  type: PageTransitionType.rightToLeft,
    //                  child: LoginScreen(),
    //                  inheritTheme: true,
    //                  ctx: context),
    //            ));
    //    Timer(Duration(seconds: 3), () =>Navigator.of(context).push(SwipeablePageRoute(
    //      builder: (BuildContext context) => LoginScreen(),
    //    )));

       // Navigator.push(
       //     context, PageTransition(type: PageTransitionType.leftToRight, child: LoginScreen()));
       // Timer(
       //     Duration(seconds: 3),
       //         () => Navigator.push(
       //         context, ( child: LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Container(

            child: Image.asset('assets/Images/logo.png', height: 200, width: 200),
          ),
        )
      ),
    );
  }

  void nextscreen() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("intenet",true);
    if(prefs.getInt('empid')!=0 && prefs.getInt('empid')!=null){

      Timer(
          Duration(seconds: 3),
              () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DeliveryData())));

    }else{

      Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).push(_createRoute()));

    }

  }
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>  LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}


