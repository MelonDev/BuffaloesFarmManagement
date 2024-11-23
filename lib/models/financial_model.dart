class FinancialModel {
  String? id;
  String? name;
  String? farmId;
  String? price;
  String? date;
  String? weight;
  String? type;

  FinancialModel.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString(),
        name = json['name']?.toString(),
        farmId = json['farm_id']?.toString(),
        price = json['price']?.toString(),
        date = json['date']?.toString(),
        type = json['type']?.toString(),
        weight = json['weight']?.toString();
}
