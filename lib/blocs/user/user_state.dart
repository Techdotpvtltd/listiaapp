import '../../exceptions/app_exceptions.dart';
import '../../models/user_model.dart';

/// Project: 	   playtogethher
/// File:    	   user_state
/// Path:    	   lib/blocs/user/user_state.dart
/// Author:       Ali Akbar
/// Date:        13-03-24 15:30:25 -- Wednesday
/// Description:

abstract class UserState {
  final bool isLoading;
  final String loadingText;

  UserState({this.isLoading = false, this.loadingText = ""});
}

// Initial Sttate
class UserStateInitial extends UserState {}

// =========================== Avatar States================================
class UserStateAvatarUploading extends UserState {
  UserStateAvatarUploading(
      {super.isLoading = true, super.loadingText = "Uploading Avatar."});
}

class UserStatAvatareUploadingFailure extends UserState {
  final AppException exception;
  UserStatAvatareUploadingFailure({required this.exception});
}

class UserStateAvatarUploaded extends UserState {}

// =========================== Update Profile States ================================
class UserStateProfileUpdating extends UserState {
  UserStateProfileUpdating(
      {super.isLoading = true, super.loadingText = "Updating Profile."});
}

class UserStateProfileUpdatingFailure extends UserState {
  final AppException exception;
  UserStateProfileUpdatingFailure({required this.exception});
}

class UserStateProfileUpdated extends UserState {
  final UserModel user;

  UserStateProfileUpdated({required this.user});
}
