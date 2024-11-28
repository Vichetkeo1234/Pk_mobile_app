class ProductByCateResModel {
  List<ListNews>? listNews;

  ProductByCateResModel({this.listNews});

  ProductByCateResModel.fromJson(Map<String, dynamic> json) {
    if (json['list_news'] != null) {
      listNews = <ListNews>[];
      json['list_news'].forEach((v) {
        listNews!.add(new ListNews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listNews != null) {
      data['list_news'] = this.listNews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListNews {
  int? id;
  int? categoryId;
  String? tiltle;
  String? space;
  String? description;
  int? quantity;
  int? cost;
  int? price;
  int? discount;
  String? warranty;
  String? note;
  String? thumnail;
  int? multiImageId;
  int? views;
  int? location;
  int? status;
  int? createBy;
  String? createAt;
  int? updateBy;
  String? updateAt;
  String? nameTitle;
  String? firstname;
  String? lastname;

  ListNews(
      {this.id,
        this.categoryId,
        this.tiltle,
        this.space,
        this.description,
        this.quantity,
        this.cost,
        this.price,
        this.discount,
        this.warranty,
        this.note,
        this.thumnail,
        this.multiImageId,
        this.views,
        this.location,
        this.status,
        this.createBy,
        this.createAt,
        this.updateBy,
        this.updateAt,
        this.nameTitle,
        this.firstname,
        this.lastname});

  ListNews.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    categoryId = json['category_id'];
    tiltle = json['tiltle'];
    space = json['space'];
    description = json['description'];
    quantity = json['quantity'];
    cost = json['cost'];
    price = json['price'];
    discount = json['discount'];
    warranty = json['warranty'];
    note = json['note'];
    thumnail = json['Thumnail'];
    multiImageId = json['multiImage_id'];
    views = json['views'];
    location = json['location'];
    status = json['status'];
    createBy = json['CreateBy'];
    createAt = json['CreateAt'];
    updateBy = json['UpdateBy'];
    updateAt = json['UpdateAt'];
    nameTitle = json['NameTitle'];
    firstname = json['Firstname'];
    lastname = json['Lastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['category_id'] = this.categoryId;
    data['tiltle'] = this.tiltle;
    data['space'] = this.space;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['cost'] = this.cost;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['warranty'] = this.warranty;
    data['note'] = this.note;
    data['Thumnail'] = this.thumnail;
    data['multiImage_id'] = this.multiImageId;
    data['views'] = this.views;
    data['location'] = this.location;
    data['status'] = this.status;
    data['CreateBy'] = this.createBy;
    data['CreateAt'] = this.createAt;
    data['UpdateBy'] = this.updateBy;
    data['UpdateAt'] = this.updateAt;
    data['NameTitle'] = this.nameTitle;
    data['Firstname'] = this.firstname;
    data['Lastname'] = this.lastname;
    return data;
  }
}
