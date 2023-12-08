import 'package:crm_flutter/Model/ItemList.dart';

class OrderList {

  int? userId;
  int? id;
  int? orderId;
  String? custName;
  String? custMobile;
  int? zoneId;
  int? areaId;
  int? stateId;
  int? totalPrice;
  int? totalQty;
  int? callerId;
  int? deliveryAssignId;
  String? insertedDate;

  List<ItemList>? itemList=[];

  OrderList(
      {this.userId,
        this.id,
        this.orderId,
        this.custName,
        this.custMobile,
        this.zoneId,
        this.areaId,
        this.stateId,
        this.totalPrice,
        this.totalQty,
        this.callerId,
        this.deliveryAssignId,
        this.insertedDate,
        this.itemList});

  OrderList.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    orderId = json['orderId'];
    custName = json['custName'];
    custMobile = json['custMobile'];
    zoneId = json['zoneId'];
    areaId = json['areaId'];
    stateId = json['stateId'];

    totalPrice = json['totalPrice'];
    totalQty = json['totalQty'];
    callerId = json['callerId'];
    deliveryAssignId = json['deliveryAssignId'];
    insertedDate = json['insertedDate'];
    if (json['ItemList'] != null) {
      itemList = <ItemList>[];
      json['ItemList'].forEach((v) {
        itemList!.add(new ItemList.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['orderId'] = this.orderId;
    data['custName'] = this.custName;
    data['custMobile'] = this.custMobile;
    data['zoneId'] = this.zoneId;
    data['areaId'] = this.areaId;
    data['stateId'] = this.stateId;
    data['totalPrice'] = this.totalPrice;
    data['totalQty'] = this.totalQty;
    data['callerId'] = this.callerId;
    data['deliveryAssignId'] = this.deliveryAssignId;
    data['insertedDate'] = this.insertedDate;
    if (this.itemList != null) {
      data['ItemList'] = this.itemList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
