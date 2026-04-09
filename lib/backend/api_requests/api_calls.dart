import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start Auth Group Code

class AuthGroup {
  static String getBaseUrl() =>
      'https://albarran-gas-fgajf.ondigitalocean.app/api';
  static Map<String, String> headers = {'ngrok-skip-browser-warning': 'true'};
  static LoginCall loginCall = LoginCall();
  static SelectBombsCall selectBombsCall = SelectBombsCall();
  static LogoutCall logoutCall = LogoutCall();
}

class LoginCall {
  Future<ApiCallResponse> call({
    String? email = '',
    String? password = '',
    String? branch = '',
  }) async {
    final baseUrl = AuthGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "email": "${email}",
  "password": "${password}",
  "branch": "${branch}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Login',
      apiUrl: '${baseUrl}/dispatcher/auth/login',
      callType: ApiCallType.POST,
      headers: {'ngrok-skip-browser-warning': 'true'},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? token(dynamic response) =>
      castToType<String>(getJsonField(response, r'''$.token'''));
  String? uuid(dynamic response) =>
      castToType<String>(getJsonField(response, r'''$.uuid'''));
  String? name(dynamic response) =>
      castToType<String>(getJsonField(response, r'''$.name'''));
  String? lastName(dynamic response) =>
      castToType<String>(getJsonField(response, r'''$.lastName'''));
  String? email(dynamic response) =>
      castToType<String>(getJsonField(response, r'''$.email'''));
  String? phone(dynamic response) =>
      castToType<String>(getJsonField(response, r'''$.phone'''));
  String? errorKey(dynamic response) =>
      castToType<String>(getJsonField(response, r'''$.key'''));
  String? gender(dynamic response) =>
      castToType<String>(getJsonField(response, r'''$.gender'''));
  String? birthdate(dynamic response) =>
      castToType<String>(getJsonField(response, r'''$.birthdate'''));
}

class SelectBombsCall {
  Future<ApiCallResponse> call({
    List<int>? bombsList,
    String? token = '',
  }) async {
    final baseUrl = AuthGroup.getBaseUrl();
    final bombs = _serializeList(bombsList);

    final ffApiRequestBody = '''
{
  "bombs": ${bombs}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Select Bombs',
      apiUrl: '${baseUrl}/dispatcher/auth/set-bombs',
      callType: ApiCallType.PATCH,
      headers: {
        'ngrok-skip-browser-warning': 'true',
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class LogoutCall {
  Future<ApiCallResponse> call({String? token = ''}) async {
    final baseUrl = AuthGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'Logout',
      apiUrl: '${baseUrl}/dispatcher/auth/logout',
      callType: ApiCallType.POST,
      headers: {
        'ngrok-skip-browser-warning': 'true',
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Auth Group Code

/// Start Bombs Group Code

class BombsGroup {
  static String getBaseUrl({String? token = ''}) =>
      'https://albarran-gas-fgajf.ondigitalocean.app/api';
  static Map<String, String> headers = {'Authorization': 'Bearer [token]'};
  static FindManyBombsCall findManyBombsCall = FindManyBombsCall();
}

class FindManyBombsCall {
  Future<ApiCallResponse> call({String? token = ''}) async {
    final baseUrl = BombsGroup.getBaseUrl(token: token);

    return ApiManager.instance.makeApiCall(
      callName: 'Find Many Bombs',
      apiUrl: '${baseUrl}/dispatcher/bombs',
      callType: ApiCallType.GET,
      headers: {'Authorization': 'Bearer ${token}'},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Bombs Group Code

/// Start Customers Group Code

class CustomersGroup {
  static String getBaseUrl({String? token = ''}) =>
      'https://albarran-gas-fgajf.ondigitalocean.app/api';
  static Map<String, String> headers = {'Authorization': 'Bearer [token]'};
  static FindOneCustomerCall findOneCustomerCall = FindOneCustomerCall();
}

class FindOneCustomerCall {
  Future<ApiCallResponse> call({String? uuid = '', String? token = ''}) async {
    final baseUrl = CustomersGroup.getBaseUrl(token: token);

    return ApiManager.instance.makeApiCall(
      callName: 'Find One Customer',
      apiUrl: '${baseUrl}/dispatcher/customers/${uuid}',
      callType: ApiCallType.GET,
      headers: {'Authorization': 'Bearer ${token}'},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Customers Group Code

/// Start Loads Group Code

class LoadsGroup {
  static String getBaseUrl({String? token = ''}) =>
      'https://albarran-gas-fgajf.ondigitalocean.app/api';
  static Map<String, String> headers = {'Authorization': 'Bearer [token]'};
  static FindLastLoadCall findLastLoadCall = FindLastLoadCall();
  static AssignLoadCall assignLoadCall = AssignLoadCall();
}

class FindLastLoadCall {
  Future<ApiCallResponse> call({int? bombId, String? token = ''}) async {
    final baseUrl = LoadsGroup.getBaseUrl(token: token);

    return ApiManager.instance.makeApiCall(
      callName: 'Find Last Load',
      apiUrl: '${baseUrl}/dispatcher/loads/${bombId}',
      callType: ApiCallType.GET,
      headers: {'Authorization': 'Bearer ${token}'},
      params: {'last': "true"},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? date(dynamic response) =>
      castToType<String>(getJsonField(response, r'''$.datetime_combined'''));
}

class AssignLoadCall {
  Future<ApiCallResponse> call({
    String? customer = '',
    String? vehicle,
    String? fleet,
    String? product = '',
    String? quantity = '',
    String? price = '',
    String? total = '',
    String? date = '',
    String? token = '',
  }) async {
    final baseUrl = LoadsGroup.getBaseUrl(token: token);

    final ffApiRequestBody = '''
{
  "customer": "${customer}",
  "vehicle": ${vehicle == null ? 'null' : '"${vehicle}"'},
  "fleet": ${fleet == null ? 'null' : '"${fleet}"'},
  "product": "${product}",
  "quantity": ${quantity},
  "price": ${price},
  "total": ${total},
  "date": "${date}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Assign Load',
      apiUrl: '${baseUrl}/dispatcher/loads',
      callType: ApiCallType.POST,
      headers: {'Authorization': 'Bearer ${token}'},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Loads Group Code

/// Start Promotions Group Code

class PromotionsGroup {
  static String getBaseUrl({String? token = ''}) =>
      'https://albarran-gas-fgajf.ondigitalocean.app/api';
  static Map<String, String> headers = {'Authorization': 'Bearer [token]'};
  static ResolvePromotionCall resolvePromotionCall = ResolvePromotionCall();
}

class ResolvePromotionCall {
  Future<ApiCallResponse> call({
    String? customer = '',
    String? vehicle,
    String? fleet,
    String? quantity,
    String? token = '',
  }) async {
    final baseUrl = PromotionsGroup.getBaseUrl(token: token);

    final parsedQuantity = (quantity ?? '').trim();

    final ffApiRequestBody = '''
{
  "customer": "${customer}",
  "vehicle": ${vehicle == null ? 'null' : '"${vehicle}"'},
  "fleet": ${fleet == null ? 'null' : '"${fleet}"'},
  "quantity": ${parsedQuantity.isEmpty ? 'null' : parsedQuantity}
}''';

    return ApiManager.instance.makeApiCall(
      callName: 'Resolve Promotion',
      apiUrl: '${baseUrl}/dispatcher/promotions/resolve',
      callType: ApiCallType.POST,
      headers: {'Authorization': 'Bearer ${token}'},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Promotions Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
