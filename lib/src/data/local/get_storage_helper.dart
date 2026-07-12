import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'constants/storages.dart';

class GetStorageHelper {
  final _getStorage = Get.find<GetStorage>();

  // // General Methods End: ----------------------------------------------------------
  String get authToken {
    return _getStorage.read(Storages.authToken) ?? '';
  }

  String get refreshToken {
    return _getStorage.read(Storages.refreshToken) ?? '';
  }

  saveAuthToken(String authToken) {
    _getStorage.write(Storages.authToken, authToken);
  }

  removeAuthToken() {
    _getStorage.remove(Storages.authToken);
  }

  saveRefreshToken(String refreshToken) {
    _getStorage.write(Storages.refreshToken, refreshToken);
  }

  removeRefreshToken() {
    _getStorage.remove(Storages.refreshToken);
  }

  String get fcmToken {
    return _getStorage.read(Storages.fcmToken) ?? '';
  }

  saveFcmToken(String authToken) {
    _getStorage.write(Storages.fcmToken, authToken);
  }

  removeFcmToken() {
    _getStorage.remove(Storages.fcmToken);
  }

  //===== Notification Bagde ===
  int get notiBadge {
    return _getStorage.read(Storages.notiBadge) ?? 0;
  }

  saveNotiBadge() {
    int count = notiBadge;
    _getStorage.write(Storages.notiBadge, count++);
  }

  removeNotiBadge() {
    _getStorage.remove(Storages.notiBadge);
  }

  //====== User Info =======

  double get getUserLatitude {
    return _getStorage.read(Storages.userLatitude) ?? 25.0657;
  }

  double get getUserLongtude {
    return _getStorage.read(Storages.userLongtude) ?? 55.17128;
  }

  

  //! ---------------------
  // Theme:------------------------------------------------------
  bool get isDarkMode {
    return _getStorage.read(Storages.isDarkMode) ?? false;
  }

  changeBrightnessToDark(bool value) {
    return _getStorage.write(Storages.isDarkMode, value);
  }

  String get appColor {
    return _getStorage.read(Storages.appColor) ?? '#FC800A';
  }

  void saveAppColor(String value) {
    _getStorage.write(Storages.appColor, value);
  }

 
  /// Persisted app language code (`en` or `ar`). Defaults to Arabic.
  String get languageCode {
    return _getStorage.read(Storages.currentLanguage) ?? 'ar';
  }

  void saveLanguageCode(String code) {
    _getStorage.write(Storages.currentLanguage, code);
  }

  bool isLoggedIn() {
    if (authToken != '') {
      return true;
    }
    return false;
  }

  Future<void> clearStorage() async {
    await _getStorage.erase();
  }

  /// Generic key-value write for feature-specific local data.
  Future<void> write(String key, dynamic value) async {
    await _getStorage.write(key, value);
  }

  /// Generic read for feature-specific local data.
  T? read<T>(String key) {
    return _getStorage.read<T>(key);
  }

  /// Generic key removal for feature-specific local data.
  Future<void> remove(String key) async {
    await _getStorage.remove(key);
  }
}
