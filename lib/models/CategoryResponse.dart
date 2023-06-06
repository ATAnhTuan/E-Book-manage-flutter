import 'DashboardResponseData.dart';

class CategoryResponse {
  int? id;
  String? name;
  String? slug;
  int? parent;
  String? description;
  String? display;
  CategoryImages? image;

  // List<Images>? image;
  int? menuOrder;
  int? count;
  bool isChecked = false;

  CategoryResponse({
    this.id,
    this.name,
    this.slug,
    this.parent,
    this.description,
    this.display,
    this.image,
    // this.image,
    this.menuOrder,
    this.count,
  });

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    parent = json['parent'];
    description = json['description'];
    display = json['display'];
    image = json['image'] != null ? new CategoryImages.fromJson(json['image']) : null;
    /*  if (json['image'] != null) {
      image = [];
      json['image'].forEach((v) {
        image!.add(new Images.fromJson(v));
      });
    }*/
    menuOrder = json['menu_order'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['parent'] = this.parent;
    data['description'] = this.description;
    data['display'] = this.display;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    /*  if (this.image != null) {
      data['images'] = this.image!.map((v) => v.toJson()).toList();
    }*/
    data['menu_order'] = this.menuOrder;
    data['count'] = this.count;

    return data;
  }
}

class GenresResponse {
  List<Genres>? genresdetail;
  GenresResponse({this.genresdetail});

  GenresResponse.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      genresdetail = <Genres>[];
      json['result'].forEach((v) {
        genresdetail!.add(new Genres.fromJson(v));
      });
    }
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.genresdetail != null) {
      data['result'] = this.genresdetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}






/*class Images {
  int? id;
  String? dateCreated;
  String? dateCreatedGmt;
  String? dateModified;
  String? dateModifiedGmt;
  String? src;
  String? name;
  String? alt;

  Images({this.dateCreated, this.dateCreatedGmt, this.dateModified, this.dateModifiedGmt, this.src, this.name, this.alt, this.id});

  Images.fromJson(Map<String, dynamic> json) {
    dateCreated = json['date_created'];
    dateCreatedGmt = json['date_created_gmt'];
    dateModified = json['date_modified'];
    dateModifiedGmt = json['date_modified_gmt'];
    src = json['src'];
    name = json['name'];
    alt = json['alt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['date_modified'] = this.dateModified;
    data['date_modified_gmt'] = this.dateModifiedGmt;
    data['src'] = this.src;
    data['name'] = this.name;
    data['alt'] = this.alt;
    data['id'] = this.id;
    return data;
  }
}*/

class CategoryImages {
  int? id;
  String? dateCreated;
  String? dateCreatedGmt;
  String? dateModified;
  String? dateModifiedGmt;
  String? src;
  String? name;
  String? alt;

  CategoryImages({this.id, this.dateCreated, this.dateCreatedGmt, this.dateModified, this.dateModifiedGmt, this.src, this.name, this.alt});

  CategoryImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCreated = json['date_created'];
    dateCreatedGmt = json['date_created_gmt'];
    dateModified = json['date_modified'];
    dateModifiedGmt = json['date_modified_gmt'];
    src = json['src'];
    name = json['name'];
    alt = json['alt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['date_modified'] = this.dateModified;
    data['date_modified_gmt'] = this.dateModifiedGmt;
    data['src'] = this.src;
    data['name'] = this.name;
    data['alt'] = this.alt;
    return data;
  }
}

class Self {
  String? href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}
