class Items{
    int item_id;

    Items(this.item_id);

    Map toJson() =>{
        'item_id' : item_id
    };

}