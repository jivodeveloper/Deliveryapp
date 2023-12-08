import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:crm_flutter/Model/MenuList.dart';
import 'package:crm_flutter/ui/DeliveryData.dart';
import 'package:expandable/expandable.dart';
import 'package:http/http.dart' as http;
import 'package:crm_flutter/ui/DailyData.dart';
import 'package:crm_flutter/ui/LoginScreen.dart';
import 'package:crm_flutter/Model/User.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return DashBoardState();
  }

}

class DashBoardState extends State<Dashboard> {

    String user="";
    List<MenuList> tags = [];
    List<String> menu_name = [];
    List<int> menu_id = [];
    List<String> sub_menu = [];
    List<int> parent_id = [];
    HashMap map1 = new HashMap<int, String>();
    late Future<HashMap<dynamic,dynamic>> futuremenu;
    bool admin_visiblity = false;
    bool delivery_boy_visiblity = false;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    List<StaggeredTile> _cardTile = <StaggeredTile>[
      StaggeredTile.count(2, 1.4),
      StaggeredTile.count(2, 1.4),
      StaggeredTile.count(2, 1.4),
      StaggeredTile.count(2, 1.4),
    ];

    Future<bool> _onBackPressed() async{

      return await showDialog<bool>(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to Logout?'),
          actions: <Widget>[

            Row(
              children: [

                Expanded(
                  child: new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                        decoration: BoxDecoration(
                        color: const Color(0xff18325e),
                        borderRadius:
                        BorderRadius.all(Radius.circular(15.0)),
                      ),
                      width: double.infinity,
                      height: 40 ,
                      child: Align(
                          alignment: Alignment.center,
                          child:  Text("No",style: TextStyle(color: Colors.white),)
                         )
                       ),
                    )
                  ),
                ),

                Expanded(
                  child:  new GestureDetector(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>LoginScreen())),
                    child: Padding(padding: EdgeInsets.all(5),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff18325e),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                                ),
                                width: double.infinity,
                                height: 40 ,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text("Yes",style: TextStyle(color: Colors.white),)
                        )
                      ),
                    )
                  ),
                )

              ],
            )

          ],
        ),
      ) ?? false;

    }

    @override
    void didChangeDependencies() {

      // progressDialog = ArsProgressDialog(
      //     context,
      //     blur: 2,
      //     backgroundColor: Color(0x33000000),
      //     animationDuration: Duration(milliseconds: 500));

    }

    @override
    void initState() {
      super.initState();
      getuser();
      fetchPost();
    }

    @override
    Widget build(BuildContext context) {

      return WillPopScope(
          onWillPop: _onBackPressed,
          child:  Scaffold(
            key: _scaffoldKey,
            body: Container(
              child: Column(
                children: [
                  Container(
                      color: Colors.lightBlue[900],
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [

                          Container(
                              color: Colors.lightBlue[900],
                              margin: EdgeInsets.only(left: 15, top: 40),
                              child: Row(children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                      onTap: () {
                                        _scaffoldKey.currentState!.openDrawer();
                                      },
                                      child: Image.asset(
                                        'assets/Images/menu.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                    )),
                                Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Dashboard",
                                        style:
                                        TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    ))
                              ])),
                          Container(
                              margin: EdgeInsets.only(left: 15, top: 30, bottom: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Total Sale :20",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              )
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 10),
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0)),
                              ),
                              child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              "Hello $user",
                                              style: TextStyle(
                                                  color: Colors.lightBlue.shade900,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 21),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 500,
                                        child: StaggeredGridView.count(
                                          crossAxisCount: 4,
                                          staggeredTiles: _cardTile,
                                          children: _listTile,
                                          mainAxisSpacing: 4.0,
                                          crossAxisSpacing: 4.0,
                                        ),
                                      ),
                                    ],
                                  ))),

                          ],
                        )
                      )
                   ],
                ),
             ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                      decoration: BoxDecoration(
                        color:Color(0xff18325e),
                      ),
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            children: [
                              Padding(padding: EdgeInsets.only(top: 25.0)),
                              Image.asset('assets/Images/ic_logo_round.png',
                                  width: 90, height: 90),
                              Text(
                                'Welcome to Jivo',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                      )
                  ),
                  ListTile(
                    title: Text(
                      'Dashboard',
                      style: TextStyle(color: Color(0xff18325e), fontSize: 18),
                    ),

                  ),
                  titlelist(),

                  ListTile(
                    title: Text(
                      'Delivery Details',
                      style: TextStyle(color: Color(0xff18325e), fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(_createRoute());
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => DeliveryData()),
                      // );
                    },
                  ),
                  ListTile(
                    // leading: Icon(Icons.lock,color: Color(0xff1e8325e),),
                    title: Text(
                      'Logout',
                      style: TextStyle(color: Color(0xff18325e), fontSize: 18),
                    ),
                    onTap: () {
                      //progressDialog.show();
                      logout();
                    },
                  ),
                ],
              ),
            ),
        ),
      );

    }

    Widget expand(){
      return ExpandablePanel(
        header: Text("title"),
        collapsed: Text("article.body", softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
        expanded: Text("article.bod", softWrap: true, ),
      );
    }

    getuser() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.getString('Name')!;
      setState(() {
          user = prefs.getString('Name')!;
      });
    }

    Widget titlelist() {
      return new Column(
        children: [
          for (int i=0; i<1; i++)
            for(int j=0; j<menu_id.length; j++)
              ExpansionTile(title: Text(
                menu_name[j],
                style: TextStyle(color:Color(0xff18325e),fontSize: 18),
                ),
                children: [
                    for(int b=0;b<sub_menu.length;b++)
                      if(parent_id[b]==menu_id[j])
                        Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/Images/dot.png',
                              width: 7,
                              height: 7,
                            ),
                            Padding(padding: EdgeInsets.only(left: 10,top: 10)),
                            Text(sub_menu[b]),

                          ],
                        )
                     ),
                  ),
                ],
              )
        ],

      );
    }

    List<Widget> _listTile = <Widget>[
      Layoutone(
          backgroundColor:Color(0xff18325e),
          icondata: Icons.calendar_view_month),
      Layouttwo(
          backgroundColor:Color(0xff18325e),
          icondata: Icons.calendar_today),
      Layoutthree(
          backgroundColor:Color(0xff18325e),
          icondata: Icons.miscellaneous_services),
      Layoutfour(
          backgroundColor:Color(0xff18325e),
          icondata: Icons.miscellaneous_services),
    ];

    logout() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.getString('Name');
      print(prefs.clear());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>LoginScreen()));
    }

    Future fetchPost() async {

      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      var response = await http.get(Uri.parse('http://164.52.200.38:90/DeliveryPanel/Login?Username=${prefs.getString('Name')}&Password=${prefs.getString('Password')}'),headers: headers);

      User user = User.fromJson(json.decode(response.body));
      final data = json.decode(response.body);

      if (user.id > 0) {

           // var menulist = jsonDecode(response.body)['menu_list'] as List;
           //
           // tags= menulist.map((tagJson) => MenuList.fromJson(tagJson)).toList();
           //
           // for(int i=0;i<tags.length;i++){
           //
           //   if(tags[i].parentID==0){
           //
           //     setState(() {
           //       menu_name.add(tags[i].nodeName);
           //       menu_id.add(tags[i].nodeID);
           //     });
           //
           //     print(tags[i].nodeName);
           //
           //   }else{
           //
           //     setState(() {
           //       sub_menu.add(tags[i].nodeName);
           //       parent_id.add(tags[i].parentID);
           //     });
           //   }
           //
           // }

      }else {
        throw throw Exception('Failed to load data');
        //    Fluttertoast.showToast(
        //        msg: "Please check your credentials",
        //        toastLength: Toast.LENGTH_SHORT,
        //        gravity: ToastGravity.BOTTOM,
        //        timeInSecForIosWeb: 1,
        //        backgroundColor: Colors.black,
        //        textColor: Colors.white,
        //        fontSize: 16.0);
        //
      }

    }

}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DeliveryData(),
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

