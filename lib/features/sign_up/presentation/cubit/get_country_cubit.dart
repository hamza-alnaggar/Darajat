import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';
import 'package:learning_management_system/features/sign_up/data/repositories/get_country_repository.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_state.dart';


class GetCountryCubit extends Cubit<GetCountryState> {
  final GetCountryRepository getCountryRepository;

  GetCountryCubit(this.getCountryRepository) : super(GetCountrynitial());

  List<CountrySubModel> countryList = [];
  List<String> countryListName = [];
  CountrySubModel ?selectedCountry ;



  Future<void> eitherFailureOrGetCountry() async {
    final failureOrGetCountry = await getCountryRepository.getCountry();
    failureOrGetCountry.fold(
      (failure) => emit(GetCountryFailure(errMessage: failure.errMessage)),
      (getCountry) {
        countryList = getCountry.countryList;
        emit(GetCountrySuccessfully());
      },
    );
  }

 
  void selectCountry(CountrySubModel country) {
    selectedCountry = country;
    emit(ChangeData());  
  }




}