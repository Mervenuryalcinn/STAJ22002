import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_paths.dart';
import 'package:lideatech_pharmacy_app/core/theme/theme_cubit.dart';
import 'package:lideatech_pharmacy_app/features/pharmacy/presentation/views/pharmacy_login_view.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';
import '../../../../core/widgets/app_logo.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final String _fallbackUserName = "Merve Yalçın";
  final String _fallbackUserEmail = "merve@example.com";

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final bool isLoggedIn = authState is AuthSuccessState;

        // DÜZELTME: Gereksiz tip dönüştürmeleri (as AuthSuccessState) kaldırıldı
        final String userName = isLoggedIn ? authState.name : _fallbackUserName;
        final String userEmail = isLoggedIn ? authState.email : _fallbackUserEmail;

        if (!isLoggedIn) {
          return Scaffold(
            backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                l10n.userProfile,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
              ),
              iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
            ),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppLogo(size: 90),
                      const SizedBox(height: 24),
                      Text(
                        l10n.userInfoNotFound,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            context.push(RoutePaths.login);
                          },
                          child: Text(
                            l10n.login,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.green.shade400,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        icon: const Icon(Icons.admin_panel_settings_outlined),
                        label: Text(
                          l10n.pharmacyStaffLogin,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PharmacyLoginView(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              l10n.userProfile,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
            ),
            iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue.shade300, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 42,
                          backgroundColor: isDark ? Colors.blue.shade900.withOpacity(0.4) : Colors.blue.shade50,
                          child: const Icon(Icons.person, size: 48, color: Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                _buildSectionCard(
                  isDark: isDark,
                  children: [
                    _buildMenuItem(
                      isDark: isDark,
                      icon: Icons.shopping_bag_outlined,
                      iconColor: Colors.blue,
                      title: l10n.pastOrders,
                      onTap: () { context.push('/orders'); },
                    ),
                    _buildDivider(isDark),
                    _buildMenuItem(
                      isDark: isDark,
                      icon: Icons.favorite_border_rounded,
                      iconColor: Colors.red,
                      title: l10n.favoriteProducts,
                      onTap: () { context.push('/favorites'); },
                    ),
                    _buildDivider(isDark),
                    _buildMenuItem(
                      isDark: isDark,
                      icon: Icons.admin_panel_settings_outlined,
                      iconColor: Colors.green,
                      title: l10n.pharmacyStaffLogin,
                      subtitle: l10n.pharmacyStaffLoginSubtitle,
                      onTap: () { context.push('/pharmacy-login'); },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  isDark: isDark,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.indigo.shade900.withOpacity(0.4) : Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.dark_mode_outlined, color: Colors.indigoAccent, size: 22),
                      ),
                      title: Text(
                        l10n.darkMode,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      trailing: Switch(
                        value: context.watch<ThemeCubit>().state == ThemeMode.dark,
                        activeThumbColor: Colors.blue, // DÜZELTME: Güncel linter uyumluluğu için değiştirildi
                        onChanged: (bool value) {
                          context.read<ThemeCubit>().toggleTheme(value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade400,
                      side: BorderSide(color: Colors.red.shade300, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: Text(
                      l10n.logout,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequestedEvent());
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({required bool isDark, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
      indent: 56,
    );
  }
}