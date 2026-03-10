class PaymentType {
  final String paymentIcon;
  final bool isSelected;
  final String paymentName;
  const PaymentType({
    required this.paymentIcon,
    required this.isSelected,
    required this.paymentName,
  });

  PaymentType copyWith({
    String? paymentIcon,
    bool? isSelected,
    String? paymentName,
  }) {
    return PaymentType(
      paymentIcon: paymentIcon ?? this.paymentIcon,
      isSelected: isSelected ?? this.isSelected,
      paymentName: paymentName ?? this.paymentName,
    );
  }
}
