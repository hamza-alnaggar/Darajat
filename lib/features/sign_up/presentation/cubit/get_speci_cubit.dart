import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';
import 'package:learning_management_system/features/sign_up/data/repositories/get_speci_repository.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_speci_state.dart';


class GetSpeciCubit extends Cubit<GetSpeciState> {
  final GetSpeciRepository getSpeciRepository;

  GetSpeciCubit(this.getSpeciRepository) : super(GetSpeciInitial());

  List<CountryOrLanguageSubModel> speciList = [];
  CountryOrLanguageSubModel ?selectedSpeci;



  Future<void> eitherFailureOrGetSpeci() async {
    final failureOrGetCountry = await getSpeciRepository.getSpec();
    failureOrGetCountry.fold(
      (failure) => emit(GetSpeciFailure(errMessage: failure.errMessage)),
      (getCountry) {
        speciList = getCountry.list;
        emit(GetSpeciSuccessfully());
      },
    );
  }
  void selectSeci(CountryOrLanguageSubModel speci) {
    selectedSpeci = speci;
    emit(ChangeData());  
  }

  void setInitialSpeci(String? specialityName) {
    if (specialityName == null || specialityName.trim().isEmpty) return;

    final key = specialityName.trim().toLowerCase();

    try {
      selectedSpeci = speciList.firstWhere(
        (s) => s.name.trim().toLowerCase() == key,
      );
    } catch (e) {
      selectedSpeci = CountryOrLanguageSubModel(id: -1, name: specialityName);
    }

    emit(ChangeData());
  }




}