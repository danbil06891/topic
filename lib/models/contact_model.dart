import 'package:hive/hive.dart';

part 'contact_model.g.dart';

@HiveType(typeId: 1)
class ContactDetail extends HiveObject {
  @HiveField(0)
  String? uid;

  @HiveField(1)
  String? phone;

  @HiveField(2)
  String? displayName;

  @HiveField(3)
  String? email;

  ContactDetail({this.uid, this.phone, this.displayName, this.email});
}
