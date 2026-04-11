import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/features/wallet/data/models/wallet_transaction_model.dart';
import 'package:alagy/features/wallet/data/models/withdraw_request_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:alagy/core/l10n/app_localizations.dart';

class TransactionListItem extends StatelessWidget {
  final String title;
  final String date;
  final double amount;
  final bool isCredit; // true = added to wallet, false = deducted
  final IconData icon;
  final Color iconColor;
  final String? statusText;
  final Color? statusColor;

  const TransactionListItem({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.icon,
    required this.iconColor,
    this.statusText,
    this.statusColor,
  });

  factory TransactionListItem.fromWalletTransaction(
      WalletTransactionModel model) {
    bool isCredit = model.type == WalletTransactionType.refund;
    IconData icon;
    Color iconColor;

    switch (model.type) {
      case WalletTransactionType.refund:
        icon = Icons.refresh;
        iconColor = Colors.green;
        break;
      case WalletTransactionType.payment:
        icon = Icons.shopping_bag;
        iconColor = Colors.red;
        break;
      case WalletTransactionType.withdraw:
        icon = Icons.account_balance;
        iconColor = Colors.orange;
        break;
    }

    return TransactionListItem(
      title: model.description ?? model.type.name,
      date: DateFormat('MMM dd, yyyy - HH:mm').format(model.createdAt),
      amount: model.amount,
      isCredit: isCredit,
      icon: icon,
      iconColor: iconColor,
    );
  }

  factory TransactionListItem.fromWithdrawRequest(WithdrawRequestModel model) {
    String status = model.status.name;
    Color statusColor;

    switch (model.status) {
      case WithdrawStatus.pending:
        statusColor = Colors.orange;
        break;
      case WithdrawStatus.approved:
        statusColor = Colors.green;
        break;
      case WithdrawStatus.declined:
        statusColor = Colors.red;
        break;
    }

    return TransactionListItem(
      title: 'Withdraw to ${model.method.name}',
      date: DateFormat('MMM dd, yyyy - HH:mm').format(model.createdAt),
      amount: model.amount,
      isCredit: false, // withdraw deducts from wallet
      icon: Icons.account_balance,
      iconColor: Colors.blue,
      statusText: status,
      statusColor: statusColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title.trDescription(context),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(date,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            if (statusText != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusText!.toUpperCase(),
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]
          ],
        ),
        trailing: Text(
          '${isCredit ? '+' : '-'}${amount.toStringAsFixed(2)} ${tr.egp}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isCredit ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
