// ------fetching distribution center data
class DistributionCenter {
  String name;

  DistributionCenter({required this.name});

  factory DistributionCenter.fromMap(Map<String, dynamic> map) {
    return DistributionCenter(name: map['name'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'name': name};
  }
}
