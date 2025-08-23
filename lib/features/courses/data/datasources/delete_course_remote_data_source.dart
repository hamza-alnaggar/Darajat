// features/topics/data/datasources/topic_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';

class DeleteCourseRemoteDataSource {
  final ApiConsumer api;

  DeleteCourseRemoteDataSource({required this.api});

  Future<String> deleteCourse(int courseId) async {

  final accessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5ZjU3MDJkZS05YmFhLTRiYzEtYmY5YS1jZDlkMDVmZGJiYmEiLCJqdGkiOiI5YWYwZTc4Yzk3MGY3Mjk5ZjRlN2VlMmNlZDcwNTg0YTdjZDcyODI4YWU1NWIxYzMzY2U4N2UwN2E0N2NiN2I4NmI3ZjA5Y2NjMWYyNmYyYyIsImlhdCI6MTc1MTk2MTAwNC41NDk5MjgsIm5iZiI6MTc1MTk2MTAwNC41NDk5MywiZXhwIjoxNzgzNDk3MDA0LjUzNjQ3NSwic3ViIjoiNCIsInNjb3BlcyI6W119.Xf9VUNityWRdSU0gbxyFmD6HkwPW1PN55ZHq2asI0JT8JASHXVupiWgyrJXD_0VplmXgcvFX9OZMzpd3Mwe1pOb1QSdgLFf0PUwmctDipkzZJccnv8pPmY3_MauIhnnwg5dMm6hxzsI31i1IaARSRx5fYMsAjSoZrNrd1PMesmS4rv69yaq7D9zMzRD9vodPRQUZNngVWJYL5GgFGvU3qSSH4T8hm-QdqhHz-8KlbKQOHTZzVMhDHvxOOGsU_3pfIzQK_biiIAYYctwDDv-yKKVQrggymESbqQ8aZKgX2zAS1sKjpmLlMx9JFy4JqSYr12l1oCVOc5Xd86UBndfzH9aCebifjDMWgoJPoqTAVGPs5SMMt1zciEaXPHKidw0rRPTJFNiqNkblIW2KfYVi9jASp6dO0zI36JHqHXlYTi1TPB22SGea-RgTv4Hfbur350lhdvEjQdZjXqrMUMx2JuFBkDkajvMwDFnH3Lh2KXnC2wi30VpYC8zl82FJliQviDhbVnkqhbYQ74oqWdPGXDSLjHsp6tZgHjtX8V2UCWQ_vFUo46u0-9tkCJJzgpDQsMzrxocynN4PxCKC2PAv_7qZhX1Da7ORbr3BsRgl5REXvo17QYdauKi1nQ0urubKqoBypPuN-FTVFdmpOfGuyCUyCwWXj5L8CLCLw83A2do';
  //await SharedPrefHelper.getString('accessToken');

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    };

  final response = await api.delete(
    '${EndPoints.allCourses}/$courseId',
    options: Options(headers: headers)
  );

  return response['message'];
}
}