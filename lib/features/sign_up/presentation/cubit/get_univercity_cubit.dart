import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';
import 'package:learning_management_system/features/sign_up/data/repositories/get_univercity_repository.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_univercity_state.dart';


class GetUnivercityCubit extends Cubit<GetUnivercityState> {
  final GetUnivercityRepository remoteDataSource;

  GetUnivercityCubit(this.remoteDataSource) : super(GetUnivercityInitial());

  List<String> univercityList = [];
  String ?selectedUnivercity ;



  Future<void> eitherFailureOrGetUnivercity() async {
    final failureOrGetCountry = await remoteDataSource.getUnivercity();
    failureOrGetCountry.fold(
      (failure) => emit(GetUnivercityFailure(errMessage: failure.errMessage)),
      (getUnivercity) {
        univercityList = getUnivercity;
        emit(GetUnivercitySuccessfully());
      },
    );
  }

  void selectUnivercity(String univercity) {
    selectedUnivercity = univercity;
    emit(ChangeUnivercity());  
  }




}