import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../../../../core/helpers/extensions.dart';
import '../cubit/legal_cubit.dart';
import '../cubit/legal_state.dart';
import 'widgets/legal_content_widget.dart';
import 'widgets/legal_error_widget.dart';

enum LegalType { termsOfUse, privacyPolicy, refundPolicy }

class LegalScreen extends StatelessWidget {
  final LegalType type;

  const LegalScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return BlocProvider(
      create: (context) {
        final cubit = getIt<LegalCubit>();
        if (type == LegalType.termsOfUse) {
          cubit.loadTermsOfUse(lang);
        } else if (type == LegalType.privacyPolicy) {
          cubit.loadPrivacyPolicy(lang);
        } else {
          cubit.loadRefundPolicy(lang);
        }
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            type == LegalType.termsOfUse
                ? context.l10n.signUpTermsLink
                : type == LegalType.privacyPolicy
                    ? context.l10n.privacyPolicy
                    : context.l10n.refundPolicy,
          ),
        ),
        body: BlocBuilder<LegalCubit, LegalState>(
          builder: (context, state) {
            switch (state.status) {
              case ViewStatus.initial:
              case ViewStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case ViewStatus.success:
                if (state.content == null) {
                  return const Center(child: Text('No Content'));
                }
                return LegalContentWidget(
                  title: state.content!.title,
                  content: state.content!.content,
                );
              case ViewStatus.failure:
                return LegalErrorWidget(
                  message: state.errorMessage ?? context.l10n.generalError,
                  onRetry: () {
                    final lang = Localizations.localeOf(context).languageCode;
                    if (type == LegalType.termsOfUse) {
                      context.read<LegalCubit>().loadTermsOfUse(lang);
                    } else if (type == LegalType.privacyPolicy) {
                      context.read<LegalCubit>().loadPrivacyPolicy(lang);
                    } else {
                      context.read<LegalCubit>().loadRefundPolicy(lang);
                    }
                  },
                );
              case ViewStatus.empty:
                return const Center(child: Text('Empty'));
            }
          },
        ),
      ),
    );
  }
}
