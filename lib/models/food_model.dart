class FoodModel {
  String name;
  String detail;
  String price;
  String urlFood;

  FoodModel({this.name, this.detail, this.price, this.urlFood});

  FoodModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    detail = json['Detail'];
    price = json['Price'];
    urlFood = json['UrlFood'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Detail'] = this.detail;
    data['Price'] = this.price;
    data['UrlFood'] = this.urlFood;
    return data;
  }
}