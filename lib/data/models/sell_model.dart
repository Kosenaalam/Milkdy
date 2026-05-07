

class CustumerModel {
   CustumerModel({
    required this.id,
    required this.name,
    required this.phone,
  });
  final String id;
  final String name;
  final String phone;

  factory CustumerModel.fromMap(Map<String, dynamic> map) {
    return CustumerModel(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}
class AddCustomerModel {
  final String name;
  final String phone;

  AddCustomerModel({
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toMap(String userId) {
    return {
      'name': name,
      'phone': phone,
      'user_id': userId,
    };
  }
}

