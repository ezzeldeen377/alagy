part of 'discount_code_cubit.dart';

abstract class DiscountCodeState {}

class DiscountCodeInitial extends DiscountCodeState {}

class DiscountCodeLoading extends DiscountCodeState {}

class DiscountCodeApplied extends DiscountCodeState {
  final DiscountCodeModel discountCode;
  final double discountAmount;
  final double finalPrice;

  DiscountCodeApplied({
    required this.discountCode,
    required this.discountAmount,
    required this.finalPrice,
  });
}

class DiscountCodeError extends DiscountCodeState {
  final String message;

  DiscountCodeError(this.message);
}