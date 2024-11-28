class CategoryResModel {
  List<ListTitle>? listTitle;

  CategoryResModel({this.listTitle});

  CategoryResModel.fromJson(Map<String, dynamic> json) {
    if (json['list_Title'] != null) {
      listTitle = <ListTitle>[];
      json['list_Title'].forEach((v) {
        listTitle!.add(new ListTitle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listTitle != null) {
      data['list_Title'] = this.listTitle!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListTitle {
  int? id;
  int? categoryId;
  String? nameTitle;
  Null? tag;
  Null? price;
  Null? od;
  Null? description;
  int? createBy;
  int? status;
  String? createAt;

  ListTitle(
      {this.id,
        this.categoryId,
        this.nameTitle,
        this.tag,
        this.price,
        this.od,
        this.description,
        this.createBy,
        this.status,
        this.createAt});

  ListTitle.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    categoryId = json['category_id'];
    nameTitle = json['NameTitle'];
    tag = json['Tag'];
    price = json['Price'];
    od = json['Od'];
    description = json['Description'];
    createBy = json['CreateBy'];
    status = json['Status'];
    createAt = json['CreateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['category_id'] = this.categoryId;
    data['NameTitle'] = this.nameTitle;
    data['Tag'] = this.tag;
    data['Price'] = this.price;
    data['Od'] = this.od;
    data['Description'] = this.description;
    data['CreateBy'] = this.createBy;
    data['Status'] = this.status;
    data['CreateAt'] = this.createAt;
    return data;
  }
}
