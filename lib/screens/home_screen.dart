import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/transaction_service.dart';
import 'step2_service.dart';
import 'notifications_screen.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  HOME SCREEN — Écran principal de l'application
//  • Tab 0 : Landing plein écran sombre SANS barre de navigation (mockup)
//  • Tab 1–4 : Autres onglets AVEC barre de navigation en bas
// ═══════════════════════════════════════════════════════════════════════════

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Onglet actif (0 = landing, 1 = historique, 3 = notifs, 4 = profil)
  int _tab = 0;

  // Listes des transactions et notifications chargées localement
  List<Transaction> txns = List.from(sampleTransactions);
  List<AppNotification> notifs = List.from(sampleNotifications);

  @override
  void initState() {
    super.initState();
    // Charge les transactions sauvegardées depuis l'appareil
    _loadTransactions();
  }

  // Charge les transactions persistées (stockage local)
  Future<void> _loadTransactions() async {
    final saved = await TransactionService.load();
    if (saved.isNotEmpty && mounted) {
      setState(() => txns = saved); // Met à jour l'interface
    }
  }

  // Ajoute une nouvelle transaction et sauvegarde la liste
  void _addTransaction(Transaction t) {
    setState(() => txns.insert(0, t)); // Insère en tête de liste
    TransactionService.save(txns);     // Sauvegarde sur l'appareil
  }

  @override
  Widget build(BuildContext context) {
    // ── Tab 0 : landing plein écran SANS bottom nav ──────────────────────
    if (_tab == 0) {
      return Scaffold(
        // Fond transparent car le gradient est géré dans _buildLanding()
        backgroundColor: Colors.transparent,
        body: _buildLanding(),
      );
    }

    // ── Tabs 1–4 : shell avec bottom nav ─────────────────────────────────
    final tabs = [
      const SizedBox(), // Tab 0 (jamais atteint ici)
      HistoryScreen(transactions: txns),
      const SizedBox(), // Tab 2 : bouton "+"
      NotificationsScreen(notifications: notifs),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: tabs[_tab],
      bottomNavigationBar: _buildNavBar(),
    );
  }

  // ─── Barre de navigation (affichée uniquement sur les tabs 1-4) ─────────
  Widget _buildNavBar() {
    // Liste des onglets : icône + label
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Accueil'},
      {'icon': Icons.receipt_long_rounded, 'label': 'Historique'},
      {'icon': Icons.add_circle_rounded, 'label': 'Opération'},
      {'icon': Icons.notifications_rounded, 'label': 'Notifs'},
      {'icon': Icons.person_rounded, 'label': 'Profil'},
    ];

    // Nombre de notifications non lues (pour le badge rouge)
    final unread = notifs.where((n) => !n.read).length;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8E8E8), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (i) {
              final isActive = _tab == i;
              final activeColor = AppColors.primary;
              final inactiveColor = const Color(0xFFAAAAAA);

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (i == 2) {
                      // Le bouton "+" ramène au landing (tab 0)
                      setState(() => _tab = 0);
                    } else {
                      setState(() => _tab = i);
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            items[i]['icon'] as IconData,
                            size: i == 2 ? 32 : 24,
                            color: isActive
                                ? activeColor
                                : (i == 2 ? activeColor : inactiveColor),
                          ),
                          // Badge rouge pour les notifications non lues
                          if (i == 3 && unread > 0)
                            Positioned(
                              top: -4, right: -6,
                              child: Container(
                                width: 16, height: 16,
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Text('$unread',
                                      style: GoogleFonts.nunito(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Label (sauf pour le bouton central "+")
                      if (i != 2) ...[
                        const SizedBox(height: 2),
                        Text(items[i]['label'] as String,
                            style: GoogleFonts.nunito(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isActive ? activeColor : inactiveColor)),
                      ],
                      // Petit point sous l'onglet actif
                      if (isActive && i != 2)
                        Container(
                            width: 5, height: 5,
                            decoration: BoxDecoration(
                                color: activeColor,
                                shape: BoxShape.circle)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TAB 0 : LANDING DARK — Correspond exactement au mockup Screen 1
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildLanding() {
    // Nombre de notifications non lues pour le badge
    final unread = notifs.where((n) => !n.read).length;

    return Container(
      // ── Fond dégradé sombre (vert profond comme le mockup) ──────────────
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF031A0A), // Vert très sombre (presque noir)
            Color(0xFF062E14), // Vert sombre
            Color(0xFF0A4020), // Vert moyen
            Color(0xFF062E14), // Vert sombre (retour)
            Color(0xFF031A0A), // Vert très sombre
          ],
          stops: [0.0, 0.2, 0.5, 0.8, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ── Icône de notification (coin haut droite) ─────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    // Tap → aller à l'onglet Notifications (tab 3)
                    onTap: () => setState(() => _tab = 3),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18)),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Center(
                              child: Icon(Icons.notifications_outlined,
                                  color: Colors.white, size: 22)),
                          // Badge rouge si notifications non lues
                          if (unread > 0)
                            Positioned(
                              top: 6, right: 6,
                              child: Container(
                                width: 16, height: 16,
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Text('$unread',
                                        style: GoogleFonts.nunito(
                                            fontSize: 8,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900))),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1),

            // ── Logo circulaire avec flèche de transfert ─────────────────
            // Cercle extérieur orange, icône sync (flèche) verte à l'intérieur
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Contour orange visible
                border: Border.all(color: AppColors.orange, width: 3),
              ),
              child: Center(
                child: Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                  // Icône de synchronisation (flèches qui tournent)
                  child: const Icon(
                      Icons.sync_rounded,
                      color: AppColors.success, // Vert
                      size: 44),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Titre principal "TRANSFER ON LINE" ───────────────────────
            Text(
              'TRANSFER',
              style: GoogleFonts.nunito(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'ON LINE',
              style: GoogleFonts.nunito(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: AppColors.success, // Vert vif
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 8),

            // ── Sous-titre descriptif ─────────────────────────────────────
            Text(
              'Souscrivez ou transférez\nvos forfaits en toute simplicité',
              style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: Colors.white60,
                  height: 1.5),
              textAlign: TextAlign.center,
            ),

            const Spacer(flex: 1),

            // ── 3 icônes de services (Téléphone, Internet, SMS) ──────────
            // Chaque icône a un fond vert flou (effet glow)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône Téléphone — on inverse les couleurs car fond blanc
                _glowIcon(
                  'assets/images/telephone.png',
                  fallbackIcon: Icons.phone,
                  invertColors: true, // Transforme noir → blanc
                ),
                const SizedBox(width: 28),
                // Icône Internet (globe)
                _glowIcon(
                  'assets/images/internet.png',
                  fallbackIcon: Icons.language,
                ),
                const SizedBox(width: 28),
                // Icône SMS
                _glowIcon(
                  'assets/images/sms.png',
                  fallbackIcon: Icons.sms,
                ),
              ],
            ),

            const Spacer(flex: 1),

            // ── Label avant les opérateurs ───────────────────────────────
            Text(
              'Choisissez votre opérateur',
              style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70),
            ),
            const SizedBox(height: 14),

            // ── Cards des 3 opérateurs ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Card Orange (fond orange, logo Orange)
                  _operatorCard(
                    name: 'Orange',
                    bgColor: AppColors.orange,
                    imagePath: 'assets/images/Orange_logo.png',
                    logoWhiteBg: true, // Fond blanc derrière le logo
                  ),
                  const SizedBox(height: 12),
                  // Card MTN (fond jaune/or, logo MTN)
                  _operatorCard(
                    name: 'MTN',
                    bgColor: AppColors.mtn,
                    imagePath: 'assets/images/mtn.jpg',
                    logoWhiteBg: true,
                  ),
                  const SizedBox(height: 12),
                  // Card Moov (fond bleu, logo Moov Africa)
                  _operatorCard(
                    name: 'Moov',
                    bgColor: AppColors.moov,
                    imagePath: 'assets/images/moov.jpeg',
                    logoWhiteBg: false, // Pas de fond blanc (logo déjà coloré)
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1),

            // ── Badge de sécurité ─────────────────────────────────────────
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.verified_user_outlined,
                  color: AppColors.success, size: 14),
              const SizedBox(width: 6),
              Text(
                'Sécurisé à 100%',
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white70),
              ),
            ]),
            const SizedBox(height: 3),
            Text(
              'Vos transactions sont protégées',
              style: GoogleFonts.nunito(fontSize: 11, color: Colors.white38),
            ),
            const SizedBox(height: 10),

            // ── Marque AFRITECH-CI ────────────────────────────────────────
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.shield_outlined,
                  color: AppColors.success, size: 14),
              const SizedBox(width: 6),
              Text(
                'AFRITECH-CI',
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.success,
                    letterSpacing: 2),
              ),
            ]),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  WIDGET : Icône service avec effet glow (halo vert autour)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _glowIcon(
    String imagePath, {
    required IconData fallbackIcon, // Icône de secours si l'image ne charge pas
    bool invertColors = false,       // Inverse noir↔blanc pour les images sombres
  }) {
    return Container(
      width: 56, height: 56,
      decoration: BoxDecoration(
        // Fond vert semi-transparent
        color: AppColors.success.withValues(alpha: 0.18),
        shape: BoxShape.circle,
        // Effet glow : ombre lumineuse verte autour du cercle
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.45),
            blurRadius: 22,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: invertColors
            // ColorFiltered inverse les couleurs (utile pour logos noirs sur fond blanc)
            ? ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  // Matrice d'inversion des couleurs RGB
                  -1, 0, 0, 0, 255, // Rouge → inversé
                   0,-1, 0, 0, 255, // Vert  → inversé
                   0, 0,-1, 0, 255, // Bleu  → inversé
                   0, 0, 0, 1, 0,   // Alpha → inchangé
                ]),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    fallbackIcon,
                    color: AppColors.success,
                    size: 28,
                  ),
                ),
              )
            : Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  fallbackIcon,
                  color: AppColors.success,
                  size: 28,
                ),
              ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  WIDGET : Carte opérateur cliquable (Orange, MTN, Moov)
  // ═══════════════════════════════════════════════════════════════════════
  Widget _operatorCard({
    required String name,       // Nom de l'opérateur
    required Color bgColor,     // Couleur de fond de la carte
    required String imagePath,  // Chemin de l'image du logo
    bool logoWhiteBg = true,    // Fond blanc autour du logo ?
  }) {
    return GestureDetector(
      // Au tap → naviguer vers l'écran de choix de service (Step 2)
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Step2ServiceScreen(
            operator: name,
            onTransactionAdded: _addTransaction,
          ),
        ),
      ),
      child: Container(
        height: 72, // Hauteur de la carte
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16), // Bords arrondis
        ),
        child: Row(children: [
          const SizedBox(width: 12),

          // ── Logo de l'opérateur ──────────────────────────────────────
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              // Fond blanc uniquement si demandé (Orange et MTN oui, Moov non)
              color: logoWhiteBg ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias, // Coupe l'image aux bords du conteneur
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              // Si l'image ne charge pas, afficher une icône générique
              errorBuilder: (_, __, ___) => const Icon(
                Icons.business_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // ── Nom de l'opérateur ───────────────────────────────────────
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),

          // ── Flèche droite (indique que c'est cliquable) ──────────────
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 18),
        ]),
      ),
    );
  }
}
