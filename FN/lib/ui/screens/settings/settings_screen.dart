import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgy/providers/auth_provider';
import 'package:budgy/ui/screens/auth/login.dart';
import 'package:budgy/ui/screens/profile/profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // User Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/profile_placeholder.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user == null ? "Guest" : "${user.firstName} ${user.lastName}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.email ?? "",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Settings Options
          Expanded(
            child: ListView(
              children: [
                _buildSectionHeader("Account"),
                _buildSettingsTile(
                  context,
                  icon: Icons.person_outline,
                  title: "Profile",
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.lock_outline,
                  title: "Security",
                  onTap: () => _navigateTo(context, "/security"),
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.notifications_outlined,
                  title: "Notifications",
                  trailing: Switch(value: true, onChanged: (v) {}),
                ),
                _buildSectionHeader("Preferences"),
                _buildSettingsTile(
                  context,
                  icon: Icons.language_outlined,
                  title: "Language",
                  subtitle: "English",
                  onTap: () => _navigateTo(context, "/language"),
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  trailing: Switch(value: false, onChanged: (v) {}),
                ),
                _buildSectionHeader("Support"),
                _buildSettingsTile(
                  context,
                  icon: Icons.help_outline,
                  title: "Help Center",
                  onTap: () => _navigateTo(context, "/help"),
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.info_outline,
                  title: "About App",
                  onTap: () => _navigateTo(context, "/about"),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text("Log Out"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _showLogoutDialog(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    // Implement navigation logic
    Navigator.pushNamed(context, route);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Log Out"),
            content: const Text("Are you sure you want to log out?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthProvider>().logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
