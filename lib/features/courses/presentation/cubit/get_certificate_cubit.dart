// features/topics/presentation/cubit/topic_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/repositories/get_certificate_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/get_certificate_state.dart';


class GetCertificateCubit extends Cubit<GetCertificateState> {
  final GetCertificateRepository repository;

  GetCertificateCubit({required this.repository}) : super(GetCertificateInitial());

  
  Future<void> getCertificate(int courseId,) async {
    emit(GetCertificateLoading());
    final response = await repository.getCertificate(courseId);
    response.fold(
      (failure) => emit(GetCertificateFailure(errMessage: failure.errMessage)),
      (response) => emit(GetCertificateSuccess(link: response)));
  }
  
  }
