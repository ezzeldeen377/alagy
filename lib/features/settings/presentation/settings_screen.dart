import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/app_settings_cubit.dart';
import '../cubit/app_settings_state.dart';
import 'package:alagy/core/helpers/extensions.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
      ),
      
      body: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              SwitchListTile(
                title: Text(context.l10n.darkMode),
                value: state.themeMode == ThemeMode.dark,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  context.read<AppSettingsCubit>().setTheme(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                },
              ),
              ListTile(
                title: Text(context.l10n.language),
                trailing: Text(state.locale.languageCode.toUpperCase()),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(context.l10n.english),
                            trailing: state.locale.languageCode == 'en'
                                ? const Icon(Icons.check)
                                : null,
                            onTap: () {
                              context
                                  .read<AppSettingsCubit>()
                                  .setLocale(const Locale('en'));
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text(context.l10n.arabic),
                            trailing: state.locale.languageCode == 'ar'
                                ? const Icon(Icons.check)
                                : null,
                            onTap: () {
                              context
                                  .read<AppSettingsCubit>()
                                  .setLocale(const Locale('ar'));
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Divider(), // Added a visual separator
              ListTile(
                leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error), // Added an icon
                title: Text(
                  context.l10n.logout,
                  style: TextStyle(color: Theme.of(context).colorScheme.error), // Style to indicate an action
                ),
                onTap: () {
                   context.read<AppUserCubit>().signOut();
                },
              ),
            ],
          );
        },
      ),
    );
  }}