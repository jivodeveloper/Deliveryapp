class ItemList {
  int? itemId;
  String? itemName;
  int? itemQty;
  int? uomValue;
  int? itemRate;
  int? itemTotalAmount;
  String? coupon;
  String? deliveryRemark;
  String? uom;
  String? rawItemName;
  int? inQty;
  int? outQty;
  String? active;
  String? payCharge;
  int? reciableAmt;
  bool? isSelect;
  int? cId;
  String? status;

  ItemList(
      {this.itemId,
        this.itemName,
        this.itemQty,
        this.uomValue,
        this.itemRate,
        this.itemTotalAmount,
        this.coupon,
        this.deliveryRemark,
        this.uom,
        this.rawItemName,
        this.inQty,
        this.outQty,
        this.active,
        this.payCharge,
        this.reciableAmt,
        this.isSelect,
        this.cId,
        this.status});

  ItemList.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    itemName = json['itemName'];
    itemQty = json['itemQty'];
    uomValue = json['uomValue'];
    itemRate = json['itemRate'];
    itemTotalAmount = json['itemTotalAmount'];
    coupon = json['coupon'];
    deliveryRemark = json['deliveryRemark'];
    uom = json['uom'];
    rawItemName = json['rawItemName'];
    inQty = json['inQty'];
    outQty = json['outQty'];
    active = json['active'];
    payCharge = json['payCharge'];
    reciableAmt = json['reciableAmt'];
    isSelect = json['IsSelect'];
    cId = json['c_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['itemName'] = this.itemName;
    data['itemQty'] = this.itemQty;
    data['uomValue'] = this.uomValue;
    data['itemRate'] = this.itemRate;
    data['itemTotalAmount'] = this.itemTotalAmount;
    data['coupon'] = this.coupon;
    data['deliveryRemark'] = this.deliveryRemark;
    data['uom'] = this.uom;
    data['rawItemName'] = this.rawItemName;
    data['inQty'] = this.inQty;
    data['outQty'] = this.outQty;
    data['active'] = this.active;
    data['payCharge'] = this.payCharge;
    data['reciableAmt'] = this.reciableAmt;
    data['IsSelect'] = this.isSelect;
    data['c_id'] = this.cId;
    data['status'] = this.status;
    return data;
  }

}