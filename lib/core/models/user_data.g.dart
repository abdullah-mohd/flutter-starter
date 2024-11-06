// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      videoName: json['videoName'] as String?,
      pronoun: json['pronoun'] as String?,
      imageUrl: json['imageUrl'] as String?,
      notifToken: json['notifToken'] as String?,
      authorised: json['authorised'] as bool?,
      RAT_on: json['RAT_on'] as num?,
      oauthRequestToken: json['oauthRequestToken'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      preferredUnit: json['preferredUnit'] as String?,
      autoTriggerType: json['autoTriggerType'] as String?,
      autoTriggerValue: (json['autoTriggerValue'] as num?)?.toInt(),
      videoOrientation: json['videoOrientation'] as String?,
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'videoName': instance.videoName,
      'pronoun': instance.pronoun,
      'imageUrl': instance.imageUrl,
      'notifToken': instance.notifToken,
      'authorised': instance.authorised,
      'RAT_on': instance.RAT_on,
      'oauthRequestToken': instance.oauthRequestToken,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'preferredUnit': instance.preferredUnit,
      'autoTriggerType': instance.autoTriggerType,
      'autoTriggerValue': instance.autoTriggerValue,
      'videoOrientation': instance.videoOrientation,
    };
