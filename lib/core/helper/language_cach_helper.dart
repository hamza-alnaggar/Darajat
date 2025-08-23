import 'package:learning_management_system/core/databases/cache/cache_helper.dart';

class LanguageCacheHelper {
  Future<void> cacheLanguageCode(String languageCode) async {
    
  await SharedPrefHelper.setData("LOCALE", languageCode);
  }

  Future<String> getCachedLanguageCode() async {
    final cachedLanguageCode = await SharedPrefHelper.getString("LOCALE");
    if (cachedLanguageCode != null && cachedLanguageCode.isNotEmpty) {
      return cachedLanguageCode;
    } else {
      return "en";
    }
  }
}