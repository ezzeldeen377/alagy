import 'package:alagy/features/admin/data/models/discount_code_model.dart';
import 'package:alagy/features/discount/data/repositories/discount_code_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'discount_code_state.dart';

@injectable
class DiscountCodeCubit extends Cubit<DiscountCodeState> {
  final DiscountCodeRepository _repository;

  DiscountCodeCubit(this._repository) : super(DiscountCodeInitial());

  Future<void> validateDiscountCode(String code, double orderAmount) async {
    if (code.trim().isEmpty) {
      emit(DiscountCodeError('Please enter a coupon code'));
      return;
    }

    emit(DiscountCodeLoading());

    final result = await _repository.validateDiscountCode(code);
    result.fold(
      (failure) => emit(DiscountCodeError(failure.toString())),
      (discountCode) {
        if (discountCode == null) {
          emit(DiscountCodeError('Invalid or expired coupon code'));
        } else {
          // Check minimum order amount
          if (discountCode.minimumOrderAmount != null && 
              orderAmount < discountCode.minimumOrderAmount!) {
            emit(DiscountCodeError(
              'Minimum order amount is EGP${discountCode.minimumOrderAmount!.toStringAsFixed(2)}'
            ));
            return;
          }

          // Calculate discount
          double discountAmount;
          if (discountCode.discountType == DiscountType.percentage) {
            discountAmount = orderAmount * (discountCode.discountValue / 100);
            // Apply maximum discount limit if set
            if (discountCode.maximumDiscountAmount != null && 
                discountAmount > discountCode.maximumDiscountAmount!) {
              discountAmount = discountCode.maximumDiscountAmount!;
            }
          } else {
            discountAmount = discountCode.discountValue;
          }

          // Ensure discount doesn't exceed order amount
          discountAmount = discountAmount > orderAmount ? orderAmount : discountAmount;

          emit(DiscountCodeApplied(
            discountCode: discountCode,
            discountAmount: discountAmount,
            finalPrice: orderAmount - discountAmount,
          ));
        }
      },
    );
  }

  Future<void> incrementUsage(String codeId) async {
    await _repository.incrementDiscountCodeUsage(codeId);
  }

  void removeDiscount() {
    emit(DiscountCodeInitial());
  }
}