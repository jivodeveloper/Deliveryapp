import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DailyData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DailyDataState();
  }
}

List<StaggeredTile> _cardTile = <StaggeredTile>[
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 1.5),
  StaggeredTile.count(2, 2),
];

List<Widget> _listTile = <Widget>[
  Layoutone(backgroundColor: Colors.lightBlue.shade900,icondata: Icons.calendar_today),
  Layouttwo(backgroundColor: Colors.lightBlue, icondata: Icons.calendar_today),
  Layoutthree(backgroundColor: Colors.lightBlue, icondata: Icons.landscape),
];

class Layoutone extends StatelessWidget {

  final Color backgroundColor;
  final IconData icondata;

  Layoutone({required this.backgroundColor, required this.icondata});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: backgroundColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(icondata, color: Colors.white),
                  Text("Monthly",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text("Order",style: TextStyle(color: Colors.white, fontSize: 15)),
                      Text("123",style: TextStyle(color: Colors.white, fontSize: 15)),
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                    children: [
                    Text("Top 5",style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text("431",style: TextStyle(color: Colors.white, fontSize: 15)),
                  ],
                ))
              ],
            )
          ],
        ));
  }

}

class Layouttwo extends StatelessWidget {

  final Color backgroundColor;
  final IconData icondata;

  Layouttwo({required this.backgroundColor, required this.icondata});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: backgroundColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(icondata, color: Colors.white),
                  Text("Today",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text("Order",style: TextStyle(color: Colors.white, fontSize: 15)),
                      Text("123",style: TextStyle(color: Colors.white, fontSize: 15)),
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text("Top 5",style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text("431",style: TextStyle(color: Colors.white, fontSize: 15)),
                  ],
                ))
              ],
            )
          ],
        ));
    }

}

class Layoutthree extends StatelessWidget {

  final Color backgroundColor;
  final IconData icondata;

  Layoutthree({required this.backgroundColor, required this.icondata});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: backgroundColor,
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(icondata, color: Colors.white),
                  Text("Other",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),

            Row(
              children: [

                Expanded(
                  child: Column(
                    children: [
                      Text("Pending",style: TextStyle(color: Colors.white, fontSize: 15)),
                      Text("123",style: TextStyle(color: Colors.white, fontSize: 15)),
                    ],
                  ),
                ),

                Expanded(
                    child: Column(
                  children: [
                    Text("Cancelled",style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text("431",style: TextStyle(color: Colors.white, fontSize: 15)),
                  ],
                ))

              ],
            ),

            Container(
              child: Column(
                children: [

                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: Text("Order Status",style:TextStyle(color: Colors.white, fontSize: 15)),
                      ))

                ],
              ),
            )

          ],
        ));
     }

}

class Layoutfour extends StatelessWidget {

  final Color backgroundColor;
  final IconData icondata;

  Layoutfour({required this.backgroundColor, required this.icondata});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: backgroundColor,
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(icondata, color: Colors.white),
                  Text("Other",style: TextStyle(color: Colors.white,fontSize: 17, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text("Order Status",style: TextStyle(color: Colors.white, fontSize: 15)),
                      Text("123",style: TextStyle(color: Colors.white, fontSize: 15)),
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text("Delivery Order",style: TextStyle(color: Colors.white, fontSize: 15)),
                    Text("431",style: TextStyle(color: Colors.white, fontSize: 15)),
                  ],
                ))
              ],
            ),

            Container(
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: Text("Order Status",style:TextStyle(color: Colors.white, fontSize: 15)),
                      ))
                ],
              ),
            )

          ],
     ));
  }

}

class DailyDataState extends State<DailyData> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
          height: 200.0,
          child: StaggeredGridView.count(
            crossAxisCount: 4,
            staggeredTiles: _cardTile,
            children: _listTile,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
        ),
    ));
  }

}
