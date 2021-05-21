import 'package:json_annotation/json_annotation.dart';
import 'package:twake/models/base_model/base_model.dart';

part 'authentication.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Authentication extends BaseModel {
  final String token;
  final String refreshToken;

  final int expiration;
  final int refreshExpiration;

  Authentication({
    required this.token,
    required this.refreshToken,
    required this.expiration,
    required this.refreshExpiration,
  });

  factory Authentication.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationFromJson(json);

  @override
  Map<String, dynamic> toJson({stringify: true}) =>
      _$AuthenticationToJson(this);
}

/// /authorize response example
// "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.ayJleHAiOjE2MjEzNFg1MjIsInR5cGUiOiJhY2Nlc3MiLCJpYXQiOjE2MjEzNDQzMjIsIm5iZiI6MTYyMTM0NDMyMiwic3ViIjoiNTI2OGZhODAtMTlkMi0xMWViLWI3NzQtMDI0MmFjMTIwMDA0IiwiZW1haWwiOiJibWFraG11ZG92QGxpbmFnb3JhLmNvbSIsIm9yZyI6eyJhYzFhMDU0NC0xZGNjLTExZWItYmY5Zi0wMjQyYWMxMjAwMDQiOnsicm9sZSI6Im1lbWJlciIsIndrcyI6eyI2NzIxMjhhMi04Y2FiLTExZWItYmJhNy0wMjQyYWMxMTAwMDMiOnsiYWRtIjpmYWxzZX0sIjM0ZGNkMGYyLThjYWMtMTFlYi05MTgzLTAyNDJhYzExMDAwMyI6eyJhZG0iOmZhbHNlfSwiYWU2ZTczZTgtNTA0ZS0xMWViLTlhOWMtMDI0MmFjMTIwMDA0Ijp7ImFkbSI6ZmFsc2V9LCJhYzZjODRlMC0xZGNjLTExZWItODJjOC0wMjQyYWMxMjAwMDQiOnsiYWRtIjpmYWxzZX0sImMzNWM1YjMwLTUwNGUtMTFlYi1hYmMwLTAyNDJhYzEyMDAwNCI6eyJhZG0iOmZhbHNlfSwiYjkyOWNiYTAtNTRiZi0xMWViLTk3NjUtMDI0MmFjMTIwMDA0Ijp7ImFkbSI6ZmFsc2V9LCJkNDZiN2QwMi01MDRlLTExZWItYjRhNC0wMjQyYWMxMjAwMDQiOnsiYWRtIjpmYWxzZX0sIjI4YzdkMGQwLThjYWUtMTFlYi05ZWUyLTAyNDJhYzExMDAwMyI6eyJhZG0iOmZhbHNlfSwiY2FjMTBlYTItNTA0ZS0xMWViLTgyZmQtMDI0MmFjMTIwMDA0Ijp7ImFkbSI6ZmFsc2V9fX0sImNjMDYzMmE0LTU0MDYtMTFlYi1iNmM1LTAyNDJhYzEyMDAwNCI6eyJyb2xlIjoib3JnYW5pemF0aW9uX2FkbWluaXN0cmF0b3IiLCJ3a3MiOnsiYjgyZTA3NjAtYjcyNi0xMWViLWE2ZjctMDI0MmFjMTEwMDAzIjp7ImFkbSI6dHJ1ZX19fSwiNTYzOTNhZjItZTVmZS0xMWU5LWI4OTQtMDI0MmFjMTIwMDA0Ijp7InJvbGUiOiJtZW1iZXIiLCJ3a3MiOnsiZjMzOWQ1NGEtZTgzMy0xMWVhLTkyYzMtMDI0MmFjMTIwMDA0Ijp7ImFkbSI6ZmFsc2V9LCI0MmI5OTdlOC1lMTViLTExZWEtYmYxZC0wMjQyYWMxMjAwMDQiOnsiYWRtIjpmYWxzZX19fX19.T01eEhXaaIEeEWCxtYspz-37SvGGCOuUVgV3HXoYeTo",
// "expiration": 1621348522,
// "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.uyJLeHAiAjE2MjQwMjMzMjIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNjIxMzQ0MzIyLCJuYmYiOjE2MjEzNDQzMjIsInN1YiI6IjUyNjhmYTgwLTE5ZDItMTFlYi1iNzc0LTAyNDJhYzEyMDAwNCJ1.9NiSWhe5r05tjWad10RKPJaoYV4VOkom31Gf9uAIdxI",
// "refresh_expiration": 1624023322