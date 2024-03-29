class AddressModel {
  int id;
  String addressType;
  String contactPersonNumber;
  String address;
  String latitude;
  String longitude;
  int zoneId;
  String method;
  String contactPersonName;

  AddressModel(
      {this.id,
      this.addressType,
      this.contactPersonNumber,
      this.address,
      this.latitude,
      this.longitude,
      this.zoneId,
      this.method,
      this.contactPersonName});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    contactPersonNumber = json['contact_person_number'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zoneId = json['zone_id'];
    method = json['_method'];
    contactPersonName = json['contact_person_name'];
  }

  String get fullAddress =>
      '$address, $contactPersonName, $contactPersonNumber';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address_type'] = this.addressType;
    data['contact_person_number'] = this.contactPersonNumber;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['zone_id'] = this.zoneId;
    data['_method'] = this.method;
    data['contact_person_name'] = this.contactPersonName;
    return data;
  }
}
