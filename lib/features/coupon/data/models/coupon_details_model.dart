class CouponDetailModel {
  final int id;
  final String code;
  final String discountType;
  final String discountValue;
  final DateTime expiresAt;
  final int? maxUses;
  final int useCount;

  CouponDetailModel({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.expiresAt,
    this.maxUses,
    required this.useCount,
  });

  factory CouponDetailModel.fromJson(Map<String, dynamic> json) {
    return CouponDetailModel(
      id: json['id'] as int,
      code: json['code'] as String,
      discountType: json['discount_type'] as String,
      discountValue: json['discount_value'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      maxUses: json['max_uses'] as int?,
      useCount: json['use_count'] as int? ?? 0,
    );
  }
}