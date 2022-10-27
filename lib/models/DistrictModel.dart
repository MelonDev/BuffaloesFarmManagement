class DistrictModel {
  int? DISTRICT_ID;
  String? DISTRICT_CODE;
  String? DISTRICT_NAME;
  int? GEO_ID;
  int? PROVINCE_ID;

  DistrictModel.fromJson(Map<String, dynamic> json)
      : DISTRICT_ID = json['DISTRICT_ID'],
        DISTRICT_CODE = json['DISTRICT_CODE'],
        DISTRICT_NAME = json['DISTRICT_NAME'],
        GEO_ID = json['GEO_ID'],
        PROVINCE_ID = json['PROVINCE_ID'];
}
