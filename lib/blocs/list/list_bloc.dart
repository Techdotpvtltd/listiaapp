// Project: 	   listi_shop
// File:    	   list_bloc
// Path:    	   lib/blocs/list/list_bloc.dart
// Author:       Ali Akbar
// Date:        22-04-24 17:12:38 -- Monday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../repos/list_repo.dart';
import 'list_event.dart';
import 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListStateInitial()) {
    // Create List Event
    on<ListEventCreate>((event, emit) async {
      try {
        emit(ListStateCreating());
        await ListRepo().createList(title: event.title);
        emit(ListStateCreated());
      } on AppException catch (e) {
        emit(ListStateCreateFailure(exception: e));
      }
    });

    // Fetch List Event
    on<ListEventFetch>((event, emit) async {
      emit(ListStateFetching());
      await ListRepo().fetchLists(
        onData: () {
          emit(ListStateNewAdded());
        },
        onAllDataGet: () {
          emit(ListStateFetched());
        },
        onError: (e) {
          emit(ListStateFetchFailure(exception: e));
        },
      );
    });

    // Fetch Admin List Event
    on<ListEventAdminFetch>(
      (event, emit) async {
        emit(ListStateAdminFetching());
        await ListRepo().fetchAdminLists(
          onData: () {
            emit(ListStateNewAdminAdded());
          },
          onAllDataGet: () {
            emit(ListStateAdminFetched());
          },
          onError: (e) {
            emit(ListStateAdminFetchFailure(exception: e));
          },
        );
      },
    );

    // Move List to User Event
    on<ListEventMove>(
      (event, emit) async {
        try {
          emit(ListStateMoving(listId: event.listId));
          await ListRepo().moveListToUser(listId: event.listId);
          emit(ListStateMoved());
        } on AppException catch (e) {
          emit(ListStateMoveFailure(exception: e));
        }
      },
    );

    on<ListEventUpdate>(
      (event, emit) async {
        try {
          emit(ListStateUpdating());
          await ListRepo().updateList(
            id: event.listId,
            title: event.title,
          );
          emit(ListStateUpdated());
        } on AppException catch (e) {
          emit(ListStateUpdateFailure(exception: e));
        }
      },
    );

    on<ListEventDelete>(
      (event, emit) async {
        try {
          emit(ListStateDeleting());
          await ListRepo().deleteList(
            id: event.listId,
            itemsIds: event.itemsIds,
          );
          emit(ListStateDeleted());
        } on AppException catch (e) {
          emit(ListStateDeleteFailure(exception: e));
        }
      },
    );

    on<ListEventMarkCompleted>(
      (event, emit) async {
        try {
          emit(ListStateMarkCompleting());
          await ListRepo().markCompleted(id: event.listId);
          emit(ListStateMarkCompleted());
        } on AppException catch (e) {
          emit(ListStateMarkCompleteFailure(exception: e));
        }
      },
    );
  }
}
