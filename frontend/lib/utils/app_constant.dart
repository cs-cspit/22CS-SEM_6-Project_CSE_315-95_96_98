class AppConstants {

  static const String baseUrl = 'http://192.168.139.42:8000/api';
  static const String basePhoto = 'http://192.168.139.42:8000';
  
  // Authentication
  static const String registerDriverUrl = '$baseUrl/register-driver';
  static const String loginDriverUrl = '$baseUrl/login-driver';

  // toggle Duty
  static const String toggleDutyUrl = '$baseUrl/toggle-duty';

  // get Profile
  static const String getProfileUrl = '$baseUrl/driver-profile';

  // update Profile
  static const String updateProfileUrl = '$baseUrl/update-driver';

  // get Profile Photo
  static const String getProfilePhoto = '$basePhoto/storage/';
}
