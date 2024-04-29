// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart' show kReleaseMode;

const String FIREBASE_COLLECTION_USER =
    "${kReleaseMode ? "Rel-" : "Dev-"}Users";
const String FIREBASE_COLLECTION_USER_PROFILES =
    "${kReleaseMode ? "Rel-" : "Dev-"}Avatars";
const String FIREBASE_COLLECTION_LISTS =
    "${kReleaseMode ? "Rel-" : "Dev-"}Lists";

const String FIREBASE_COLLECTION_ITEMS =
    "${kReleaseMode ? "Rel-" : "Dev-"}Items";
const FIREBASE_COLLECTION_CATEGORY =
    "${kReleaseMode ? "Rel-" : "Dev-"}Categories";

const String FIREBASE_COLLECTION_LISTS_ADMIN =
    "${kReleaseMode ? "Rel-" : "Dev-"}Admin-Lists";

const String FIREBASE_COLLECTION_ITEMS_ADMIN =
    "${kReleaseMode ? "Rel-" : "Dev-"}Admin-Items";
