import 'package:json_annotation/json_annotation.dart';

part 'payment_response.g.dart';

@JsonSerializable()
class PaymentResponse {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: '_links')
  final Links links;
  final String state;
  @JsonKey(name: '3ds')
  final ThreeDS? threeDS;
  @JsonKey(name: '3ds2')
  final ThreeDS2? threeDS2;

  PaymentResponse({
    required this.id,
    required this.links,
    required this.state,
    this.threeDS,
    this.threeDS2,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentResponseToJson(this);
}

@JsonSerializable()
class Links {
  final Link self;
  @JsonKey(name: 'cnp:3ds')
  final Link? cnp3ds;
  @JsonKey(name: 'cnp:3ds2-authentication')
  final Link? cnp3ds2Authentication;
  @JsonKey(name: 'cnp:3ds2-challenge-response')
  final Link? cnp3ds2ChallengeResponse;

  Links({
    required this.self,
    this.cnp3ds,
    this.cnp3ds2Authentication,
    this.cnp3ds2ChallengeResponse,
  });

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);
  Map<String, dynamic> toJson() => _$LinksToJson(this);
}

@JsonSerializable()
class Link {
  final String href;

  Link({required this.href});

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
  Map<String, dynamic> toJson() => _$LinkToJson(this);
}

@JsonSerializable()
class ThreeDS {
  final String acsUrl;
  final String acsPaReq;
  final String acsMd;
  final String summaryText;

  ThreeDS({
    required this.acsUrl,
    required this.acsPaReq,
    required this.acsMd,
    required this.summaryText,
  });

  factory ThreeDS.fromJson(Map<String, dynamic> json) =>
      _$ThreeDSFromJson(json);
  Map<String, dynamic> toJson() => _$ThreeDSToJson(this);
}

@JsonSerializable()
class ThreeDS2 {
  final String messageVersion;
  final String threeDSMethodURL;
  final String threeDSServerTransID;
  final String directoryServerID;

  ThreeDS2({
    required this.messageVersion,
    required this.threeDSMethodURL,
    required this.threeDSServerTransID,
    required this.directoryServerID,
  });

  factory ThreeDS2.fromJson(Map<String, dynamic> json) =>
      _$ThreeDS2FromJson(json);
  Map<String, dynamic> toJson() => _$ThreeDS2ToJson(this);
}
