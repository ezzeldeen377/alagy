import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/enities/view_status.dart';
import 'package:alagy/features/wallet/data/models/withdraw_request_model.dart';
import 'package:alagy/features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:alagy/features/wallet/presentation/cubit/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alagy/core/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class WithdrawRequestScreen extends StatefulWidget {
  const WithdrawRequestScreen({super.key});

  @override
  State<WithdrawRequestScreen> createState() => _WithdrawRequestScreenState();
}

class _WithdrawRequestScreenState extends State<WithdrawRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  // Bank fields
  final _bankNameController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();

  // InstaPay fields
  final _instaPayHandleController = TextEditingController();

  // Mobile Wallet fields
  final _mobileWalletNumberController = TextEditingController();
  String _selectedMobileProvider = 'Vodafone'; // Default

  WithdrawMethod _selectedMethod = WithdrawMethod.bankAccount;

  @override
  void dispose() {
    _amountController.dispose();
    _bankNameController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _instaPayHandleController.dispose();
    _mobileWalletNumberController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      final user = context.read<AppUserCubit>().state.user;
      final balance = user?.walletBalance ?? 0.0;
      final amount = double.tryParse(_amountController.text) ?? 0.0;

      if (amount <= 0 || amount > balance) {
        final tr = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr.insufficientBalance)),
        );
        return;
      }

      final transactionId = const Uuid().v4();
      final request = WithdrawRequestModel(
        id: const Uuid().v4(),
        userId: user!.uid,
        userName: user.name,
        amount: amount,
        method: _selectedMethod,
        status: WithdrawStatus.pending,
        transactionId: transactionId,
        bankName: _selectedMethod == WithdrawMethod.bankAccount
            ? _bankNameController.text
            : null,
        accountHolderName: _selectedMethod == WithdrawMethod.bankAccount
            ? _accountNameController.text
            : null,
        accountNumber: _selectedMethod == WithdrawMethod.bankAccount
            ? _accountNumberController.text
            : null,
        instaPayAccount: _selectedMethod == WithdrawMethod.instaPay
            ? _instaPayHandleController.text
            : null,
        mobileWalletNumber: _selectedMethod == WithdrawMethod.mobileWallet
            ? _mobileWalletNumberController.text
            : null,
        mobileWalletProvider: _selectedMethod == WithdrawMethod.mobileWallet
            ? _selectedMobileProvider
            : null,
        createdAt: DateTime.now(),
      );

      context.read<WalletCubit>().requestWithdraw(request, balance);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final user = context.watch<AppUserCubit>().state.user;
    final balance = user?.walletBalance ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.withdrawRequest),
      ),
      body: BlocConsumer<WalletCubit, WalletState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ViewStatus.success) {
            // Update user balance locally in AppUserCubit to reflect deduction
            if (user != null && state.withdrawnAmount != null) {
              final updatedUser = user.copyWith(
                  walletBalance: user.walletBalance - state.withdrawnAmount!);
              context.read<AppUserCubit>().updateUser(
                  updatedUser, {'walletBalance': updatedUser.walletBalance});
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(tr.withdrawSuccess)),
            );
            Navigator.pop(context);
          } else if (state.status == ViewStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Available Balance Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          tr.availableBalance,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${balance.toStringAsFixed(2)} ${tr.egp}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Amount Input
                  TextFormField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: tr.amountToWithdraw,
                      prefixIcon: const Icon(Icons.attach_money),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr.pleaseEnterAmount;
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return tr.invalidAmount;
                      }
                      if (amount > balance) {
                        return tr.insufficientBalance;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Method Selection
                  Text(
                    tr.selectWithdrawMethod,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<WithdrawMethod>(
                          title: Text(tr.bankAccount),
                          value: WithdrawMethod.bankAccount,
                          groupValue: _selectedMethod,
                          onChanged: (value) =>
                              setState(() => _selectedMethod = value!),
                        ),
                        const Divider(height: 1),
                        RadioListTile<WithdrawMethod>(
                          title: Text(tr.instaPay),
                          value: WithdrawMethod.instaPay,
                          groupValue: _selectedMethod,
                          onChanged: (value) =>
                              setState(() => _selectedMethod = value!),
                        ),
                        const Divider(height: 1),
                        RadioListTile<WithdrawMethod>(
                          title: Text(tr.mobileWallet),
                          value: WithdrawMethod.mobileWallet,
                          groupValue: _selectedMethod,
                          onChanged: (value) =>
                              setState(() => _selectedMethod = value!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Dynamic Form Fields based on Method
                  if (_selectedMethod == WithdrawMethod.bankAccount) ...[
                    TextFormField(
                      controller: _bankNameController,
                      decoration: InputDecoration(
                        labelText: tr.bankName,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? tr.requiredField : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _accountNameController,
                      decoration: InputDecoration(
                        labelText: tr.accountHolderName,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? tr.requiredField : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _accountNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: tr.accountNumber,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? tr.requiredField : null,
                    ),
                  ] else if (_selectedMethod == WithdrawMethod.instaPay) ...[
                    TextFormField(
                      controller: _instaPayHandleController,
                      decoration: InputDecoration(
                        labelText: tr.instaPayHandle,
                        prefixText: '@',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? tr.requiredField : null,
                    ),
                  ] else if (_selectedMethod ==
                      WithdrawMethod.mobileWallet) ...[
                    DropdownButtonFormField<String>(
                      value: _selectedMobileProvider,
                      decoration: InputDecoration(
                        labelText: tr.walletProvider,
                        border: const OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'Vodafone', child: Text('Vodafone Cash')),
                        DropdownMenuItem(
                            value: 'Orange', child: Text('Orange Cash')),
                        DropdownMenuItem(
                            value: 'Etisalat', child: Text('Etisalat Cash')),
                        DropdownMenuItem(value: 'WE', child: Text('WE Pay')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedMobileProvider = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mobileWalletNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: tr.walletNumber,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? tr.requiredField : null,
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.status == ViewStatus.loading
                          ? null
                          : _submitRequest,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state.status == ViewStatus.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              tr.submitRequest,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
