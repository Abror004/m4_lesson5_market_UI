class ProductDataModel {
  String? name;
  String? cost;
  String? type;
  String? image;
  String? category;

  ProductDataModel(this.name, this.cost, this.type, this.image,
      this.category); // List? data;

  // ProductDataModel.fromJson(List<Map<String,dynamic>> json){
  //   for(int i=0;i<json.length;i++){
  //     name=json[i]["name"];
  //     cost=json[i]["cost"];
  //     type=json[i]["type"];
  //     image=json[i]["image"];
  //     category=json[i]["category"];
  //   }
  // }

  ProductDataModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    cost = json["cost"];
    type = json["type"];
    image = json["image"];
    category = json["category"];
  }
}

class Favourite {
  int? id;

  Favourite(this.id);

  Favourite.fromJson(Map<String, dynamic> json) {
    id = json["id"];
  }
}
