import 'package:flutter/material.dart';

class OtherData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OtherDataState();
  }
}

class OtherDataState extends State<OtherData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
              child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[900],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Pending Order",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
              child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[900],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Cancelled Order",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[900],
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Order Status",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                ))
          ],
        ),
      ),
    );
  }
}
