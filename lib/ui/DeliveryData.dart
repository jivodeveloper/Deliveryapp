import 'package:crm_flutter/Model/ItemList.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:crm_flutter/Helper/DatabaseHelper.dart';
import 'package:crm_flutter/Model/PaymentJSON.dart';
import 'package:crm_flutter/Helper/PaymentDatabaseHelper.dart';
import 'package:crm_flutter/Model/Items.dart';
import 'package:crm_flutter/Model/OrderList.dart';
import 'package:crm_flutter/Model/Payment.dart';
import 'package:crm_flutter/Model/Paymentdetails.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Api/Common.dart';
import 'LoginScreen.dart';

class NumberList {

  String number;
  int index;
  NumberList({required this.number, required this.index});

}

class DeliveryData extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return DeliveryDataState();
  }

}

class DeliveryDataState extends State<DeliveryData> {

  List<OrderList> order_list = [];
  List<ItemList> item_list = [];
  List<String> payment_details = [];
  List<OrderList> orderList = [];

  String payment ="COD";

  int item_id =0;
  bool select_all = false;
  String empid = "", name = "", mobile = "";
  double amount = 0.0;
  List<String> paymentoption = ["COD","PAYTM","GPAY","PHONEPE"];

  Map<String, bool> values = {
    'COD': false,
    'PAYTM': false,
  };

  List<NumberList> nList = [
    NumberList(
      index: 1,
      number: "COD",
    ),
    NumberList(
      index: 2,
      number: "Paytm",
    ),
    NumberList(
      index: 3,
      number: "Net Banking",
    ),
  ];

  MultiSelectController controller = new MultiSelectController();
  TextEditingController reference_id = new TextEditingController();
  TextEditingController bal_amtc = new TextEditingController();
  TextEditingController t_amt = new TextEditingController();

  List _selecteCategorysID = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool valuefirst = false;
  bool valuesecond = false;
  List<Items> json_data = [];
  List<int> amnt_total = [];
  int item_val = 0;
  List<int> json_payment = [];
  List<PaymentJSON> list_data = [];
  List<Paymentdetails> payment_data = [];
  List<Payment> delivery_data = [];
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late ExpandableController categoryController;
  final paymenthepler = PaymentDatabaseHelper.instance;
  String radioItemHolder = '';
  final _formKey = GlobalKey<FormState>();
  bool bal_amt = false, ref_amt = false;
  List multiSelectList = [];
  int id = 1;
  int selected = 0;
  Future<List<OrderList>>? furturedist;
  bool isChecked = false;
  int item=0;
  bool? check1 = true;
  int userid=0;

  @override
  void initState() {
    super.initState();
    categoryController = ExpandableController(initialExpanded: false);

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();

    getuserdata(context);

  }

  /*init*/
  Future<void> initConnectivity() async {

    ConnectivityResult result = ConnectivityResult.none;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {

    switch (result) {

      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = 'Failed to get connectivity');
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;

    }

  }

