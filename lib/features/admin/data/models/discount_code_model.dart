class DiscountCodeModel {
  final String id;
  final String code;
  final String name;
  final double discountValue;
  final DiscountType discountType;
  final int quantity;
  final int usedCount;
  final DateTime createdAt;
  final DateTime? expiryDate;
  final bool isActive;
  final String createdBy;
  final double? minimumOrderAmount;
  final double? maximumDiscountAmount;

  const DiscountCodeModel({
    required this.id,
    required this.code,
    required this.name,
    required this.discountValue,
    required this.discountType,
    required this.quantity,
    this.usedCount = 0,
    required this.createdAt,
    this.expiryDate,
    this.isActive = true,
    required this.createdBy,
    this.minimumOrderAmount,
    this.maximumDiscountAmount,
  });

  factory DiscountCodeModel.fromMap(Map<String, dynamic> map) {
    return DiscountCodeModel(
      id: map['id'] ?? '',
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      discountValue: (map['discountValue'] ?? 0.0).toDouble(),
      discountType: DiscountType.values.firstWhere(
        (e) => e.name == map['discountType'],
        orElse: () => DiscountType.percentage,
      ),
      quantity: map['quantity'] ?? 0,
      usedCount: map['usedCount'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      expiryDate: map['expiryDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expiryDate'])
          : null,
      isActive: map['isActive'] ?? true,
      createdBy: map['createdBy'] ?? '',
      minimumOrderAmount: map['minimumOrderAmount']?.toDouble(),
      maximumDiscountAmount: map['maximumDiscountAmount']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'discountValue': discountValue,
      'discountType': discountType.name,
      'quantity': quantity,
      'usedCount': usedCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'expiryDate': expiryDate?.millisecondsSinceEpoch,
      'isActive': isActive,
      'createdBy': createdBy,
      'minimumOrderAmount': minimumOrderAmount,
      'maximumDiscountAmount': maximumDiscountAmount,
    };
  }

  DiscountCodeModel copyWith({
    String? id,
    String? code,
    String? name,
    double? discountValue,
    DiscountType? discountType,
    int? quantity,
    int? usedCount,
    DateTime? createdAt,
    DateTime? expiryDate,
    bool? isActive,
    String? createdBy,
    double? minimumOrderAmount,
    double? maximumDiscountAmount,
  }) {
    return DiscountCodeModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      discountValue: discountValue ?? this.discountValue,
      discountType: discountType ?? this.discountType,
      quantity: quantity ?? this.quantity,
      usedCount: usedCount ?? this.usedCount,
      createdAt: createdAt ?? this.createdAt,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      maximumDiscountAmount: maximumDiscountAmount ?? this.maximumDiscountAmount,
    );
  }

  bool get isExpired => expiryDate != null && DateTime.now().isAfter(expiryDate!);
  bool get isAvailable => isActive && !isExpired && usedCount < quantity;
  double get remainingQuantity => (quantity - usedCount).toDouble();
  double get usagePercentage => quantity > 0 ? (usedCount / quantity) * 100 : 0;
}

enum DiscountType {
  percentage,
  fixedAmount,
}