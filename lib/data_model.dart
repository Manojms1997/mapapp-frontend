class DataModel {
  int? id;
  String? name;
  double? latitude;
  double? longitude;
  String? locationType;

  DataModel({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.locationType,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        locationType: json["locationType"],
      );
}