  /* to receive empid*/
  getuserdata(BuildContext context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      empid = prefs.getInt('empid').toString();
    });

    furturedist = getdeliverydata(empid,context);

  }

  /*check interet for delivery data*/
  checkinternetconnection(String status,BuildContext context) async {

    try {

      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        if (status == 'Cancel') {

         // updatestatus(status);

        } else {

       //   updatepaymentdata(status);

        }

      }

    } on SocketException catch (_) {

      int result = 0;
      int bal = 0;

      if (bal_amtc.text == "") {
        bal = 0;
        result = amount.toInt();
      } else {
        bal = int.tryParse(bal_amtc.text)!;
        if (amount.toInt() > bal) {
          result = amount.toInt() - int.tryParse(bal_amtc.text)!;
        }
      }

      // list_data.add(PaymentJSON(
      //     element.item_id, paymentelement, amount.toInt(), 10044,reference_id.text));

      json_data.forEach((element) {
        payment_details.forEach((paymentelement) {
          if (paymentelement.trim() == "PAYTM") {
            print("Paytm${element.item_id}$paymentelement${amount.toInt()}${reference_id.text}");

            insertpayment(element.item_id, paymentelement, bal_amtc.text, reference_id.text,
                int.parse(empid), status);
          } else if (paymentelement == "COD") {
           // print("CODD${element.item_id}$paymentelement$result");
            insertpayment(element.item_id, paymentelement, result,
                reference_id.text,empid, status);
          }
          else {
          //  print("CODDCODD${element.item_id}$paymentelement$bal");
            insertpayment(element.item_id, paymentelement, bal,
                empid, reference_id.text, status);
          }
        });
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(

      onWillPop: () {
        _onBackPressed();

        return new Future(() => true);
      },
      child:Scaffold(

        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xff18325e),
          title: Text("Delivery Details"),

          // actions: <Widget>[
          //
          //   Visibility(
          //       visible:
          //       select_all == true ? select_all = true : select_all = false,
          //       child: Row(
          //         children: [
          //           IconButton(
          //               icon: new Icon(Icons.save),
          //               onPressed: () =>
          //                   _displayTextInputDialog(context, "Delivered")),
          //           IconButton(
          //               icon: new Icon(Icons.close),
          //               onPressed: () =>
          //                   checkinternetconnection('Cancel', context)),
          //         ],
          //       ))
          //
          // ],

        ),
        body: Container(
            color: Colors.white,
            child: FutureBuilder<List<OrderList>>(
                future: furturedist,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        width:double.infinity,
                        height: double.infinity,
                        padding:EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: Color(0xFFD2C7C7))
                        ),
                        margin:EdgeInsets.all(10),
                        child: ListView.builder(

                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return _buildList(snapshot.data![index],index);
                            }

                        )
                    );
                  }
                return Container();
             })
        )
      )

    );

  }

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
                    onTap: () => logout(),
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

  logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('Name');
    print(prefs.clear());

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) =>LoginScreen()));

  }

  showlist() {

    setState(() {
      select_all = false;
    }
   );

    return new BoxDecoration();
  }

  nointernet() {

    Fluttertoast.showToast(
        msg: "No internet connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

  }

  Widget _buildList(OrderList list,index) {

    return Builder(
        builder: (context) {
          return GestureDetector(
            onTap: (){

              item = 0;
              for(int i=0;i<list.itemList!.length;i++){
                item += list.itemList![i].itemTotalAmount!;
              }

              userid = list.id!;
              showitemlist(context,list.itemList,list.orderId,item);
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration:BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.white,width: 1, style: BorderStyle.solid,),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [

                  Align(
                    alignment: Alignment.centerLeft,
                    child:Text(list.custName.toString(),style: TextStyle(fontSize:16,fontFamily: 'OpenSans',color: Colors.black),),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child:Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(list.custMobile.toString(),style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'OpenSans',color: Colors.black),),

                    )),

                  Align(
                    alignment: Alignment.centerLeft,
                    child:Padding(
                      padding: EdgeInsets.only(top: 5),
                    child:Text(list.insertedDate.toString(),style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'OpenSans',color: Colors.black),),
                  ),)

                ],
              ),
            ),
          );
        }
      );

  }

  Future<void> showitemlist(BuildContext contextt,list,orderId,item) async {

    return showDialog<void>(
      context: contextt,
      builder: (BuildContext context) {
        contextt = context;
        return StatefulBuilder(
            builder: (context,setState){
              return Container(
                child:  AlertDialog(
                  title: Center(
                    child: Text('Item Details'),
                  ),
                  content:SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: SingleChildScrollView(
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Row(
                          children: [

                            Expanded(flex: 3,
                              child:  Text("Item",style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold)),),
                            Expanded(flex: 1,
                              child:  Text("Qty",style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold)),),
                            Expanded(flex: 1,
                                child:  Text("Total",style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold)))

                          ],
                        ),

                        Flexible(
                          child:ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) =>
                                Container(

                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [

                                      Row(
                                        children: [

                                          Expanded(
                                              flex: 3,
                                              child: Text(list[index].itemName,style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'OpenSans',color: Colors.black),)),

                                          Expanded(
                                            flex: 1,
                                            child: Text(list[index].itemQty.toString(),style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'OpenSans',color: Colors.black),),),

                                          Expanded(
                                            flex: 1,
                                            child: Text(list[index].itemTotalAmount.toString(),style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'OpenSans',color: Colors.black),),),

                                          // Checkbox(
                                          //   value: check1,
                                          //   onChanged: (bool? value) {
                                          //
                                          //     print("$item");
                                          //     setState(() {
                                          //       check1 = value;
                                          //       //list[index].isSelect = value;
                                          //     });
                                          //
                                          //   },
                                          // ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                          ),
                        ),

                        GestureDetector(

                            onTap: () {
                              Navigator.pop(context);
                              showpaymentdetails(contextt,item,orderId);
                            },
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(left: 10,
                                    top: 35,
                                    right: 10),

                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xff18325e),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Center(
                                    child: Text(
                                      "PAYMENT DETAILS",
                                      style: TextStyle(color: Colors.white,fontSize: 12),
                                    )
                                ),

                              ),
                            )

                        ),

                        Row(
                          children: [

                            Expanded(flex: 1,
                              child:  GestureDetector(
                                  onTap: () {
                                    updatestatus("Delivered",orderId);
                                  },
                                  child: Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10,
                                          top: 35,
                                          right: 10),
                                      width:90,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Color(0xff18325e),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      child: Center(
                                          child: Text(
                                            "DELIVERED",
                                            style: TextStyle(color: Colors.white,fontSize: 12),
                                          )
                                      ),
                                    ),

                                  )
                              ),),

                            Expanded(flex: 1,
                                child:GestureDetector(

                                  onTap: () {
                                    updatestatus("Cancel",orderId);
                                  },

                                  child: Container(
                                    margin: EdgeInsets.only(left: 10,
                                        top: 35,
                                        right: 10),
                                    width:90,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xff18325e),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                    ),

                                    child: Center(
                                        child: Text(
                                          "CANCEL",
                                          style: TextStyle(color: Colors.white,fontSize: 12),
                                        )
                                    ),

                                  ),

                                ))

                          ],
                        ),

                      ],

                    ),
                  ),)

                ),
              );

            }
        );

      },
    );

  }

  // Future<void> showitemlist(BuildContext contextt,list,orderId,item) async {
  //
  //   return showDialog<void>(
  //     context: contextt,
  //
  //     builder: (BuildContext context) {
  //       contextt = context;
  //       return AlertDialog(
  //         title: Center(
  //           child: Text('Item Details'),
  //         ),
  //         content: SizedBox(
  //             child: Column(
  //               children: [
  //
  //                 Row(
  //                   children: [
  //
  //                     Expanded(flex: 3,
  //                       child:  Text("Item",style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold)),),
  //                     Expanded(flex: 1,
  //                       child:  Text("Qty",style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold)),),
  //                     Expanded(flex: 1,
  //                         child:  Text("Total",style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold)))
  //
  //                   ],
  //                 ),
  //
  //                 ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: list.length,
  //                   itemBuilder: (context, index) =>
  //
  //                       Container(
  //
  //                         margin: EdgeInsets.only(top: 10),
  //                         child: Column(
  //                           children: [
  //
  //                             Row(
  //                               children: [
  //
  //                                 Expanded(
  //                                     flex: 3,
  //                                     child: Text(list[index].itemName,style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'OpenSans',color: Colors.black),)),
  //
  //                                 Expanded(
  //                                   flex: 1,
  //                                   child: Text(list[index].itemQty.toString(),style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'OpenSans',color: Colors.black),),),
  //
  //                                 Expanded(
  //                                   flex: 1,
  //                                   child: Text(list[index].itemTotalAmount.toString(),style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'OpenSans',color: Colors.black),),),
  //
  //                                 // Checkbox(
  //                                 //   value: check1,
  //                                 //   onChanged: (bool? value) {
  //                                 //
  //                                 //     print("$item");
  //                                 //     setState(() {
  //                                 //       check1 = value;
  //                                 //       //list[index].isSelect = value;
  //                                 //     });
  //                                 //
  //                                 //   },
  //                                 // ),
  //
  //                               ],
  //                             ),
  //
  //                           ],
  //                         ),
  //                       ),
  //                 ),
  //
  //                 GestureDetector(
  //
  //                     onTap: () {
  //                       Navigator.pop(context);
  //                       showpaymentdetails(contextt,item,orderId);
  //                     },
  //                     child: Center(
  //                       child: Container(
  //                         padding: EdgeInsets.all(10),
  //                         margin: EdgeInsets.only(left: 10,
  //                             top: 35,
  //                             right: 10),
  //
  //                         height: 40,
  //                         decoration: BoxDecoration(
  //                           color: Color(0xff18325e),
  //                           borderRadius:
  //                           BorderRadius.all(Radius.circular(10.0)),
  //                         ),
  //                         child: Center(
  //                             child: Text(
  //                               "PAYMENT DETAILS",
  //                               style: TextStyle(color: Colors.white,fontSize: 12),
  //                             )
  //                         ),
  //
  //                       ),
  //                     )
  //
  //                 ),
  //
  //                 Row(
  //                   children: [
  //
  //                     GestureDetector(
  //                         onTap: () {
  //                           updatestatus("Delivered",orderId);
  //                         },
  //                         child: Expanded(
  //
  //                           child: Container(
  //                             margin: EdgeInsets.only(left: 10,
  //                                 top: 35,
  //                                 right: 10),
  //                             width:90,
  //                             height: 40,
  //                             decoration: BoxDecoration(
  //                               color: Color(0xff18325e),
  //                               borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                             ),
  //                             child: Center(
  //                                 child: Text(
  //                                   "DELIVERED",
  //                                   style: TextStyle(color: Colors.white,fontSize: 12),
  //                                 )
  //                             ),
  //                           ),
  //
  //                         )
  //                     ),
  //
  //                     GestureDetector(
  //
  //                         onTap: () {
  //                           updatestatus("Cancel",orderId);
  //                         },
  //
  //                         child: Expanded(
  //                           child: Container(
  //                             margin: EdgeInsets.only(left: 10,
  //                                 top: 35,
  //                                 right: 10),
  //                             width:90,
  //                             height: 40,
  //                             decoration: BoxDecoration(
  //                               color: Color(0xff18325e),
  //                               borderRadius:
  //                               BorderRadius.all(Radius.circular(10.0)),
  //                             ),
  //
  //                             child: Center(
  //                                 child: Text(
  //                                   "CANCEL",
  //                                   style: TextStyle(color: Colors.white,fontSize: 12),
  //                                 )
  //                             ),
  //
  //                           ),
  //                         )
  //
  //                     )
  //
  //                   ],
  //                 ),
  //
  //               ],
  //
  //             )
  //
  //         ),
  //
  //       );
  //
  //     },
  //
  //   );
  //
  // }

  void showpaymentdetails(BuildContext contextt,item,orderid) async {

    t_amt.text = item.toString();
    reference_id.text = "";
    return showDialog<void>(
      context: contextt,
      barrierDismissible: false,
      builder: (BuildContext context) {
        contextt = context;

       return StatefulBuilder(
           builder: (context,setState){
              return AlertDialog(
                title: Center(
                  child: Text('Payment Details'),
                ),
                content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 150,
                    child: Column(
                      children: [

                        TextFormField(
                          keyboardType: TextInputType.none,
                          controller: t_amt,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Total Amount'),
                        ),

                        DropdownButton<String>(
                          value: payment,
                          isExpanded: true,
                          elevation: 80,
                          hint: Text("Select payment option",style: TextStyle(fontSize:16,fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                          style: TextStyle(color: Color(0xFF063A06)),
                          underline: Container(),
                          onChanged: (String? value) {
                            setState(() {
                              payment = value.toString();
                            });
                          },
                          items: paymentoption.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ) ,

                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: reference_id,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter reference number';
                            }
                          },

                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontFamily: 'OpenSans',fontSize: 16.0, color: Colors.grey),
                              hintText: 'Reference Number'),

                          )

                      ],
                    )
                ),

                actions: <Widget>[
                  TextButton(
                    child: Text('Submit'),
                    onPressed: () {
                      if(payment!="COD" && reference_id.text == ""){

                        Fluttertoast.showToast(msg: "Please enter reference number");

                      }else{
                        updatepaymentdata("",orderid);
                        Navigator.of(context).pop();
                      }

                    },
                  ),

                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],

              );
           });
      },
    );
  }

  /*get delivery details online*/
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

    // try{
    //
    //   for(int i=0;i<orderList.length;i++){
    //
    //     for(int j=0;j<orderList[i].itemList!.length;j++) {
    //       print("itemlist ${orderList[i].itemList![j].itemName}");
    //     }
    //   }
    //
    // }catch(e){
    //   print("itemlist $e");
    // }

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

  /*insert update online*/
  Future updatestatus(String status,int orderid) async {

  //  print("userdata $userid$orderid");

  var response = await http.post(
    Uri.parse('${Common.IP_URL}UpdateDeliveryStatus?newStatus=$status&OID=$orderid'),
    headers: {'Content-Type': 'application/json',},
  );

  Map<String, dynamic> response_data = json.decode(response.body);
  //  print("Error Message ${response_data['Message']}");
  if (response_data['Message'] == "Delivery status updated successfully.") {

    Fluttertoast.showToast(
        msg: "Delivery Record updated succesfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    });

  } else {

    Fluttertoast.showToast(
        msg: "Delivery ${response_data['message']}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

  }

  setState(() {
    select_all = false;
  });

  json_data.clear();

}

  /*insert payment details*/
  Future updatepaymentdata(String status,orderid) async {


   // print("${reference_id.text}${t_amt.text}$payment$userid $orderid");

    var response = await http.post(Uri.parse('${Common.IP_URL}Payment?reference_id=${reference_id.text}&t_amt=${t_amt.text}&payment_option=$payment&orderId=$orderid'),
      headers: {'Content-Type': 'application/json',},
    );

    Map<String, dynamic> response_data = json.decode(response.body);

    if(response_data['Message'] == "Delivery status updated successfully.") {

      Fluttertoast.showToast(
          msg: "Record Saved Successfully..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

     // updatestatus(status);

      json_data.clear();

    } else {

      Fluttertoast.showToast(
          msg: "${response_data['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }

  }

//   /*insert payment details*/
//   Future updatepaymentdata(String status) async {
//   int result = 0;
//   int bal = 0;
//   print("${bal_amtc.text}");
//
//   if (bal_amtc.text == "") {
//     bal = 0;
//     result = amount.toInt();
//   } else {
//     bal = int.tryParse(bal_amtc.text)!;
//     if (amount.toInt() > bal) {
//       result = amount.toInt() - int.tryParse(bal_amtc.text)!;
//     }
//   }
//
//   json_data.forEach((element) {
//     payment_details.forEach((paymentelement) {
//
//       if (paymentelement.trim() == "PAYTM" && ref_amt == true && bal_amt == false) {
//         print("Paytm${element.item_id}$paymentelement${amount.toInt()}${reference_id.text}");
//         list_data.add(PaymentJSON(element.item_id, paymentelement,
//             amount.toInt(),int.parse(empid), reference_id.text));
//       } else if (paymentelement == "COD") {
//         list_data.add(PaymentJSON(element.item_id, paymentelement, result,
//             int.parse(empid), reference_id.text));
//         print("CODD${element.item_id}$paymentelement$result");
//       } else {
//         list_data.add(PaymentJSON(element.item_id, paymentelement, bal,int.parse(empid), reference_id.text));
//         print("CODDCODD${element.item_id}$paymentelement$bal");
//       }
//
//     }
//     );
//   }
//   );
//
//   var response = await http.post(Uri.parse('http://164.52.200.38:90/DeliveryPanel/Payment'),
//     body: jsonEncode(list_data),
//     headers: {'Content-Type': 'application/json',},
//   );
//
//   Map<String, dynamic> response_data = json.decode(response.body);
//   if (response_data['message'] == "Record Save Successfully..") {
//     Fluttertoast.showToast(
//         msg: "Record Saved Successfully..",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0);
//
//     updatestatus(status);
//
//
//     json_data.clear();
//
//   } else {
//
//     Fluttertoast.showToast(
//         msg: "${response_data['message']}",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0);
//
//
//   }
//
// }

  /* insert delivery details offline*/
  void _insert(item_id, action) async {

  Map<String, dynamic> row = {
    DatabaseHelper.columnItem: item_id,
    DatabaseHelper.columnAction: action
  };

  Payment payment = Payment.fromMap(row);
  final id = await paymenthepler.insert(payment);

  // Fluttertoast.showToast(
  //     msg: "Record saved Successfully",
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.black,
  //     textColor: Colors.white,
  //     fontSize: 16.0);

  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (BuildContext context) => super.widget));

}

  /* insert payment details offline*/
  void insertpayment(itemid, mode, amount, reference_id, delivery_boy, status) async {

  Map<String, dynamic> row = {
    PaymentDatabaseHelper.itemId: itemid.toString(),
    PaymentDatabaseHelper.PayMode: mode,
    PaymentDatabaseHelper.PayAmount: amount.toString(),
    PaymentDatabaseHelper.ReferenceNumber: reference_id,
    PaymentDatabaseHelper.deliveryBoyID: delivery_boy,
  };

  Paymentdetails payment = Paymentdetails.fromMap(row);
  final id = await paymenthepler.insert_payment(payment);
  // Fluttertoast.showToast(
  //     msg: "Record saved Successfully",
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.black,
  //     textColor: Colors.white,
  //     fontSize: 16.0);

  _insert(itemid, status);

  }

}

