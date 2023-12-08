class PaymentDatas{

  int amount;
  String paymode;
  List<int> itemId;

  PaymentDatas(this.paymode,this.amount,this.itemId);

  factory PaymentDatas.fromJson(dynamic json) {
    return PaymentDatas(json['PayMode'] as String, json['PayAmount'] as int,json['itemId'] as List<int>);
  }

  @override
  String toString() {
    return '{ ${this.amount}, ${this.paymode} }';
  }

}