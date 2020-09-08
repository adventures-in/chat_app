class AuthStep {
  static const WAITING_FOR_INPUT = AuthStep._('WAITING_FOR_INPUT');
  static const SIGNING_IN_WITH_APPLE = AuthStep._('SIGNING_IN_WITH_APPLE');
  static const SIGNING_IN_WITH_GOOGLE = AuthStep._('SIGNING_IN_WITH_GOOGLE');
  static const SIGNING_IN_WITH_FIREBASE =
      AuthStep._('SIGNING_IN_WITH_FIREBASE');

  static List<AuthStep> get values => [
        WAITING_FOR_INPUT,
        SIGNING_IN_WITH_APPLE,
        SIGNING_IN_WITH_GOOGLE,
        SIGNING_IN_WITH_FIREBASE
      ];

  final String value;

  const AuthStep._(this.value);
}
