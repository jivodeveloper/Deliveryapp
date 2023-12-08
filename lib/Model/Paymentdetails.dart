
class Paymentdetails{

  String itemId="";
  String PayMode="";
  String PayAmount ="" ;
  String deliveryBoyID="";
  String RefrenceNumber="";

  Map<String, Object?> toMap() {

    var map = <String, Object?>{
      'itemId': itemId,
      'PayMode': PayMode,
      'PayAmount': PayAmount,
      'RefrenceNumber': RefrenceNumber,
      'deliveryBoyID' : deliveryBoyID
    };

    if (map != null) {
      map['itemId'] = itemId;
      map['PayMode'] = PayMode;
      map['PayAmount'] = PayAmount;
      map['RefrenceNumber'] = RefrenceNumber;
      map['deliveryBoyID'] = deliveryBoyID;
    }
    return map;

  }

  Paymentdetails();

  Paymentdetails.fromMap(Map<String,dynamic> map) {

    itemId = map['itemId'];
    PayMode = map['PayMode'];
    PayAmount = map['PayAmount'];
    RefrenceNumber = map['RefrenceNumber'];
    deliveryBoyID = map['deliveryBoyID'];

  }

}