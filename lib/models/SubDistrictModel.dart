class SubDistrictModel {
  int? SUB_DISTRICT_ID;
  String? SUB_DISTRICT_CODE;
  String? SUB_DISTRICT_NAME;
  int? DISTRICT_ID;
  int? PROVINCE_ID;
  int? GEO_ID;


  SubDistrictModel.fromJson(Map<String, dynamic> json)
      : SUB_DISTRICT_ID = json['SUB_DISTRICT_ID'],
        SUB_DISTRICT_CODE = json['SUB_DISTRICT_CODE'],
        SUB_DISTRICT_NAME = json['SUB_DISTRICT_NAME'],
        DISTRICT_ID = json['DISTRICT_ID'],
        PROVINCE_ID = json['PROVINCE_ID'],
        GEO_ID = json['GEO_ID']
  ;
}
