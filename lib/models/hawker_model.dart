//------ to fetch hawker data 

class Hawker {
  String name;
  String phoneNumber;
  String area;

  Hawker({required this.name, required this.phoneNumber, required this.area});

  factory Hawker.fromMap(Map<String, dynamic> map) {
    return Hawker(
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      area: map['area'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'phoneNumber': phoneNumber, 'area': area};
  }
}
