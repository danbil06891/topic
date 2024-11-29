// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactDetailAdapter extends TypeAdapter<ContactDetail> {
  @override
  final int typeId = 1;

  @override
  ContactDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactDetail(
      uid: fields[0] as String?,
      phone: fields[1] as String?,
      displayName: fields[2] as String?,
      email: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ContactDetail obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
