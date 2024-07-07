// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResponse _$PaymentResponseFromJson(Map<String, dynamic> json) =>
    PaymentResponse(
      id: json['_id'] as String,
      links: Links.fromJson(json['_links'] as Map<String, dynamic>),
      state: json['state'] as String,
      threeDS: json['3ds'] == null
          ? null
          : ThreeDS.fromJson(json['3ds'] as Map<String, dynamic>),
      threeDS2: json['3ds2'] == null
          ? null
          : ThreeDS2.fromJson(json['3ds2'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentResponseToJson(PaymentResponse instance) =>
    <String, dynamic>{
      '_id': instance.id,
      '_links': instance.links,
      'state': instance.state,
      '3ds': instance.threeDS,
      '3ds2': instance.threeDS2,
    };

Links _$LinksFromJson(Map<String, dynamic> json) => Links(
      self: Link.fromJson(json['self'] as Map<String, dynamic>),
      cnp3ds: json['cnp:3ds'] == null
          ? null
          : Link.fromJson(json['cnp:3ds'] as Map<String, dynamic>),
      cnp3ds2Authentication: json['cnp:3ds2-authentication'] == null
          ? null
          : Link.fromJson(
              json['cnp:3ds2-authentication'] as Map<String, dynamic>),
      cnp3ds2ChallengeResponse: json['cnp:3ds2-challenge-response'] == null
          ? null
          : Link.fromJson(
              json['cnp:3ds2-challenge-response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LinksToJson(Links instance) => <String, dynamic>{
      'self': instance.self,
      'cnp:3ds': instance.cnp3ds,
      'cnp:3ds2-authentication': instance.cnp3ds2Authentication,
      'cnp:3ds2-challenge-response': instance.cnp3ds2ChallengeResponse,
    };

Link _$LinkFromJson(Map<String, dynamic> json) => Link(
      href: json['href'] as String,
    );

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
      'href': instance.href,
    };

ThreeDS _$ThreeDSFromJson(Map<String, dynamic> json) => ThreeDS(
      acsUrl: json['acsUrl'] as String,
      acsPaReq: json['acsPaReq'] as String,
      acsMd: json['acsMd'] as String,
      summaryText: json['summaryText'] as String,
    );

Map<String, dynamic> _$ThreeDSToJson(ThreeDS instance) => <String, dynamic>{
      'acsUrl': instance.acsUrl,
      'acsPaReq': instance.acsPaReq,
      'acsMd': instance.acsMd,
      'summaryText': instance.summaryText,
    };

ThreeDS2 _$ThreeDS2FromJson(Map<String, dynamic> json) => ThreeDS2(
      messageVersion: json['messageVersion'] as String,
      threeDSMethodURL: json['threeDSMethodURL'] as String,
      threeDSServerTransID: json['threeDSServerTransID'] as String,
      directoryServerID: json['directoryServerID'] as String,
    );

Map<String, dynamic> _$ThreeDS2ToJson(ThreeDS2 instance) => <String, dynamic>{
      'messageVersion': instance.messageVersion,
      'threeDSMethodURL': instance.threeDSMethodURL,
      'threeDSServerTransID': instance.threeDSServerTransID,
      'directoryServerID': instance.directoryServerID,
    };
