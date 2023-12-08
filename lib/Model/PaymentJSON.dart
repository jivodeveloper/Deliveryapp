
class PaymentJSON{

  int item_id;
  String paymode;
  int payamount;
  int deliveryboy;
  String referenceId;

  PaymentJSON(this.item_id,this.paymode,this.payamount,this.deliveryboy,this.referenceId);

  Map toJson() =>{
    'itemId' : item_id,
    'PayMode' : paymode,
    'PayAmount' : payamount,
    'RefrenceNumber' : referenceId,
    'deliveryBoyID' : deliveryboy
  };

}