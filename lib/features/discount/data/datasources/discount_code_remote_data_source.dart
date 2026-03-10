import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/core/utils/try_and_catch.dart';
import 'package:alagy/features/admin/data/models/discount_code_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract class DiscountCodeRemoteDataSource {
  Future<DiscountCodeModel?> validateDiscountCode(String code);
  Future<void> incrementDiscountCodeUsage(String codeId);
}

@Injectable(as: DiscountCodeRemoteDataSource)
class DiscountCodeRemoteDataSourceImpl implements DiscountCodeRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _discountCodesCollection =>
      _firestore.collection(FirebaseCollections.discountCodesCollection);

  @override
  Future<DiscountCodeModel?> validateDiscountCode(String code) {
    return executeTryAndCatchForDataLayer(() async {
      final querySnapshot = await _discountCodesCollection
          .where('code', isEqualTo: code.toUpperCase())
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final discountCode = DiscountCodeModel.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);
      
      // Check if code is still available
      if (!discountCode.isAvailable) {
        return null;
      }

      return discountCode;
    });
  }

  @override
  Future<void> incrementDiscountCodeUsage(String codeId) {
    return executeTryAndCatchForDataLayer(() async {
      await _discountCodesCollection.doc(codeId).update({
        'usedCount': FieldValue.increment(1),
      });
    });
  }
}