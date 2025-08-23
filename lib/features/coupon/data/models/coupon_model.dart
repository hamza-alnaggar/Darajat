class CouponModel {
  final int id;
  final String code;
  final DateTime expiresAt;

  CouponModel({
    required this.id,
    required this.code,
    required this.expiresAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as int,
      code: json['code'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }
}