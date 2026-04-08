import 'package:rxdart/rxdart.dart';

import '/backend/schema/structs/index.dart';
import 'custom_auth_manager.dart';

class AlbarranDespachoAuthUser {
  AlbarranDespachoAuthUser({
    required this.loggedIn,
    this.uid,
    this.userData,
  });

  bool loggedIn;
  String? uid;
  UserStruct? userData;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<AlbarranDespachoAuthUser> albarranDespachoAuthUserSubject =
    BehaviorSubject.seeded(AlbarranDespachoAuthUser(loggedIn: false));
Stream<AlbarranDespachoAuthUser> albarranDespachoAuthUserStream() =>
    albarranDespachoAuthUserSubject
        .asBroadcastStream()
        .map((user) => currentUser = user);
