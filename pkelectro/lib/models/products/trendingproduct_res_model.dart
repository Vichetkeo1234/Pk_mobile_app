class TrendingProductResModel {
  List<ListTrending>? listTrending;

  TrendingProductResModel({this.listTrending});

  TrendingProductResModel.fromJson(Map<String, dynamic> json) {
    if (json['listTrending'] != null) {
      listTrending = <ListTrending>[];
      json['listTrending'].forEach((v) {
        listTrending!.add(new ListTrending.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listTrending != null) {
      data['listTrending'] = this.listTrending!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListTrending {
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

  ListTrending(
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
        this.updateAt});

  ListTrending.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
