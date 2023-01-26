import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({name, mail, userUid, id, emailVerified})
      : super(
            name: name,
            mail: mail,
            userUid: userUid,
            id: id,
            emailVerified: emailVerified);

  factory UserModel.fromSnapshot(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        mail: json['mail'],
        userUid: json['userUid'],
        id: json['id'],
        emailVerified: json['emailVerified']);
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "mail": mail,
      "userUid": userUid,
      "id": id,
    };
  }

  factory UserModel.empty() => UserModel(
        name: null,
        mail: null,
        userUid: null,
        id: null,
      );
}
