import 'sql.dart';

class Contacts {
  int? id;
  late String contactName;
  late String contactNumber;
  late String imageURL;

  Contacts({
    this.id,
    required this.contactName,
    required this.contactNumber,
    required this.imageURL,
  });

  Contacts.fromMap(Map<String, dynamic> map) {
    if (map[columnId] != null) id = map[columnId];
    contactName = map[columnName];
    contactNumber = map[columnNumber];
    imageURL = map[columnURL];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (id != null) map[columnId] = id;
    map[columnName] = contactName;
    map[columnNumber] = contactNumber;
    map[columnURL] = imageURL;

    return map;
  }
}