class Country{
  final String name;
  final String dialCode;
  final String code;

  Country({ this.name, this.dialCode, this.code });

  factory Country.fromJson(dynamic json) {
    return Country(name: json['name'],dialCode: json['dial_code'],code: json['code']);
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.dialCode}, ${this.code} }';
  }
}