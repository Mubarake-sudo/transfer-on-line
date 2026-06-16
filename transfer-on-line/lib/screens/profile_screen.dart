import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text('Profil',
            style: GoogleFonts.nunito(fontWeight: FontWeight.w900)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Column(children: [
              Container(
                width: 88,
                height: 88,
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(
                    child: Text('A',
                        style: GoogleFonts.nunito(
                            fontSize: 36, fontWeight: FontWeight.w900))),
              ),
              const SizedBox(height: 12),
              Text('Utilisateur',
                  style: GoogleFonts.nunito(
                      fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text('utilisateur@example.com',
                  style: GoogleFonts.nunito(color: AppColors.textSecondary)),
            ]),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outline_rounded),
              title: Text('Sécurité',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w800)),
              subtitle:
                  Text('Modifier le mot de passe', style: GoogleFonts.nunito()),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: Text('Paramètres',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
      ),
    );
  }
}
