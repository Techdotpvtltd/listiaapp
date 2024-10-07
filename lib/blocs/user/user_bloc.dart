import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import 'user_event.dart';
import 'user_state.dart';

/// Project: 	   playtogethher
/// File:    	   user_bloc
/// Path:    	   lib/blocs/user/user_bloc.dart
/// Author:       Ali Akbar
/// Date:        13-03-24 15:43:26 -- Wednesday
/// Description:

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserStateInitial()) {
    on<UserEventUpdateProfile>(
      (event, emit) async {
        try {
          final UserModel user = UserRepo().currentUser;
          String avatarUrl = user.avatar;

          if (event.avatarUrl != null) {
            emit(UserStateAvatarUploading());
            avatarUrl =
                await UserRepo().uploadProfile(path: event.avatarUrl ?? "");
            emit(UserStateAvatarUploaded());
          }

          emit(UserStateProfileUpdating());

          final UserModel updatedModel = await UserRepo().update(
            name: event.name,
            email: event.email,
            phone: event.phone,
            imagePath: avatarUrl,
          );
          emit(UserStateProfileUpdated(user: updatedModel));
        } on AppException catch (e) {
          emit(UserStateProfileUpdatingFailure(exception: e));
        }
      },
    );
  }
}
