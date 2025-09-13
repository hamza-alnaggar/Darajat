// features/episodes/data/repositories/episodes_repository.dart
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:learning_management_system/core/errors/expentions.dart';
import 'package:learning_management_system/core/errors/failure.dart';
import 'package:learning_management_system/features/courses/data/datasources/episodes_remote_data_sourse.dart';
import 'package:learning_management_system/features/courses/data/models/episode_response_model.dart';

class EpisodesRepository {
  final EpisodesRemoteDataSource remoteDataSource;


  EpisodesRepository({required this.remoteDataSource});

  Future<Either<Failure, EpisodeResponseModel>> getEpisodes(
      bool isStudent,
      bool isCopy,
      int courseId) async {
    try {
      final response = await remoteDataSource.getEpisodes(courseId,isStudent,isCopy);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  Future<Either<Failure, EpisodeResponse>> showEpisode(
      bool isStudent,
      int episodeId) async {
    try {
      final response = await remoteDataSource.showEpisode(episodeId,isStudent);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }

  Future<Either<Failure, void>> finishEpisode(
      int episodeId) async {
    try {
      final response = await remoteDataSource.finishEpisode(episodeId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
 Future<Either<Failure, String>> downloadFile( int episodeId,String path) async { try { final response = await remoteDataSource.downloadFile(episodeId,path); return Right(response); } catch (e) { return Left(Failure(errMessage: e.toString())); } }
  Future<Either<Failure, EpisodeResponse>> LikeEpisode(
      int episodeId) async {
    try {
      final response = await remoteDataSource.LikeEpisode(episodeId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }


  
   Future<Either<Failure, Uint8List>> getEpisodePoster(int episodeId,bool isCopy) async {
    try {
      final data = await remoteDataSource.getEpisodePoster(episodeId,isCopy);
      return Right(data);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
   Future<Either<Failure, Uint8List>> getFile(int episodeId,bool isCopy) async {
    try {
      final data = await remoteDataSource.getEpisodePdf(episodeId,isCopy);
      return Right(data);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
   

  Future<Either<Failure, Stream<Uint8List>>> getEpisodeVideo(int episodeId,bool isCopy) async {
    
    
    try {
      final stream = await remoteDataSource.getEpisodeVideo(episodeId,isCopy);
      return Right(stream);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errMessage));
    }
  }
}