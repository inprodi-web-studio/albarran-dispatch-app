// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserStruct extends BaseStruct {
  UserStruct({
    String? uuid,
    String? name,
    String? lastName,
    String? email,
    String? branch,
  })  : _uuid = uuid,
        _name = name,
        _lastName = lastName,
        _email = email,
        _branch = branch;

  // "uuid" field.
  String? _uuid;
  String get uuid => _uuid ?? '';
  set uuid(String? val) => _uuid = val;

  bool hasUuid() => _uuid != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "lastName" field.
  String? _lastName;
  String get lastName => _lastName ?? '';
  set lastName(String? val) => _lastName = val;

  bool hasLastName() => _lastName != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "branch" field.
  String? _branch;
  String get branch => _branch ?? '';
  set branch(String? val) => _branch = val;

  bool hasBranch() => _branch != null;

  static UserStruct fromMap(Map<String, dynamic> data) => UserStruct(
        uuid: data['uuid'] as String?,
        name: data['name'] as String?,
        lastName: data['lastName'] as String?,
        email: data['email'] as String?,
        branch: data['branch'] as String?,
      );

  static UserStruct? maybeFromMap(dynamic data) =>
      data is Map ? UserStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'uuid': _uuid,
        'name': _name,
        'lastName': _lastName,
        'email': _email,
        'branch': _branch,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'uuid': serializeParam(
          _uuid,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'lastName': serializeParam(
          _lastName,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'branch': serializeParam(
          _branch,
          ParamType.String,
        ),
      }.withoutNulls;

  static UserStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserStruct(
        uuid: deserializeParam(
          data['uuid'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        lastName: deserializeParam(
          data['lastName'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        branch: deserializeParam(
          data['branch'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UserStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserStruct &&
        uuid == other.uuid &&
        name == other.name &&
        lastName == other.lastName &&
        email == other.email &&
        branch == other.branch;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([uuid, name, lastName, email, branch]);
}

UserStruct createUserStruct({
  String? uuid,
  String? name,
  String? lastName,
  String? email,
  String? branch,
}) =>
    UserStruct(
      uuid: uuid,
      name: name,
      lastName: lastName,
      email: email,
      branch: branch,
    );
