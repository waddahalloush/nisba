class AppEnv {
  static const String env = String.fromEnvironment('ENV', defaultValue: 'local');

  static String get baseUrl {
    switch (env) {
      case 'prod':
        return 'https://nisbaa.com';
      case 'staging':
        return 'https://nisbaa.com';
      default:
        return 'https://nisbaa.com'; // Laragon
    }
  }
}
