class Location {
  final int id;
  final String building;
  final String section;
  final int floor;

  Location({
    required this.id,
    required this.building,
    required this.section,
    required this.floor,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      building: json['building'],
      section: json['section'],
      floor: json['floor'],
    );
  }
}
