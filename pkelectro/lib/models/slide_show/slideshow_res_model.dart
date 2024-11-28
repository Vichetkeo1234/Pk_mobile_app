class SlideShowResModel {
  List<ListSlide>? listSlide;
  List<Total>? total;

  SlideShowResModel({this.listSlide, this.total});

  SlideShowResModel.fromJson(Map<String, dynamic> json) {
    if (json['listSlide'] != null) {
      listSlide = <ListSlide>[];
      json['listSlide'].forEach((v) {
        listSlide!.add(new ListSlide.fromJson(v));
      });
    }
    if (json['total'] != null) {
      total = <Total>[];
      json['total'].forEach((v) {
        total!.add(new Total.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listSlide != null) {
      data['listSlide'] = this.listSlide!.map((v) => v.toJson()).toList();
    }
    if (this.total != null) {
      data['total'] = this.total!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListSlide {
  int? id;
  int? location;
  int? status;
  String? image;
  String? url;
  String? createAt;

  ListSlide(
      {this.id,
        this.location,
        this.status,
        this.image,
        this.url,
        this.createAt});

  ListSlide.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    location = json['location'];
    status = json['Status'];
    image = json['Image'];
    url = json['url'];
    createAt = json['CreateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['location'] = this.location;
    data['Status'] = this.status;
    data['Image'] = this.image;
    data['url'] = this.url;
    data['CreateAt'] = this.createAt;
    return data;
  }
}

class Total {
  int? total;

  Total({this.total});

  Total.fromJson(Map<String, dynamic> json) {
    total = json['Total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Total'] = this.total;
    return data;
  }
}
