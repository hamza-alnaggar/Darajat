// features/skills/data/repositories/skill_repository.dart
import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/student/skills/data/datasource/get_skills_remote_data_source.dart';

import 'package:learning_management_system/features/student/skills/data/models/skills_respons_model.dart';

class GetSkillsRepository {
  final GetSkillsRemoteDataSource remoteDataSource;

  GetSkillsRepository({required this.remoteDataSource});

  Future<Either<Failure, SkillResponseModel>> getSkills() async {
    try {
      final response = await remoteDataSource.getSkills();
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}