class Delivery {
  final String customerId;
  final String customerName;
  final String phoneNumber;
  final String address;
  final String cylinderType1;
  final String cylinderType2;
  final String cylinderType3;
  final String drpQuantity;
  final String hosepipeQuantity;
  final String hotplateQuantity;
  final String amount;
  final String amountPaid;
  final String paymentMode;
  final String hawkerName;
  final String returnType1;
  final String returnType2;
  final String returnType3;

  Delivery({
    required this.customerId,
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.cylinderType1,
    required this.cylinderType2,
    required this.cylinderType3,
    required this.drpQuantity,
    required this.hosepipeQuantity,
    required this.hotplateQuantity,
    required this.amount,
    required this.amountPaid,
    required this.paymentMode,
    required this.hawkerName,
    required this.returnType1,
    required this.returnType2,
    required this.returnType3,
  });

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      cylinderType1: map['cylinderType1'] ?? '',
      cylinderType2: map['cylinderType2'] ?? '',
      cylinderType3: map['cylinderType3'] ?? '',
      drpQuantity: map['drpQuantity'] ?? '',
      hosepipeQuantity: map['hosepipeQuantity'] ?? '',
      hotplateQuantity: map['hotplateQuantity'] ?? '',
      amount: map['amount'] ?? '',
      amountPaid: map['amountPaid'] ?? '',
      paymentMode: map['paymentMode'] ?? '',
      hawkerName: map['hawkerName'] ?? '',
      returnType1: map['returnType1'] ?? '',
      returnType2: map['returnType2'] ?? '',
      returnType3: map['returnType3'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'address': address,
      'cylinderType1': cylinderType1,
      'cylinderType2': cylinderType2,
      'cylinderType3': cylinderType3,
      'drpQuantity': drpQuantity,
      'hosepipeQuantity': hosepipeQuantity,
      'hotplateQuantity': hotplateQuantity,
      'amount': amount,
      'amountPaid': amountPaid,
      'paymentMode': paymentMode,
      'hawkerName': hawkerName,
      'returnType1': returnType1,
      'returnType2': returnType2,
      'returnType3': returnType3,
    };
  }
}
