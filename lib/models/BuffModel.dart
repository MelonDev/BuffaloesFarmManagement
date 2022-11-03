class BuffModel {
  String? id;
  String? name;
  String? tag;
  String? gender;
  String? birth_date;
  String? father_id;
  String? father_name;
  String? mother_id;
  String? mother_name;

  String? source;
  String? image_url;
  String? status;

  BuffModel();

  BuffModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        tag = json['tag']?.toString(),
        gender = json['gender']?.toString(),
        birth_date = json['birth_date']?.toString(),
        father_id = json['father_id']?.toString(),
        father_name = json['father_name']?.toString(),
        mother_id = json['mother_id']?.toString(),
        mother_name = json['mother_name']?.toString(),
        source = json['source']?.toString(),
        status = json['source']?.toString(),
        image_url = json['image_url']?.toString();
}
