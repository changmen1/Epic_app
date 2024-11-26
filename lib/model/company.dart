class Company {
  int? id;
  String? companyLogo;
  String? companyName;
  String? companyPhone;
  String? companyAddress;

  Company(
      {this.id,
      this.companyLogo,
      this.companyName,
      this.companyPhone,
      this.companyAddress});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyLogo = json['logo'];
    companyName = json['name'];
    companyPhone = json['phone'];
    companyAddress = json['address'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    // data['id'] = id;
    data['name'] = companyName;
    data['logo'] = companyLogo;
    data['phone'] = companyPhone;
    data['address'] = companyAddress;
    return data;
  }
  // {
  // "id": 1,
  // "logo": "https://logo.clearbit.com/msu.edu",
  // "name": "Catharina",
  // "phone": "(555) 846-4545",
  // "address": "eneles61@vistaprint.com"
  // },
}
