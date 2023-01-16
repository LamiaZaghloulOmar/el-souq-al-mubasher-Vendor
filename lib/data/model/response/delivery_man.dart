class DeliveryMan {
  final String f_name, l_name;

  DeliveryMan({this.f_name, this.l_name});

  String get fullName => '$f_name $l_name';
  Map<String, dynamic> toMap() {
    return {
      'f_name': this.f_name,
      'l_name': this.l_name,
    };
  }

  factory DeliveryMan.fromMap(Map<String, dynamic> map) {
    return DeliveryMan(
      f_name: map['f_name'] as String ?? '',
      l_name: map['l_name'] as String ?? '',
    );
  }
}
