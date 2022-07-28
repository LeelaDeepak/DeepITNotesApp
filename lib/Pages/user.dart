import 'package:cloud_firestore/cloud_firestore.dart';

class Username {
  String id;
  late final String Name;
  late final String Phone_Number;
  late final String Roll_Number;
  late final String Section;
  late final String avatar;

  Username({
    this.id = '',
    required this.Name,
    required this.Phone_Number,
    required this.Roll_Number,
    required this.Section,
    required this.avatar,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'Name': Name,
        'Phone_Number': Phone_Number,
        'Roll_Number': Roll_Number,
        'Section': Section,
        'avatar': avatar,
      };

  static Username fromJson(Map<String, dynamic> json) => Username(
      Name: json['Name'],
      Phone_Number: json['Phone_Number'],
      Roll_Number: json['Roll_Number'],
      Section: json['Section'],
      avatar: json['avatar']);
}
