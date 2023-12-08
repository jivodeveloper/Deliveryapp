import 'package:crm_flutter/Model/OrderList.dart';

class Order_List {

  List<OrderList> orderList= [];

  Order_List({required this.orderList});

  Order_List.fromJson(Map<String, dynamic> json) {

    if (json['OrderList'] != null) {
      orderList = <OrderList>[];
      json['OrderList'].forEach((v) {
        orderList.add(new OrderList.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderList != null) {
      data['OrderList'] = this.orderList.map((v) => v.toJson()).toList();
    }
    return data;

  }

}