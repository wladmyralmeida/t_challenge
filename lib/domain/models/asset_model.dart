class AssetModel {
  final String id;
  final String name;
  final String? locationId;
  final String? parentId;
  final String? sensorId;
  final String? sensorType;
  final String? status;
  final String? gatewayId;

  bool get isComponent => sensorType != null;
  bool get isTopLevel => parentId == null && locationId == null && !isComponent;

  AssetModel({
    required this.id,
    required this.name,
    this.locationId,
    this.parentId,
    this.sensorId,
    this.sensorType,
    this.status,
    this.gatewayId,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'],
      name: json['name'],
      locationId: json['locationId'],
      parentId: json['parentId'],
      sensorId: json['sensorId'],
      sensorType: json['sensorType'],
      status: json['status'],
      gatewayId: json['gatewayId'],
    );
  }
}
