class PaymentType {
  final String paymentIcon;
  final bool isSelected;
  final String paymentName;
  final String key;
  const PaymentType({
    required this.paymentIcon,
    required this.isSelected,
    required this.paymentName,
    required this.key,
  });

  PaymentType copyWith({
    String? paymentIcon,
    bool? isSelected,
    String? paymentName,
    String? key,
  }) {
    return PaymentType(
      paymentIcon: paymentIcon ?? this.paymentIcon,
      isSelected: isSelected ?? this.isSelected,
      paymentName: paymentName ?? this.paymentName,
      key: key ?? this.key,
    );
  }
}
