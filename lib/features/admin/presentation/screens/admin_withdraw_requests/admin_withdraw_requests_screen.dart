import 'package:alagy/core/common/enities/view_status.dart';
import 'package:alagy/core/l10n/app_localizations.dart';
import 'package:alagy/features/admin/presentation/cubit/admin_withdraw_requests/admin_withdraw_cubit.dart';
import 'package:alagy/features/admin/presentation/cubit/admin_withdraw_requests/admin_withdraw_state.dart';
import 'package:alagy/features/wallet/data/models/withdraw_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AdminWithdrawRequestsScreen extends StatefulWidget {
  const AdminWithdrawRequestsScreen({super.key});

  @override
  State<AdminWithdrawRequestsScreen> createState() =>
      _AdminWithdrawRequestsScreenState();
}

class _AdminWithdrawRequestsScreenState
    extends State<AdminWithdrawRequestsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminWithdrawCubit>().loadPendingRequests();
  }

  void _showReviewDialog(WithdrawRequestModel request, bool approve) {
    final tr = AppLocalizations.of(context)!;
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
            approve ? tr.approveWithdrawRequest : tr.declineWithdrawRequest),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${tr.amount}: ${request.amount.toStringAsFixed(2)} ${tr.egp}'),
            Text('${tr.user}: ${request.userName}'),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: tr.adminNoteOptional,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(tr.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AdminWithdrawCubit>().reviewRequest(
                    request.id,
                    approve,
                    noteController.text.isNotEmpty ? noteController.text : null,
                    request.userId,
                    request.amount,
                  );
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: approve ? Colors.green : Colors.red,
            ),
            child: Text(tr.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.withdrawRequestsAdmin),
      ),
      body: BlocConsumer<AdminWithdrawCubit, AdminWithdrawState>(
        listener: (context, state) {
          if (state.status == ViewStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          } else if (state.status == ViewStatus.success &&
              state.requests.isEmpty) {
            // Optional: Show message or let Empty state handle it
          }
        },
        builder: (context, state) {
          if (state.status == ViewStatus.loading && state.requests.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.requests.isEmpty) {
            return Center(child: Text(tr.noPendingWithdrawRequests));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.requests.length,
            itemBuilder: (context, index) {
              final request = state.requests[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${request.amount.toStringAsFixed(2)} ${tr.egp}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            DateFormat('MMM dd, yyyy')
                                .format(request.createdAt),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${tr.user}: ${request.userName}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('${tr.method}: ${request.method.name}'),

                      // Show method-specific details
                      if (request.method == WithdrawMethod.bankAccount) ...[
                        Text('${tr.bankName}: ${request.bankName}'),
                        Text(
                            '${tr.accountHolderName}: ${request.accountHolderName}'),
                        Text('${tr.accountNumber}: ${request.accountNumber}'),
                      ] else if (request.method == WithdrawMethod.instaPay) ...[
                        Text(
                            '${tr.instaPayHandle}: ${request.instaPayAccount}'),
                      ] else if (request.method ==
                          WithdrawMethod.mobileWallet) ...[
                        Text(
                            '${tr.walletProvider}: ${request.mobileWalletProvider}'),
                        Text(
                            '${tr.walletNumber}: ${request.mobileWalletNumber}'),
                      ],

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _showReviewDialog(request, false),
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: Text(tr.decline,
                                style: const TextStyle(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () => _showReviewDialog(request, true),
                            icon: const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              tr.approve,
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
