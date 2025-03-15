import 'package:alagy/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:alagy/core/common/cubit/app_user/app_user_state.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/routes/routes.dart';
import 'package:alagy/features/authentication/presentation/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:alagy/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  void _handleLogout(BuildContext context) {
    context.read<AppUserCubit>().onSignOut();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppUserCubit>();
    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state.isClearUserData()) {
          context.pushNamedAndRemoveAll(RouteNames.signIn);
        }
        if (state.isSignOut()) {
          context.read<AppUserCubit>().clearUserData();
        }
      },
      child: Scaffold(
        appBar: AppBar(),
          drawer: Drawer(
         child: ListView(
           padding: EdgeInsets.zero,
           children: [
              DrawerHeader(
   
               
               child: Text(
                 context.l10n.appName,
                 style:context.theme.textTheme.titleLarge,
               ),
             ),
             ListTile(
               leading: const Icon(Icons.settings),
               title: Text(context.l10n.settings),
               onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => const SettingsScreen(),
                   ),
                 );
               },
             ),
           ],
         ),
       ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Center(
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      backgroundImage: cubit.state.user?.profileImage != null
                          ? NetworkImage(cubit.state.user!.profileImage!)
                          : const AssetImage('assets/images/default_profile.png') as ImageProvider,
                      child: cubit.state.user?.profileImage == null
                          ? Icon(Icons.person, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant)
                          : null,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      context.l10n.welcomeMessage(cubit.state.user?.name ?? ''),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.roleLabel(cubit.state.user?.type?.toUpperCase() ?? ''),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.tonalIcon(
                      icon: const Icon(Icons.logout),
                      label: Text(context.l10n.signOut),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      onPressed: () => _handleLogout(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
