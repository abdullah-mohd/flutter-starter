import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@unfreezed
class UserData with _$UserData {
  factory UserData({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    String? imageUrl,
    String? notifToken,
    DateTime? dateOfBirth,
    DateTime? createdAt,
  }) = _UserData;

  factory UserData.fromJson(Map<String, Object?> json) =>
      _$UserDataFromJson(json);
}
