import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/constants/firebase_collections.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/utils/show_snack_bar.dart';
import 'package:alagy/features/admin/data/models/discount_code_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

class DiscountCodeManagementScreen extends StatefulWidget {
  const DiscountCodeManagementScreen({super.key});

  @override
  State<DiscountCodeManagementScreen> createState() =>
      _DiscountCodeManagementScreenState();
}

class _DiscountCodeManagementScreenState
    extends State<DiscountCodeManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DiscountCodeModel> _discountCodes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDiscountCodes();
  }

  Future<void> _loadDiscountCodes() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await _firestore
          .collection(FirebaseCollections.discountCodesCollection)
          .orderBy('createdAt', descending: true)
          .get();

      _discountCodes = snapshot.docs
          .map((doc) => DiscountCodeModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      if (mounted) {
        showSnackBar(context, context.l10n.errorLoadingDiscount,
            backgroundColor: Colors.red);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<DiscountCodeModel> get _filteredCodes {
    if (_searchQuery.isEmpty) return _discountCodes;
    return _discountCodes.where((code) {
      return code.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          code.code.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.discountCodeManagement,
          style: context.theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.whiteColor),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16.w),
            color: AppColor.primaryColor.withOpacity(0.1),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: context.l10n.searchDiscountCodes,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
           
              ),
            ),
          ),

          // Statistics Cards
          Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context.l10n.totalCodes,
                    _discountCodes.length.toString(),
                    Icons.local_offer,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCard(
                    context.l10n.activeCodes,
                    _discountCodes
                        .where((c) => c.isAvailable)
                        .length
                        .toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCard(
                    context.l10n.expired,
                    _discountCodes.where((c) => c.isExpired).length.toString(),
                    Icons.access_time,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Discount Codes List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCodes.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadDiscountCodes,
                        child: ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: _filteredCodes.length,
                          itemBuilder: (context, index) {
                            final code = _filteredCodes[index];
                            return _buildDiscountCodeCard(code);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDiscountCodeDialog(),
        backgroundColor: AppColor.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          context.l10n.createCode,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: context.theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: context.theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountCodeCard(DiscountCodeModel code) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        code.name,
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          code.code,
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: code.isAvailable ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        code.isAvailable
                            ? context.l10n.active
                        : code.isExpired
                            ? context.l10n.expired
                            : context.l10n.inactive,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      code.discountType == DiscountType.percentage
                          ? '${code.discountValue.toInt()}% ${context.l10n.off}'
                          : 'EGP${code.discountValue.toStringAsFixed(2)} ${context.l10n.off}',
                      style: context.theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context.l10n.used,
                    '${code.usedCount}/${code.quantity}',
                    Icons.people,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    context.l10n.created,
                    _formatDate(code.createdAt),
                    Icons.calendar_today,
                  ),
                ),
                if (code.expiryDate != null)
                  Expanded(
                    child: _buildInfoItem(
                      context.l10n.expires,
                      _formatDate(code.expiryDate!),
                      Icons.access_time,
                    ),
                  ),
              ],
            ),
            if (code.quantity > 0) ...[
              SizedBox(height: 8.h),
              LinearProgressIndicator(
                value: code.usedCount / code.quantity,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  code.usagePercentage > 80 ? Colors.red : Colors.green,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${code.usagePercentage.toStringAsFixed(1)}% used',
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _copyToClipboard(code.code),
                  icon: const Icon(Icons.copy, size: 16),
                  label: Text(context.l10n.copy),
                ),
                TextButton.icon(
                  onPressed: () => _toggleCodeStatus(code),
                  icon: Icon(
                    code.isActive ? Icons.pause : Icons.play_arrow,
                    size: 16,
                  ),
                  label: Text(code.isActive ? context.l10n.deactivate : context.l10n.activate),
                ),
                TextButton.icon(
                  onPressed: () => _deleteCode(code),
                  icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                  label:
                      Text(context.l10n.delete, style: const TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey[600]),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            context.l10n.noDiscountCodesFound,
            style: context.theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            context.l10n.createYourFirstDiscountCode,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateDiscountCodeDialog() {
    showDialog(
      context: context,
      builder: (context) => _CreateDiscountCodeDialog(
        onCodeCreated: _loadDiscountCodes,
      ),
    );
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    showSnackBar(context, 'Code "$code" copied to clipboard');
  }

  Future<void> _toggleCodeStatus(DiscountCodeModel code) async {
    try {
      await _firestore
          .collection(FirebaseCollections.discountCodesCollection)
          .doc(code.id)
          .update({'isActive': !code.isActive});

      _loadDiscountCodes();

      if (mounted) {
        showSnackBar(context,
            context.l10n.codeCodeIsactiveDeactivatedActivatedSuccessfully);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, context.l10n.errorUpdatingCode,
            backgroundColor: Colors.red);
      }
    }
  }

  Future<void> _deleteCode(DiscountCodeModel code) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteDiscountCode),
        content: Text('Are you sure you want to delete "${code.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _firestore
            .collection(FirebaseCollections.discountCodesCollection)
            .doc(code.id)
            .delete();

        _loadDiscountCodes();

        if (mounted) {
          showSnackBar(context, context.l10n.codeDeletedSuccessfully);
        }
      } catch (e) {
        if (mounted) {
          showSnackBar(context, context.l10n.errorDeletingCode,
              backgroundColor: Colors.red);
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _CreateDiscountCodeDialog extends StatefulWidget {
  final VoidCallback onCodeCreated;

  const _CreateDiscountCodeDialog({required this.onCodeCreated});

  @override
  State<_CreateDiscountCodeDialog> createState() =>
      _CreateDiscountCodeDialogState();
}

class _CreateDiscountCodeDialogState extends State<_CreateDiscountCodeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _discountValueController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minimumOrderController = TextEditingController();
  final _maximumDiscountController = TextEditingController();

  DiscountType _discountType = DiscountType.percentage;
  DateTime? _expiryDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _discountValueController.dispose();
    _quantityController.dispose();
    _minimumOrderController.dispose();
    _maximumDiscountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 500.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_offer,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12.w),
                   Expanded(
                    child: Text(
                      context.l10n.createDiscountCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration:  InputDecoration(
                          labelText: context.l10n.discountName,
                          hintText: context.l10n.discountNameHint,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return context.l10n.pleaseEnterDiscountName;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Code Field
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _codeController,
                              decoration: InputDecoration(
                                labelText: context.l10n.discountCode,
                                hintText: context.l10n.discountCodeHint,
                                border: OutlineInputBorder(),
                              ),
                              textCapitalization: TextCapitalization.characters,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return context.l10n.pleaseEnterDiscountCode;
                                }
                                if (value!.length < 3) {
                                  return context.l10n.codeMinimumLength;
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          ElevatedButton(
                            onPressed: _generateRandomCode,
                            child: Text(context.l10n.generate),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Discount Type
                      Text(
                        context.l10n.discountType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<DiscountType>(
                              title: Text(context.l10n.percentage),
                              value: DiscountType.percentage,
                              groupValue: _discountType,
                              onChanged: (value) {
                                setState(() => _discountType = value!);
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<DiscountType>(
                              title: Text(context.l10n.fixedAmount),
                              value: DiscountType.fixedAmount,
                              groupValue: _discountType,
                              onChanged: (value) {
                                setState(() => _discountType = value!);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Discount Value
                      TextFormField(
                        controller: _discountValueController,
                        decoration: InputDecoration(
                          labelText: _discountType == DiscountType.percentage
                              ? context.l10n.discountPercentage
                              : context.l10n.discountAmount,
                          hintText: _discountType == DiscountType.percentage
                              ? context.l10n.discountPercentageHint
                              : context.l10n.discountAmountHint,
                          border: const OutlineInputBorder(),
                          suffixText: _discountType == DiscountType.percentage
                              ? '%'
                              : 'EGP',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return context.l10n.pleaseEnterDiscountValue;
                          }
                          final numValue = double.tryParse(value!);
                          if (numValue == null || numValue <= 0) {
                            return context.l10n.pleaseEnterValidPositiveNumber;
                          }
                          if (_discountType == DiscountType.percentage &&
                              numValue > 100) {
                            return context.l10n.percentageCannotExceed100;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Quantity
                      TextFormField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          labelText: context.l10n.usageLimit,
                          hintText: context.l10n.usageLimitHint,
                          border: OutlineInputBorder(),
                          helperText: context.l10n.usageLimitHelper,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return context.l10n.pleaseEnterUsageLimit;
                          }
                          final numValue = int.tryParse(value!);
                          if (numValue == null || numValue <= 0) {
                            return context.l10n.pleaseEnterValidPositiveNumber;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Expiry Date
                      InkWell(
                        onTap: _selectExpiryDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: context.l10n.expiryDateOptional,
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _expiryDate != null
                                ? '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'
                                : context.l10n.noExpiryDate,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Advanced Options
                      ExpansionTile(
                        title: Text(context.l10n.advancedOptions),
                        children: [
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: _minimumOrderController,
                            decoration: InputDecoration(
                              labelText: context.l10n.minimumOrderAmountOptional,
                              hintText: context.l10n.minimumOrderAmountHint,
                              border: OutlineInputBorder(),
                              suffixText: 'EGP',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isNotEmpty ?? false) {
                                final numValue = double.tryParse(value!);
                                if (numValue == null || numValue <= 0) {
                                  return context.l10n.pleaseEnterValidPositiveNumber;
                                }
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          if (_discountType == DiscountType.percentage)
                            TextFormField(
                              controller: _maximumDiscountController,
                              decoration: InputDecoration(
                                labelText: context.l10n.maximumDiscountAmountOptional,
                                hintText: context.l10n.maximumDiscountAmountHint,
                                border: OutlineInputBorder(),
                                suffixText: 'EGP',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isNotEmpty ?? false) {
                                  final numValue = double.tryParse(value!);
                                  if (numValue == null || numValue <= 0) {
                                    return context.l10n.pleaseEnterValidPositiveNumber;
                                  }
                                }
                                return null;
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Actions
            Container(
              padding: EdgeInsets.all(20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: Text(context.l10n.cancel),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _createDiscountCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(context.l10n.createCode),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final code = String.fromCharCodes(
      Iterable.generate(
        8,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
    _codeController.text = code;
  }

  Future<void> _selectExpiryDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _expiryDate = date);
    }
  }

  Future<void> _createDiscountCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = context.read<AppUserCubit>().state.user;
      if (user == null) {
        throw Exception(context.l10n.userNotAuthenticated);
      }

      // Check if code already exists
      final existingCode = await FirebaseFirestore.instance
          .collection(FirebaseCollections.discountCodesCollection)
          .where('code', isEqualTo: _codeController.text.toUpperCase())
          .get();

      if (existingCode.docs.isNotEmpty) {
        throw Exception(context.l10n.discountCodeAlreadyExists);
      }

      final discountCode = DiscountCodeModel(
        id: FirebaseFirestore.instance
            .collection(FirebaseCollections.discountCodesCollection)
            .doc()
            .id,
        code: _codeController.text.toUpperCase(),
        name: _nameController.text,
        discountValue: double.parse(_discountValueController.text),
        discountType: _discountType,
        quantity: int.parse(_quantityController.text),
        createdAt: DateTime.now(),
        expiryDate: _expiryDate,
        createdBy: user.uid,
        minimumOrderAmount: _minimumOrderController.text.isNotEmpty
            ? double.parse(_minimumOrderController.text)
            : null,
        maximumDiscountAmount: _maximumDiscountController.text.isNotEmpty
            ? double.parse(_maximumDiscountController.text)
            : null,
      );

      await FirebaseFirestore.instance
          .collection(FirebaseCollections.discountCodesCollection)
          .doc(discountCode.id)
          .set(discountCode.toMap());

      widget.onCodeCreated();

      if (mounted) {
        Navigator.pop(context);
        showSnackBar(context, context.l10n.discountCodeCreatedSuccessfully);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, context.l10n.errorCreatingDiscountCode,
            backgroundColor: Colors.red);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
