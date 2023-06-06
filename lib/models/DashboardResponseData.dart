

class DashboardResponseData {
  Pagination? pagination;
  List<DashboardBookInfo>? data;

  DashboardResponseData({this.pagination,this.data});

  DashboardResponseData.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
        if (json['result'] != null) {
      data = <DashboardBookInfo>[];
      json['result'].forEach((v) {
        data!.add(new DashboardBookInfo.fromJson(v));
      });
    }
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['result'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class BookResponse {
  DashboardBookInfo? bookdetail;
  BookResponse({this.bookdetail});

  BookResponse.fromJson(Map<String, dynamic> json) {
      bookdetail = json['result'] != null ? new DashboardBookInfo.fromJson(json['result']) : null;
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.bookdetail != null) {
      data['result'] = this.bookdetail!.toJson(); 
    }
    return data;
  }
}


class Pagination {
  int? totalCount;
  int? maxPageSize;
  int? currentPage;
  int? totalPages;
  bool? hasNext;
  bool? hasPrevious;

  Pagination(
    {
      this.totalCount,
      this.maxPageSize,
      this.currentPage,
      this.totalPages,
      this.hasNext,
      this.hasPrevious
    }
  );
    Pagination.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    maxPageSize = json['maxPageSize'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    hasNext = json['hasNext'];
    hasPrevious = json['hasPrevious'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['maxPageSize'] = this.maxPageSize;
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['hasNext'] = this.hasNext;
    data['hasPrevious'] = this.hasPrevious;
    return data;
  }
}

class Availability {
  bool? physical;
  bool? digital;
  Availability(
    {
      this.physical,
      this.digital,
    }
  );
    Availability.fromJson(Map<String, dynamic> json) {
    physical = json['physical'];
    digital = json['digital'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['physical'] = this.physical;
    data['digital'] = this.digital;
    return data;
  }

}

class Publisher {
  int? id;
  String? name;
  String? description;
  bool? isActive;

  Publisher(
    {
      this.id,
      this.name,
      this.description,
      this.isActive
    }
  );
    Publisher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    return data;
  }

}



class Genres {
  int? id;
  String? name;

  Genres(
    {
      this.id,
      this.name,
    }
  );
    Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

}

class AuthorResponseData {
  Pagination? pagination;
  List<Authors>? data;

  AuthorResponseData({this.pagination,this.data});

