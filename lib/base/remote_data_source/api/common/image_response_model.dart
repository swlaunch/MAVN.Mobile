class ImageResponseModel {
  ImageResponseModel.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        name = json['Name'],
        type = json['Type'],
        blobUrl = json['BlobUrl'];

  final String id;
  final String name;
  final String type;
  final String blobUrl;
}
