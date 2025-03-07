import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/app_settings_cubit.dart';
import '../cubit/app_settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: state.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  context.read<AppSettingsCubit>().setTheme(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                },
              ),
              ListTile(
                title: const Text('Language'),
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
                            title: const Text('English'),
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
                            title: const Text('العربية'),
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
            ],
          );
        },
      ),
    );
  }}