  AuthorResponseData.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
      if (json['result'] != null) {
        data = <Authors>[];
      json['result'].forEach((v) {
        data!.add(new Authors.fromJson(v));
      });
    }
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['result'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class PublisherResponseData {
  List<Publisher>? data;

  PublisherResponseData({this.data});

  PublisherResponseData.fromJson(Map<String, dynamic> json) {
      if (json['result'] != null) {
        data = <Publisher>[];
      json['result'].forEach((v) {
        data!.add(new Publisher.fromJson(v));
      });
    }
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['result'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Authors {
  int? id;
  String? fullName;
  String? imageUrl;
  String? bio;
  bool? isActive;
  Authors(
    {
      this.id,
      this.fullName,
      this.imageUrl,
      this.bio,
      this.isActive
    }
  );
    Authors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    imageUrl = json['imageUrl'];
    bio = json['bio'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['imageUrl'] = this.imageUrl;
    data['bio'] = this.bio;
    data['isActive'] = this.isActive;
    return data;
  }

}

class DepartmentResponseData {
  List<Departments>? data;

  DepartmentResponseData({this.data});

  DepartmentResponseData.fromJson(Map<String, dynamic> json) {
      if (json['result'] != null) {
        data = <Departments>[];
      json['result'].forEach((v) {
        data!.add(new Departments.fromJson(v));
      });
    }
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['result'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Departments {
  int? id;
  String? name;
  String? code;
  bool? isActive;
  bool? isDeleted;
  // List<ChildDepartments> childDepartments;
  Departments(
    {
      this.id,
      this.name,
      this.code,
      this.isActive,
      this.isDeleted
    }
  );
    Departments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    return data;
  }
}
 class Comments{
  int? id;
  String? commentedAt;
  String? text;
  int? rating;
  String? bookID;
  String? commenterID;
  String? commenterUsername;
  Account? commenter;
  // List<ChildDepartments> childDepartments;
  Comments(
    {
      this.id,
      this.commentedAt,
      this.text,
      this.rating,
      this.commenterID,
      this.commenterUsername,
      this.commenter
    }
  );
    Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentedAt = json['commentedAt'];
    text = json['text'];
    rating = json['rating'];
    commenterID = json['commenterID'];
    commenterUsername = json['commenterUsername'];
    commenter = json['commenter'] != null ? new Account.fromJson(json['commenter']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['commentedAt'] = this.commentedAt;
    data['text'] = this.text;
    data['rating'] = this.rating;
    data['commenterID'] = this.commenterID;
    data['commenterUsername'] = this.commenterUsername;
    if(this.commenter != null) {
      data['commenter'] = this.commenter!.toJson(); 
    }
    return data;
  }
 }


 class Account {
  String? id;
  String? username;
  String? email;
  String? phone;
  String? fullName;
  bool? isActive;
  List<Roles>? roles;
  Account ({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.fullName,
    this.isActive,
    this.roles

  });
      Account.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        username = json['username'];
        email = json['email'];
        phone = json['phone'];
        fullName = json['fullName'];
        isActive = json['isActive'];
      if (json['roles'] != null) {
        roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['fullName'] = this.fullName;
    data['isActive'] = this.isActive;
        if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Roles {
  int? id;
  String? name;
  List<Permissions>? permissions;

  Roles({
    this.id,
    this.name,
    this.permissions
  });

      Roles.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        name = json['name'];
      if (json['permissions'] != null) {
        permissions = <Permissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(new Permissions.fromJson(v));
      });
    }
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
        if (this.permissions != null) {
      data['permissions'] = this.permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}
class Permissions {
  int? id;
  String? name;
  String? description;
  Permissions (
    {
      this.id,
      this.name,
      this.description
    }
  );
    Permissions.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      name = json['name'];
      description = json['description'];
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}



class DashboardBookInfo {
  int? id;
  String? title;
  String? description;
  int? publishYear;
  bool? isActive;
  String? thumbnailUrl;
  String? language;
  bool? isUploading;
  bool? isPublic;
  bool? isApproved;
  int? numPages;
  int? borrowCount;
  bool? downloadAllowed;
  int? physicalCopiesCountNotifyThreshold;
  Availability? availability;
  Publisher? publisher;
  List<Genres>? genres;
  List<Authors>? authors;
  List<Departments>? departments;
  List<Comments>? comments;
  DashboardBookInfo(
      {
      this.id,
      this.title,
      this.description,
      this.publishYear,
      this.isActive,
      this.thumbnailUrl,
      this.language,
      this.isUploading,
      this.isPublic,
      this.isApproved,
      this.numPages,
      this.borrowCount,
      this.downloadAllowed,
      this.physicalCopiesCountNotifyThreshold,
      this.availability,
      this.publisher,
      this.genres,
      this.authors,
      this.departments,
      this.comments,
      });


  DashboardBookInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    publishYear = json['publishYear'];
    isActive = json['isActive'];
    thumbnailUrl = json['thumbnailUrl'];
    language = json['language'];
    isUploading = json['isUploading'];
    isPublic = json['isPublic'];
    isApproved = json['isApproved'];
    numPages = json['numPages'];
    borrowCount = json['borrowCount'];
    downloadAllowed = json['downloadAllowed'];
    physicalCopiesCountNotifyThreshold = json['physicalCopiesCountNotifyThreshold'];
    availability = json['availability'] != null ? new Availability.fromJson(json['availability']) : null;
    publisher = json['publisher'] != null ? new Publisher.fromJson(json['publisher']) : null;
    if (json['genres'] != null) {
      genres = <Genres>[];
      json['genres'].forEach((v) {
        genres!.add(new Genres.fromJson(v));
      });
    }
    if (json['authors'] != null) {
      authors = <Authors>[];
      json['authors'].forEach((v) {
        authors!.add(new Authors.fromJson(v));
      });
    }
    if (json['departments'] != null) {
      departments = <Departments>[];
      json['departments'].forEach((v) {
        departments!.add(new Departments.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['publishYear'] = this.publishYear;
    data['isActive'] = this.isActive;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['language'] = this.language;
    data['isUploading'] = this.isUploading;
    data['isPublic'] = this.isPublic;
    data['isApproved'] = this.isApproved;
    data['numPages'] = this.numPages;
    data['borrowCount'] = this.borrowCount;
    if (this.availability != null) {
      data['availability'] = this.availability!.toJson();
    }
    if (this.publisher != null) {
      data['publisher'] = this.publisher!.toJson();
    }

    if (this.genres != null) {
      data['genres'] = this.genres!.map((v) => v.toJson()).toList();
    }
    if (this.authors != null) {
      data['authors'] = this.authors!.map((v) => v.toJson()).toList();
    }

    if (this.departments != null) {
      data['departments'] = this.departments!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}



class AuthorResponse {
  int? id;
  String? storeName;
  String? firstName;
  String? lastName;
  String? name;
  String? phone;
  String? image;
  bool? showEmail;
  String? location;
  String? banner;
  int? bannerId;
  String? gravatar;
  int? gravatarId;
  String? shopUrl;
  int? productsPerPage;
  bool? showMoreProductTab;
  bool? tocEnabled;
  String? storeToc;
  bool? featured;
  Rating? rating;
  bool? enabled;
  String? registered;
  String? payment;
  bool? trusted;

  AuthorResponse({
    this.id,
    this.storeName,
    this.firstName,
    this.name,
    this.lastName,
    this.phone,
    this.showEmail,
    this.location,
    this.banner,
    this.bannerId,
    this.gravatar,
    this.gravatarId,
    this.image,
    this.shopUrl,
    this.productsPerPage,
    this.showMoreProductTab,
    this.tocEnabled,
    this.storeToc,
    this.featured,
    this.rating,
    this.enabled,
    this.registered,
    this.payment,
    this.trusted,
  });

  AuthorResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['shop_name'];
    firstName = json['first_name'];
    name = json['name'];
    lastName = json['last_name'];
    phone = json['phone'];
    showEmail = json['show_email'];
    location = json['location'];
    banner = json['banner'];
    bannerId = json['banner_id'];
    gravatar = json['gravatar'];
    gravatarId = json['gravatar_id'];
    shopUrl = json['url'];
    productsPerPage = json['products_per_page'];
    showMoreProductTab = json['show_more_product_tab'];
    tocEnabled = json['toc_enabled'];
    image = json['image'];
    storeToc = json['store_toc'];
    featured = json['featured'];
    rating = json['rating'] != null ? new Rating.fromJson(json['rating']) : null;
    enabled = json['enabled'];
    registered = json['registered'];
    payment = json['payment'];
    trusted = json['trusted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_name'] = this.storeName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['show_email'] = this.showEmail;
    data['location'] = this.location;
    data['image'] = this.image;
    data['banner'] = this.banner;
    data['banner_id'] = this.bannerId;
    data['gravatar'] = this.gravatar;
    data['name'] = this.name;
    data['gravatar_id'] = this.gravatarId;
    data['url'] = this.shopUrl;
    data['products_per_page'] = this.productsPerPage;
    data['show_more_product_tab'] = this.showMoreProductTab;
    data['toc_enabled'] = this.tocEnabled;
    data['store_toc'] = this.storeToc;
    data['featured'] = this.featured;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    data['enabled'] = this.enabled;
    data['registered'] = this.registered;
    data['payment'] = this.payment;
    data['trusted'] = this.trusted;

    return data;
  }
}

class Rating {
  String? rating;
  int? count;

  Rating({this.rating, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['count'] = this.count;
    return data;
  }
}



class DownloadModel {
  String? id;
  String? name;
  String? file;

  DownloadModel({this.id, this.name, this.file});

  DownloadModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['file'] = this.file;
    return data;
  }
}

class Dimensions {
  String? length;
  String? width;
  String? height;

  Dimensions({this.length, this.width, this.height});

  Dimensions.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

// class Categories {
//   int? id;
//   String? name;
//   String? slug;

//   Categories({this.id, this.name, this.slug});

//   Categories.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     slug = json['slug'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['slug'] = this.slug;
//     return data;
//   }
// }

class Images {
  int? id;
  String? dateCreated;
  String? dateModified;
  String? src;
  String? name;
  String? alt;
  int? position;

  Images({this.id, this.dateCreated, this.dateModified, this.src, this.name, this.alt, this.position});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
    src = json['src'];
    name = json['name'];
    alt = json['alt'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date_created'] = this.dateCreated;
    data['date_modified'] = this.dateModified;
    data['src'] = this.src;
    data['name'] = this.name;
    data['alt'] = this.alt;
    data['position'] = this.position;
    return data;
  }
}

class Attributes {
  int? id;
  String? name;
  int? position;
  bool? visible;
  bool? variation;
  List<String>? options;

  Attributes({this.id, this.name, this.position, this.visible, this.variation, this.options});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    visible = json['visible'];
    variation = json['variation'];
    options = json['options'] != null ? new List<String>.from(json['options']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['visible'] = this.visible;
    data['variation'] = this.variation;
    data['options'] = this.options;
    return data;
  }
}

class UpsellId {
  int? id;
  String? name;
  String? slug;
  String? price;
  String? regularPrice;
  String? salePrice;
  List<Images>? images;

  UpsellId({this.id, this.name, this.slug, this.price, this.regularPrice, this.salePrice, this.images});

  UpsellId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  String? commentID;
  String? commentPostID;
  String? commentAuthor;
  String? commentAuthorEmail;
  String? commentAuthorUrl;
  String? commentAuthorIP;
  String? commentDate;
  String? commentDateGmt;
  String? commentContent;
  String? commentKarma;
  String? commentApproved;
  String? commentAgent;
  String? commentType;
  String? commentParent;
  String? userId;
  String? ratingNum = "0";

  Reviews(
      {this.commentID,
      this.commentPostID,
      this.commentAuthor,
      this.commentAuthorEmail,
      this.commentAuthorUrl,
      this.commentAuthorIP,
      this.commentDate,
      this.commentDateGmt,
      this.commentContent,
      this.commentKarma,
      this.commentApproved,
      this.commentAgent,
      this.commentType,
      this.commentParent,
      this.ratingNum,
      this.userId});

  Reviews.fromJson(Map<String, dynamic> json) {
    commentID = json['comment_ID'];
    commentPostID = json['comment_post_ID'];
    commentAuthor = json['comment_author'];
    commentAuthorEmail = json['comment_author_email'];
    commentAuthorUrl = json['comment_author_url'];
    commentAuthorIP = json['comment_author_IP'];
    commentDate = json['comment_date'];
    commentDateGmt = json['comment_date_gmt'];
    commentContent = json['comment_content'];
    commentKarma = json['comment_karma'];
    commentApproved = json['comment_approved'];
    commentAgent = json['comment_agent'];
    commentType = json['comment_type'];
    ratingNum = json['rating_num'];
    commentParent = json['comment_parent'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_ID'] = this.commentID;
    data['comment_post_ID'] = this.commentPostID;
    data['comment_author'] = this.commentAuthor;
    data['comment_author_email'] = this.commentAuthorEmail;
    data['comment_author_url'] = this.commentAuthorUrl;
    data['comment_author_IP'] = this.commentAuthorIP;
    data['comment_date'] = this.commentDate;
    data['comment_date_gmt'] = this.commentDateGmt;
    data['comment_content'] = this.commentContent;
    data['rating_num'] = this.ratingNum;
    data['comment_karma'] = this.commentKarma;
    data['comment_approved'] = this.commentApproved;
    data['comment_agent'] = this.commentAgent;
    data['comment_type'] = this.commentType;
    data['comment_parent'] = this.commentParent;
    data['user_id'] = this.userId;
    return data;
  }
}

class Store {
  int? id;
  String? name;
  String? shopName;
  String? url;

  Store({this.id, this.name, this.shopName, this.url});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shopName = json['shop_name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['shop_name'] = this.shopName;
    data['url'] = this.url;

    return data;
  }
}
