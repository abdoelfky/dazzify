// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tokens_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TokensModelAdapter extends TypeAdapter<TokensModel> {
  @override
  final int typeId = 1;

  @override
  TokensModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TokensModel(
      accessToken: fields[1] as String,
      refreshToken: fields[2] as String?,
      accessTokenExpireTime: fields[3] as DateTime,
      refreshTokenExpireTime: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TokensModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.accessToken)
      ..writeByte(2)
      ..write(obj.refreshToken)
      ..writeByte(3)
      ..write(obj.accessTokenExpireTime)
      ..writeByte(4)
      ..write(obj.refreshTokenExpireTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokensModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokensModel _$TokensModelFromJson(Map<String, dynamic> json) => TokensModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      accessTokenExpireTime:
          TokensModel._fromJsonDateTime(json['accessTokenExpireTime'] as String),
      refreshTokenExpireTime: 
          TokensModel._fromJsonDateTimeNullable(json['refreshTokenExpireTime'] as String?),
    );
