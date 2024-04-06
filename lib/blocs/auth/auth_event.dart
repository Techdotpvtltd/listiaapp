abstract class AuthEvent {}

// AuthEventUninitialize  ========================================
class AuthEventUninitialize extends AuthEvent {}

class AuthEventSplashAction extends AuthEvent {}

// AuthEventNeedsToSetProfile
class AuthEventNeedsToSetProfile extends AuthEvent {}

// AuthEventInitialize  ========================================
class AuthEventInitialize extends AuthEvent {}

/// Loading LoginScreen
class AuthEventPerformLogin extends AuthEvent {
  final String email;
  final String password;

  AuthEventPerformLogin({required this.email, required this.password});
}

/// Registering Event
class AuthEventRegistering extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  AuthEventRegistering({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
  });
}

class AuthEventSentEmailVerificationLink extends AuthEvent {}

class AuthEventForgotPassword extends AuthEvent {
  final String email;

  AuthEventForgotPassword({required this.email});
}

/// Logout User Event
class AuthEventPerformLogout extends AuthEvent {}

// Apple Login Event
class AuthEventAppleLogin extends AuthEvent {}

// Google Login Event
class AuthEventGoogleLogin extends AuthEvent {}
