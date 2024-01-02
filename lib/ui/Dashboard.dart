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
import 'package:flutter/material.dart';
import '../Api/Common.dart';
import '../Model/ItemList.dart';
import '../Model/OrderList.dart';

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
    String empid = "";
    List<StaggeredTile> _cardTile = <StaggeredTile>[
      StaggeredTile.count(2, 1.4),
      StaggeredTile.count(2, 1.4),
      StaggeredTile.count(2, 1.4),
      StaggeredTile.count(2, 1.4),
    ];
    Future<List<OrderList>>? furturedist;
    List<OrderList> orderList = [];
    List<ItemList> item_list = [];
    int total =0 ,pending =0,delivered=0,cancel =0 ;
    bool _isLoading= true;

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
    void initState() {
      super.initState();
      getuserdata(context);
      getuser();
    }

    Future<List<OrderList>> getdeliverydata(String empid,context) async {

      try{

        Map<String, String> headers = {
          'Content-Type': 'application/json',
        };

        var response = await http.post(
            Uri.parse('${Common.IP_URL}Customerdetails?userIds=$empid'),
            headers: headers);

        final list = jsonDecode(response.body);

        orderList = list.map<OrderList>((m) => OrderList.fromJson(Map<String, dynamic>.from(m))).toList();

        item_list = list.map<ItemList>((m) => ItemList.fromJson(Map<String, dynamic>.from(m))).toList();

        try{

          for(int i=0;i<orderList.length;i++){

            for(int j=0;j<orderList[i].itemList!.length;j++) {

              setState(() {

                cancel = orderList[i].itemList![j].active == "-1"? ++cancel:cancel;
                pending = orderList[i].itemList![j].active == "1"? ++pending:pending;
                delivered = orderList[i].itemList![j].active == "2"? ++delivered:delivered;

                _isLoading = false ;

              });

            }

          }

        }catch(e){
          print("itemlist $e");
        }

      }catch(e){
        print("itemlistt $e");
      }

      //  for (int i = 0; i < orderList.length; i++) {
      //    for (int j = 0;j < orderList[i].itemList!.length;j++) {
      //     if (orderList[i].itemList![j].active == "Pending"){
      //        var contain = order_list.where((element) => element.custName == orderList.custName);
      // //       if(contain.isEmpty){
      //          if(mounted){
      //
      //            setState(() {
      //
      //              order_list.add(OrderList(id: orderList.id,
      //                   custMobile: orderList.custMobile,
      //                   custName: orderList.custName,
      //                   zoneId: orderList.zoneId,
      //                  zoneName: orderList.zoneName,
      //                  areaId: orderList.areaId,
      //                  areaName: orderList.areaName,
      //                   stateId: orderList.stateId,
      //                  stateName: orderList.stateName,
      //                   landmark: orderList.landmark,
      //                   address: orderList.address,
      //                   pincode: orderList.pincode,
      //                   totalPrice: orderList.totalPrice,
      //                   totalQty: orderList.totalQty,
      //                   paymentMode: orderList.paymentMode,
      //                   paymentRemark: orderList.paymentRemark,
      //                   paymentNumber: orderList.paymentNumber,
      //                   remark: orderList.remark,
      //                   callerId: orderList.callerId,
      //                   deliveryAssignId: orderList.deliveryAssignId,
      //                   deliveryAssignName: orderList.deliveryAssignName,
      //                   deliveryAssignDate: orderList.deliveryAssignDate,
      //                   callerName: orderList.callerName,
      //                   source: orderList.source,
      //                   insertedDate: orderList.insertedDate,
      //                   itemCoupon: orderList.itemCoupon,
      //                   itemList: orderList.itemList![i]));
      //             });
      //
      //           }
      //
      //         }else{
      //
      //          }
      //        }
      //
      //     }
      //   }

      // if (order_list.length == 0) {
      //
      //   Fluttertoast.showToast(
      //       msg: "Sorry No Data",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.black,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      //   // Navigator.pushReplacement(
      //   //     context, MaterialPageRoute(builder: (context) =>Dashboard()));
      //
      // }

      // for (int i = 0; i < order_list.length; i++) {
      //
      //  // for (int j = 0; j < order_list[i].itemList[i].; j++) {
      //     // if ( order_list[i].itemDetails[j].active == "Pending") {
      //    // print("$i $j");
      //     print( order_list[i].custName! +"" +order_list[i].itemList!.itemName +"" +order_list[i].itemList!.active);
      //   //  }
      //   // }
      // }
      return orderList;
    }

    getuserdata(BuildContext context) async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        empid = prefs.getInt('empid').toString();
      });

      furturedist = getdeliverydata(empid,context);

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
                    child: _isLoading?
                    CircularProgressIndicator():Container(
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
                                 ]
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
                                           )
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(left: 10,top:10,right: 10),
                                          child: SizedBox(
                                              width: double.infinity,
                                              height: 150,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xffdde6f8),
                                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [

                                                    Row(
                                                      children: [

                                                        Expanded(
                                                          child:Column(
                                                            children: [
                                                              Text("Today's Target",style: TextStyle( color: Colors.blue.shade900,fontWeight: FontWeight.bold)),
                                                              Text("${orderList.length}"),
                                                            ],
                                                          ),
                                                        ),

                                                        Expanded(
                                                          child:  Column(
                                                            children: [
                                                              Text("Achieved ",style: TextStyle( color: Colors.lightBlue.shade900,fontWeight: FontWeight.bold)),
                                                              Text("$delivered"),
                                                            ],
                                                          ),
                                                        )

                                                      ],
                                                    ),

                                                    SizedBox(height: 10,),

                                                    Row(
                                                      children: [

                                                        Expanded(
                                                          child:Column(
                                                            children: [
                                                              Text("Pending ",style: TextStyle( color: Colors.lightBlue.shade900,fontWeight: FontWeight.bold)),
                                                              Text("$pending"),
                                                            ],
                                                          ),
                                                        ),

                                                        Expanded(
                                                          child:  Column(
                                                            children: [
                                                              Text("Cancel ",style: TextStyle( color: Colors.lightBlue.shade900,fontWeight: FontWeight.bold)),
                                                              Text("$cancel"),
                                                            ],
                                                          ),
                                                        )

                                                      ],
                                                    )

                                                  ],
                                                ),
                                              )
                                          ),
                                        )

                                      ],
                                    )
                                )
                            ),

                          ],
                       )
                    ),
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
                                  width: 90, height: 60),
                              Text(
                                'Welcome',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                      )
                  ),
                  ListTile(
                    leading: Image.asset(
                        'assets/Images/home.png', height: 25),
                    title: Text(
                      'Dashboard',
                      style: TextStyle(color: Color(0xff18325e), fontSize: 18),
                    ),

                  ),
                  titlelist(),
                  ListTile(
                    leading: Image.asset(
                        'assets/Images/home.png', height: 25),
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
                    leading: Image.asset(
                        'assets/Images/home.png', height: 25),
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

