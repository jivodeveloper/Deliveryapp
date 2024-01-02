import 'package:flutter/material.dart';

class PaymentDetails extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return PaymentDetailsState();
  }

}

class PaymentDetailsState extends State<PaymentDetails>{

  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController refernce_Id = TextEditingController();
  TextEditingController amount = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.lightBlue.shade900,
            title: Text('Payment Details')
        ),
        body:Form(
            key: _formKey,
            child: Column(
              children: [

                Container(
                    margin: EdgeInsets.only(left: 10, top: 25,right:10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: username,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter customer name';
                            }
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              prefixIcon: Icon(Icons.account_circle_sharp),
                              border: OutlineInputBorder(),
                              hintText: 'Customer Name'),
                        ),
                      ],
                    )
                ),

                Container(
                    margin: EdgeInsets.only(left: 10, top: 25,right:10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: amount,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter reference id';
                            }
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              prefixIcon: Icon(Icons.lock),

                              border: OutlineInputBorder(),
                              hintText: 'Reference Id'),
                        )
                      ],
                    )),

                Container(
                    margin: EdgeInsets.only(left: 10, top: 25,right:10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: amount,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount';
                            }
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              prefixIcon: Icon(Icons.money),

                              border: OutlineInputBorder(),
                              hintText: 'Amount'),
                        )
                      ],
                    )
                ),

                // Container(
                //   width: MediaQuery.of(context).size.width * 0.5,
                //     height: double.infinity,
                //     child:  SimpleGroupedCheckbox<int>(
                //     controller: controller,
                //     itemsTitle: ["COD" ,"Paytm"],
                //     values: [1,2],
                //     groupStyle: GroupStyle(
                //         activeColor: Colors.red,
                //         itemTitleStyle: TextStyle(
                //             fontSize: 13
                //         )
                //       ),
                //     checkFirstElement: false,
                //     ),
                //   ),

                GestureDetector(

                    onTap: () {

                      if (_formKey.currentState!.validate()) {
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')),)
                      }
                    },

                    child: new Container(
                      margin: EdgeInsets.only(left: 10, top: 35),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[900],
                        borderRadius:
                        BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          )
                      ),
                    )

                )

              ],
            )
        )
    );

  }

}