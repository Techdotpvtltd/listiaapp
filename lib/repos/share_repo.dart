// Project: 	   listi_shop
// File:    	   share_repo
// Path:    	   lib/repos/share_repo.dart
// Author:       Ali Akbar
// Date:        31-01-25 20:12:50 -- Friday
// Description:

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listi_shop/models/list_model.dart';
import 'package:listi_shop/models/request.dart';
import 'package:listi_shop/repos/user_repo.dart';
import 'package:listi_shop/web_services/firestore_services.dart';
import 'package:listi_shop/web_services/query_model.dart';

import '../exceptions/data_exceptions.dart';
import '../exceptions/exception_parsing.dart';
import '../managers/app_manager.dart';
import '../models/user_model.dart';
import '../utils/constants/firebase_collections.dart';
import 'subscription_repo.dart';

class ShareRepo {
  final UserModel user = UserRepo().currentUser;
  DocumentSnapshot? lastSnapDoc;
  late final UserInfoModel userInfoModel = UserInfoModel(
      uid: user.uid,
      name: user.name,
      email: user.email,
      avatar: user.avatar,
      phoneNumber: user.phoneNumber);
  Future<void> sendInvite({
    required ListModel list,
    required List<UserInfoModel> inviteUsers,
    required int totalInvited,
  }) async {
    try {
      if (!AppManager().isActiveSubscription) {
        throw DataExceptionSubscriptionRequired(
            message:
                "You donn't have limit to share list with others in free plan. Please update your plan to share list with other users.");
      }
      final currentSub = SubscriptionRepo().lastSubscription;

      if (currentSub != null) {
        if (currentSub.title.toLowerCase() == "house" && totalInvited > 5) {
          throw DataExceptionSubscriptionRequired(
              message:
                  "You have completed your share limit in this mode. Please update your plan to share list with more users.");
        }

        if (currentSub.title.toLowerCase() == "business" && totalInvited > 20) {
          throw DataExceptionSubscriptionRequired(
              message:
                  "You have completed your share limit in this mode. Please update your plan to share list with more users.");
        }
      }

      for (final UserInfoModel invitingUser in inviteUsers) {
        final RequestModel model = RequestModel(
            uid: "",
            sharedBy: userInfoModel,
            sharedTo: invitingUser,
            listId: list.id,
            listTitle: list.title,
            status: RequestStatus.pending,
            createdAt: DateTime.now());
        await FirestoreService().saveWithSpecificIdFiled(
          path: FIREBASE_COLLECTION_REQUESTS,
          data: model.toMap(),
          docIdFiled: 'uid',
        );
      }
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  Future<List<RequestModel>> fetchPendingRequest() async {
    try {
      final data = await FirestoreService().fetchWithMultipleConditions(
          collection: FIREBASE_COLLECTION_REQUESTS,
          queries: [
            QueryModel(
                field: "sharedBy", value: user.uid, type: QueryType.isEqual),
            QueryModel(field: "uid", value: false, type: QueryType.orderBy),
            QueryModel(field: "", value: 10, type: QueryType.limit),
            if (lastSnapDoc != null)
              QueryModel(
                  field: "",
                  value: lastSnapDoc,
                  type: QueryType.startAfterDocument),
          ],
          lastDocSnapshot: (last) {
            lastSnapDoc = last;
          });

      return data.map((e) => RequestModel.fromMap(e)).toList();
    } catch (e) {
      throw throwAppException(e: e);
    }
  }
}
