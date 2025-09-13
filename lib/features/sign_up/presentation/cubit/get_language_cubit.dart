import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/language_sub_model.dart';
import 'package:learning_management_system/features/sign_up/data/repositories/get_language_repository.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_language_state.dart';


class GetLanguageCubit extends Cubit<GetLanguageState> {
  final GetLanguageRepository getLanguageRepository;

  GetLanguageCubit(this.getLanguageRepository) : super(GetLanguageInitial());

  List<CountryOrLanguageSubModel> languageList = [];
    List<CountryOrLanguageSubModel> availableLanguage = [];

  List<String> languageListName = [];
  CountryOrLanguageSubModel ?selectedLanguage ;



  Future<void> eitherFailureOrGetLanguage() async {
    final failureOrGetLanguage = await getLanguageRepository.getLanguage();
    failureOrGetLanguage.fold(
      (failure) => emit(GetLanguageFailure(errMessage: failure.errMessage)),
      (getCountry) {
        languageList = getCountry.list;
        availableLanguage = getCountry.list;
        emit(GetLanguageSuccessfully());
      },
    );
  }
    void updateAvailableLanguage(List<LanguageSubModel> userLan) {
      print(userLan.length);
    availableLanguage = languageList.where(
      (lan) => !userLan.any((userLang) => userLang.countryOrLanguageSubModel.id == lan.id)
    ).toList();
    emit(GetLanguageUpdate()); 
  }


 
  void selectLanguage(CountryOrLanguageSubModel language) {
    selectedLanguage = language;
    emit(ChangeData());  
  }

}