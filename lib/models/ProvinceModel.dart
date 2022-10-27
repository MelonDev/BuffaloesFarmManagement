class ProvinceModel {
  int? PROVINCE_ID;
  String? PROVINCE_CODE;
  String? PROVINCE_NAME;
  int? GEO_ID;

  ProvinceModel(
      this.PROVINCE_ID, this.PROVINCE_CODE, this.PROVINCE_NAME, this.GEO_ID);

  ProvinceModel.fromJson(Map<String, dynamic> json)
      : PROVINCE_ID = json['PROVINCE_ID'],
        PROVINCE_CODE = json['PROVINCE_CODE'],
        PROVINCE_NAME = json['PROVINCE_NAME'],
        GEO_ID = json['GEO_ID'];
}
