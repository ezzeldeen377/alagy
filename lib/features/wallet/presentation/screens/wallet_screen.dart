import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/enities/view_status.dart';
import 'package:alagy/features/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:alagy/features/wallet/presentation/cubit/wallet_state.dart';
import 'package:alagy/features/wallet/presentation/widgets/transaction_list_item.dart';
import 'package:alagy/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alagy/core/l10n/app_localizations.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/core/theme/app_color.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AppUserCubit>().state.user;
    if (user != null) {
      context.read<WalletCubit>().loadWallet(user.uid, user.walletBalance);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.wallet,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state.status == ViewStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }

          if (state.status == ViewStatus.success) {
            final user = context.read<AppUserCubit>().state.user;
            if (user != null) {
              if (state.withdrawnAmount != null && state.withdrawnAmount! > 0) {
                final updatedUser = user.copyWith(
                    walletBalance: user.walletBalance - state.withdrawnAmount!);
                context.read<AppUserCubit>().updateUser(
                    updatedUser, {'walletBalance': updatedUser.walletBalance});
              }
              if (state.refundedAmount != null && state.refundedAmount! > 0) {
                final updatedUser = user.copyWith(
                    walletBalance: user.walletBalance + state.refundedAmount!);
                context.read<AppUserCubit>().updateUser(
                    updatedUser, {'walletBalance': updatedUser.walletBalance});
              }
            }
          }
        },
        builder: (context, state) {
          final user = context.watch<AppUserCubit>().state.user;
          final balance = user?.walletBalance ?? 0.0;

          if (state.status == ViewStatus.loading &&
              state.transactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (user != null) {
                await context.read<AppUserCubit>().getUser(uid: user.uid);
                final updatedUser = context.read<AppUserCubit>().state.user;
                if (updatedUser != null && mounted) {
                  context
                      .read<WalletCubit>()
                      .loadWallet(updatedUser.uid, updatedUser.walletBalance);
                }
              }
            },
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                WalletBalanceCard(balance: balance),
                const SizedBox(height: 24),

                // Transactions Header
                Text(
                  tr.transactions,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                if (state.transactions.isEmpty &&
                    state.status != ViewStatus.loading)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        tr.noTransactionsFound,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  ),

                // Then show regular transactions (refunds/payments)
                ...state.transactions.map((transaction) =>
                    TransactionListItem.fromWalletTransaction(transaction)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, RouteNames.withdrawRequest);
          if (mounted) {
            final appUserCubit = context.read<AppUserCubit>();
            final user = appUserCubit.state.user;
            if (user != null) {
              await appUserCubit.getUser(uid: user.uid);
              final updatedUser = appUserCubit.state.user;
              if (updatedUser != null && mounted) {
                context
                    .read<WalletCubit>()
                    .loadWallet(updatedUser.uid, updatedUser.walletBalance);
              }
            }
          }
        },
        backgroundColor: AppColor.primaryColor,
        icon: const Icon(Icons.account_balance_wallet_outlined,
            color: Colors.white),
        label: Text(
          tr.withdrawRequest,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
