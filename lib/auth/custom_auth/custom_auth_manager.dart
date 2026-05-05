import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/backend/schema/structs/index.dart';
import 'custom_auth_user_provider.dart';

export 'custom_auth_manager.dart';

const _kAuthTokenKey = '_auth_authentication_token_';
const _kRefreshTokenKey = '_auth_refresh_token_';
const _kTokenExpirationKey = '_auth_token_expiration_';
const _kUidKey = '_auth_uid_';
const _kUserDataKey = '_auth_user_data_';

class CustomAuthManager {
  // Auth session attributes
  String? authenticationToken;
  String? refreshToken;
  DateTime? tokenExpiration;
  // User attributes
  String? uid;
  UserStruct? userData;

  Future signOut() async {
    authenticationToken = null;
    refreshToken = null;
    tokenExpiration = null;
    uid = null;
    userData = null;
    // Update the current user.
    albarranDespachoAuthUserSubject.add(
      AlbarranDespachoAuthUser(loggedIn: false),
    );
    persistAuthData();
  }

  Future<AlbarranDespachoAuthUser?> signIn({
    String? authenticationToken,
    String? refreshToken,
    DateTime? tokenExpiration,
    String? authUid,
    UserStruct? userData,
  }) async =>
      _updateCurrentUser(
        authenticationToken: authenticationToken,
        refreshToken: refreshToken,
        tokenExpiration: tokenExpiration,
        authUid: authUid,
        userData: userData,
      );

  void updateAuthUserData({
    String? authenticationToken,
    String? refreshToken,
    DateTime? tokenExpiration,
    String? authUid,
    UserStruct? userData,
  }) {
    assert(
      currentUser?.loggedIn ?? false,
      'User must be logged in to update auth user data.',
    );

    _updateCurrentUser(
      authenticationToken: authenticationToken,
      refreshToken: refreshToken,
      tokenExpiration: tokenExpiration,
      authUid: authUid,
      userData: userData,
    );
  }

  AlbarranDespachoAuthUser? _updateCurrentUser({
    String? authenticationToken,
    String? refreshToken,
    DateTime? tokenExpiration,
    String? authUid,
    UserStruct? userData,
  }) {
    final normalizedToken = authenticationToken?.trim();
    final resolvedTokenExpiration = tokenExpiration ??
        (normalizedToken?.isNotEmpty == true
            ? _tokenExpirationFromJwt(normalizedToken!)
            : null);

    this.authenticationToken = normalizedToken;
    this.refreshToken = refreshToken;
    this.tokenExpiration = resolvedTokenExpiration;
    this.uid = authUid;
    this.userData = userData;
    final tokenIsValid = normalizedToken != null &&
        normalizedToken.isNotEmpty &&
        (resolvedTokenExpiration == null ||
            resolvedTokenExpiration.isAfter(DateTime.now()));
    // Update the current user stream.
    final updatedUser = AlbarranDespachoAuthUser(
      loggedIn: tokenIsValid,
      uid: authUid,
      userData: userData,
    );
    albarranDespachoAuthUserSubject.add(updatedUser);
    persistAuthData();
    return updatedUser;
  }

  late SharedPreferences _prefs;
  Future initialize() async {
    _prefs = await SharedPreferences.getInstance();

    try {
      authenticationToken = _prefs.getString(_kAuthTokenKey);
      refreshToken = _prefs.getString(_kRefreshTokenKey);
      tokenExpiration = _prefs.getInt(_kTokenExpirationKey) != null
          ? DateTime.fromMillisecondsSinceEpoch(
              _prefs.getInt(_kTokenExpirationKey)!)
          : null;
      if (tokenExpiration == null &&
          authenticationToken != null &&
          authenticationToken!.trim().isNotEmpty) {
        tokenExpiration = _tokenExpirationFromJwt(authenticationToken!.trim());
      }
      uid = _prefs.getString(_kUidKey);
      userData = _prefs.getString(_kUserDataKey) != null
          ? UserStruct.fromSerializableMap(
              (jsonDecode(_prefs.getString(_kUserDataKey)!) as Map)
                  .cast<String, dynamic>(),
            )
          : null;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing auth: $e');
      }
      return;
    }

    final authTokenExists =
        authenticationToken != null && authenticationToken!.trim().isNotEmpty;
    final tokenExpired =
        tokenExpiration == null || tokenExpiration!.isBefore(DateTime.now());
    final updatedUser = AlbarranDespachoAuthUser(
      loggedIn: authTokenExists && !tokenExpired,
      uid: uid,
      userData: userData,
    );
    albarranDespachoAuthUserSubject.add(updatedUser);
  }

  void persistAuthData() {
    authenticationToken != null
        ? _prefs.setString(_kAuthTokenKey, authenticationToken!)
        : _prefs.remove(_kAuthTokenKey);
    refreshToken != null
        ? _prefs.setString(_kRefreshTokenKey, refreshToken!)
        : _prefs.remove(_kRefreshTokenKey);
    tokenExpiration != null
        ? _prefs.setInt(
            _kTokenExpirationKey, tokenExpiration!.millisecondsSinceEpoch)
        : _prefs.remove(_kTokenExpirationKey);
    uid != null ? _prefs.setString(_kUidKey, uid!) : _prefs.remove(_kUidKey);
    userData != null
        ? _prefs.setString(
            _kUserDataKey, jsonEncode(userData!.toSerializableMap()))
        : _prefs.remove(_kUserDataKey);
  }

  DateTime? _tokenExpirationFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) {
        return null;
      }

      final payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final payloadMap = jsonDecode(payload);
      if (payloadMap is! Map<String, dynamic>) {
        return null;
      }

      final exp = payloadMap['exp'];
      if (exp is num) {
        return DateTime.fromMillisecondsSinceEpoch((exp * 1000).toInt());
      }
      if (exp is String) {
        final parsedExp = int.tryParse(exp);
        if (parsedExp != null) {
          return DateTime.fromMillisecondsSinceEpoch(parsedExp * 1000);
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}

AlbarranDespachoAuthUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
