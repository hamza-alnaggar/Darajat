// // features/coupon/data/datasources/coupon_remote_data_source.dart
// import 'package:dio/dio.dart';
// import 'package:learning_management_system/core/databases/api/api_consumer.dart';
// import 'package:learning_management_system/core/databases/api/end_points.dart';
// import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
// import 'package:learning_management_system/features/coupon/data/models/coupon_detail_model.dart';
// import 'package:learning_management_system/features/coupon/data/models/coupon_details_model.dart';
// import 'package:learning_management_system/features/coupon/data/models/coupon_model.dart';

// class CouponRemoteDataSource {
//   final ApiConsumer api;

//   CouponRemoteDataSource({required this.api});

//   Future<List<CouponModel>> getCourseCoupons(int courseId) async {
//     final accessToken = await SharedPrefHelper.getString('accessToken');
//     final headers = {
//       'Authorization': 'Bearer $accessToken',
//       'Accept': 'application/json',
//     };

//     final response = await api.get(
//       '${EndPoints.courseCoupons}/$courseId/coupons',
//       options: Options(headers: headers),
//     );

//     return (response['data'] as List)
//         .map((json) => CouponModel.fromJson(json))
//         .toList();
//   }

//   Future<CouponDetailModel> createCoupon({
//     required int courseId,
//     required String code,
//     required String discountType,
//     required double discountValue,
//     required DateTime? expiresAt,
//     required int? maxUses,
//   }) async {
//     final accessToken = await SharedPrefHelper.getString('accessToken');
//     final headers = {
//       'Authorization': 'Bearer $accessToken',
//       'Accept': 'application/json',
//     };

//     final data = {
//       'code': code,
//       'discount_type': discountType,
//       'discount_value': discountValue,
//       if (expiresAt != null) 'expires_at': expiresAt.toIso8601String(),
//       if (maxUses != null) 'max_uses': maxUses,
//     };

//     final response = await api.post(
//       '${EndPoints.courseCoupons}/$courseId/coupons',
//       data: data,
//       options: Options(headers: headers),
//     );

//     return CouponDetailModel.fromJson(response['data']);
//   }

//   Future<CouponDetailModel> updateCoupon({
//     required int couponId,
//     required String code,
//     required String discountType,
//     required double discountValue,
//     required DateTime? expiresAt,
//     required int? maxUses,
//   }) async {
//     final accessToken = await SharedPrefHelper.getString('accessToken');
//     final headers = {
//       'Authorization': 'Bearer $accessToken',
//       'Accept': 'application/json',
//     };

//     final data = {
//       'code': code,
//       'discount_type': discountType,
//       'discount_value': discountValue,
//       if (expiresAt != null) 'expires_at': expiresAt.toIso8601String(),
//       if (maxUses != null) 'max_uses': maxUses,
//     };

//     final response = await api.put(
//       '${EndPoints.coupons}/$couponId',
//       data: data,
//       options: Options(headers: headers),
//     );

//     return CouponDetailModel.fromJson(response['data']);
//   }

//   Future<CouponDetailModel> getCouponDetails(int couponId) async {
//     final accessToken = await SharedPrefHelper.getString('accessToken');
//     final headers = {
//       'Authorization': 'Bearer $accessToken',
//       'Accept': 'application/json',
//     };

//     final response = await api.get(
//       '${EndPoints.coupons}/$couponId',
//       options: Options(headers: headers),
//     );

//     return CouponDetailModel.fromJson(response['data']);
//   }

//   Future<void> deleteCoupon(int couponId) async {
//     final accessToken = await SharedPrefHelper.getString('accessToken');
//     final headers = {
//       'Authorization': 'Bearer $accessToken',
//       'Accept': 'application/json',
//     };

//     await api.delete(
//       '${EndPoints.coupons}/$couponId',
//       options: Options(headers: headers),
//     );
//   }

//   Future<Map<String, dynamic>> applyCoupon({
//     required int courseId,
//     required String couponCode,
//   }) async {
//     final accessToken = await SharedPrefHelper.getString('accessToken');
//     final headers = {
//       'Authorization': 'Bearer $accessToken',
//       'Accept': 'application/json',
//     };

//     final data = {'code': couponCode};

//     final response = await api.post(
//       '${EndPoints.courseCoupons}/$courseId/apply-coupon',
//       data: data,
//       options: Options(headers: headers),
//     );

//     return response;
//   }
// }