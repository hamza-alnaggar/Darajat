import 'package:learning_management_system/core/databases/cache/cache_helper.dart';

class LanguageCacheHelper {
  Future<void> cacheLanguageCode(String languageCode) async {
    
    SharedPrefHelper.setData("LOCALE", languageCode);
  }

  Future<String> getCachedLanguageCode() async {
    final cachedLanguageCode = SharedPrefHelper.getString("LOCALE");
    if (cachedLanguageCode != null) {
      return cachedLanguageCode;
    } else {
      return "en";
    }
  }
}