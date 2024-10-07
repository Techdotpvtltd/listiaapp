import '../../exceptions/app_exceptions.dart';

abstract class AuthState {
  final bool isLoading;
  final String loadingText;
  AuthState({this.isLoading = false, this.loadingText = ""});
}

// AuthStateUnitialize ========================================
class AuthStateUninitialize extends AuthState {
  AuthStateUninitialize({super.isLoading});
}

// AuthStateInitialize  ========================================
class AuthStateInitialize extends AuthState {
  AuthStateInitialize({super.isLoading});
}

// AuthStateLogout  ========================================

class AuthStateLogout extends AuthState {
  AuthStateLogout({super.isLoading});
}

// AuthStateStartup  ========================================
class AuthStateLoginRequired extends AuthState {
  AuthStateLoginRequired({super.isLoading});
}

// AuthStateRegistering  ========================================
class AuthStateRegisterring extends AuthState {
  final Exception? exception;

  AuthStateRegisterring({this.exception, super.isLoading});
}

// AuthStateForgotPassword  ========================================
class AuthStateSendingForgotEmail extends AuthState {
  AuthStateSendingForgotEmail({super.isLoading = true});
}

class AuthStateSendForgotEmailFailure extends AuthState {
  final AppException exception;

  AuthStateSendForgotEmailFailure({required this.exception});
}

class AuthStateSentForgotEmail extends AuthState {}

// Auth State Loging with apple
class AuthStateAppleLogging extends AuthState {
  final AppException? exception;
  AuthStateAppleLogging({super.isLoading, super.loadingText, this.exception});
}

class AuthStateAppleLoggedIn extends AuthState {
  AuthStateAppleLoggedIn();
}

// Auth State Loging with google
class AuthStateGoogleLogging extends AuthState {
  final AppException? exception;
  AuthStateGoogleLogging({super.isLoading, super.loadingText, this.exception});
}

class AuthStateGoogleLoggedIn extends AuthState {
  AuthStateGoogleLoggedIn();
}

// AuthStateLoggedIn  ========================================
class AuthStateLoggedIn extends AuthState {
  AuthStateLoggedIn();
}

/// AuthStateSplashActionDone
class AuthStateSplashActionDone extends AuthState {}

class AuthStateLogging extends AuthState {
  AuthStateLogging({super.isLoading = true, super.loadingText = "Login..."});
}

class AuthStateEmailVerificationRequired extends AuthState {
  final AppException exception;
  AuthStateEmailVerificationRequired({required this.exception});
}

class AuthStateLoginFailure extends AuthState {
  final AppException exception;

  AuthStateLoginFailure({required this.exception});
}

// Registered State  ========================================
class AuthStateRegistering extends AuthState {
  AuthStateRegistering(
      {super.isLoading = true, super.loadingText = 'Registering..'});
}

class AuthStateRegisterFailure extends AuthState {
  final AppException exception;

  AuthStateRegisterFailure({required this.exception});
}

// Registered State  ========================================
class AuthStateRegistered extends AuthState {
  AuthStateRegistered();
}

// EnabledNotificationState  ========================================
class AuthStateEnabledNotification extends AuthState {
  AuthStateEnabledNotification({super.isLoading});
}

// NeedToEnableNotificationState  ========================================
class AuthStateNeedsToEnableNotification extends AuthState {
  AuthStateNeedsToEnableNotification({super.isLoading});
}

// AuthStateAllowedLocation  ========================================
class AuthStateAllowedLocation extends AuthState {
  AuthStateAllowedLocation({super.isLoading});
}

// AuthStateNeedToAllowLocation  ========================================
class AuthStateNeedToAllowLocation extends AuthState {
  AuthStateNeedToAllowLocation({super.isLoading});
}

// ===========================Mail Verification Link Sent State================================

class AuthStateSendingMailVerification extends AuthState {
  AuthStateSendingMailVerification(
      {super.isLoading = true,
      super.loadingText = "Verification Link Sending..."});
}

class AuthStateSendingMailVerificationFailure extends AuthState {
  final AppException exception;
  AuthStateSendingMailVerificationFailure({required this.exception});
}

class AuthStateSentMailVerification extends AuthState {
  AuthStateSentMailVerification();
}
