import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../exceptions/auth_exceptions.dart';
import '../../repos/auth_repo.dart';
import '../../repos/user_repo.dart';
import '../../screens/onboarding/splash_screen.dart';
import '../../utils/extensions/navigation_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateUninitialize()) {
    // on Initialize  ========================================
    on<AuthEventInitialize>((event, emit) {
      emit(AuthStateLoginRequired(isLoading: false));
    });

    // On Logout Request  ============================================
    on<AuthEventPerformLogout>(
      (event, emit) async {
        await AuthRepo().performLogout();
        NavigationService.offAll(const SplashScreen());
        emit(AuthStateInitialize());
      },
    );

    // Splash Process completed  ============================================
    on<AuthEventSplashAction>((event, emit) async {
      try {
        if (FirebaseAuth.instance.currentUser == null) {
          emit(AuthStateLoginRequired());
          return;
        }
        await UserRepo().fetch();
        emit(AuthStateSplashActionDone());
      } on AppException catch (e) {
        emit(AuthStateLoginRequired());
        debugPrint(e.message);
      }
    });

    on<AuthEventSentEmailVerificationLink>(
      (event, emit) async {
        try {
          emit(AuthStateSendingMailVerification());
          await AuthRepo().sendEmailVerifcationLink();
          emit(AuthStateSentMailVerification());
        } on AppException catch (e) {
          emit(AuthStateSendingMailVerificationFailure(exception: e));
        }
      },
    );
    on<AuthEventPerformLogin>((event, emit) async {
      emit(AuthStateLogging());

      try {
        await AuthRepo()
            .loginUser(withEmail: event.email, withPassword: event.password);
        emit(AuthStateLoggedIn());
        // NavigationService.offAll(navKey.currentContext!, SplashScreen());
      } on AppException catch (e) {
        if (e is AuthExceptionEmailVerificationRequired) {
          emit(AuthStateEmailVerificationRequired(exception: e));
          return;
        }
        emit(AuthStateLoginFailure(exception: e));
      }
    });

    on<AuthEventForgotPassword>(
      (event, emit) async {
        try {
          emit(AuthStateSendingForgotEmail());
          await AuthRepo().sendForgotPasswordEmail(atMail: event.email);
          emit(AuthStateSentForgotEmail());
        } on AppException catch (e) {
          emit(AuthStateSendForgotEmailFailure(exception: e));
        }
      },
    );

    // Perform Registering Screens  ============================================
    on<AuthEventRegistering>(
      (event, emit) async {
        emit(AuthStateRegistering(loadingText: "Creating user."));

        try {
          await AuthRepo().registeredUser(
            name: event.name,
            email: event.email,
            password: event.password,
            confirmPassword: event.confirmPassword,
            phoenNumber: event.phoneNumber,
          );
          emit(AuthStateRegistered());
        } on AppException catch (e) {
          emit(AuthStateRegisterFailure(exception: e));
        }
      },
    );

    // Apple Login Event
    on<AuthEventAppleLogin>((event, emit) async {
      try {
        emit(AuthStateLogging(loadingText: "Signing with Apple."));
        await AuthRepo().loginWithApple();
        emit(AuthStateAppleLoggedIn());
      } on AppException catch (e) {
        emit(AuthStateLoginFailure(exception: e));
      }
    });

    //Google Login Event
    on<AuthEventGoogleLogin>((event, emit) async {
      emit(AuthStateLogging(
          isLoading: true, loadingText: "Signing with Google."));
      try {
        await AuthRepo().loginWithGoogle();
        emit(AuthStateGoogleLoggedIn());
      } on AppException catch (e) {
        emit(AuthStateLoginFailure(exception: e));
      }
    });
  }
}
