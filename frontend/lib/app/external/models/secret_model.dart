import '../../domain/entities/secrets_entity.dart';

class SecretsModel extends SecretsEntity {
  SecretsModel({
    apiKey,
  }) : super(
          apiKey: apiKey,
        );

  SecretsModel.fromJson(Map<String, Object?> json)
      : this(
          apiKey: json['apiKey']! as String,
        );

  Map<String, dynamic> toJson() {
    return {
      "apiKey": apiKey,
    };
  }
}
