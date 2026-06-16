import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'step1_operator.dart';
import 'history_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

// Écran principal (tableau de bord) — affiche le solde, actions rapides
// et les transactions récentes. Les commentaires sont en français pour
// aider les débutants à comprendre la structure.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  List<Transaction> txns = List.from(sampleTransactions);
  List<AppNotification> notifs = List.from(sampleNotifications);

  // Ajoute une transaction en tête de la liste et met à jour l'UI.
  void _addTransaction(Transaction t) {
    setState(() => txns.insert(0, t));
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildHome(),
      HistoryScreen(transactions: txns),
      const SizedBox(),
      NotificationsScreen(notifications: notifs),
      ProfileScreen(),
    ];

    return Scaffold(
      body: tabs[_tab],
      bottomNavigationBar: _buildNavBar(),
      floatingActionButton: _tab == 2 ? null : null,
    );
  }

  Widget _buildNavBar() {
    // Barre de navigation inférieure personnalisée : change d'onglet
    // ou ouvre l'écran de création d'opération (item index 2).
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Accueil'},
      {'icon': Icons.receipt_long_rounded, 'label': 'Historique'},
      {'icon': Icons.add_circle_rounded, 'label': 'Opération'},
      {'icon': Icons.notifications_rounded, 'label': 'Notifs'},
      {'icon': Icons.person_rounded, 'label': 'Profil'},
    ];
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
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (i == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Step1OperatorScreen(
                                onTransactionAdded: _addTransaction),
                          ));
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
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              items[i]['icon'] as IconData,
                              size: i == 2 ? 32 : 24,
                              color: isActive
                                  ? AppColors.primary
                                  : (i == 2
                                      ? AppColors.primary
                                      : const Color(0xFFAAAAAA)),
                            ),
                          ),
                          if (i == 3 && unread > 0)
                            Positioned(
                              top: -4,
                              right: -6,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: Center(
                                    child: Text('$unread',
                                        style: GoogleFonts.nunito(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white))),
                              ),
                            ),
                        ],
                      ),
                      if (i != 2) ...[
                        const SizedBox(height: 3),
                        Text(
                          items[i]['label'] as String,
                          style: GoogleFonts.nunito(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? AppColors.primary
                                : const Color(0xFFAAAAAA),
                          ),
                        ),
                      ],
                      if (isActive && i != 2)
                        Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                                color: AppColors.primary,
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

  Widget _buildHome() {
    // Page d'accueil principale : header, solde, opérateurs, actions et
    // transactions récentes. Le total affiché agrège les transactions réussies.
    final totalOk =
        txns.where((t) => t.status == 'ok').fold(0, (a, t) => a + t.amount);
    final unread = notifs.where((n) => !n.read).length;

    return Scaffold(
      backgroundColor: const Color(0xFF061A0E),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHomeTop(unread)),
          SliverToBoxAdapter(child: _buildBalanceCard(totalOk)),
          SliverToBoxAdapter(child: _buildOperators()),
          SliverToBoxAdapter(child: _buildQuickActions()),
          SliverToBoxAdapter(child: _buildRecentTransactions()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildHomeTop(int unread) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 12,
          left: 20,
          right: 20,
          bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Bonjour 👋",
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.white54,
                    fontWeight: FontWeight.w600)),
            Text("Konan Yves",
                style: GoogleFonts.nunito(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w900)),
          ]),
          Row(children: [
            _iconBtn(Icons.notifications_rounded,
                onTap: () => setState(() => _tab = 3), badge: unread),
            const SizedBox(width: 10),
            _iconBtn(Icons.settings_rounded,
                onTap: () => setState(() => _tab = 4)),
          ]),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, {required VoidCallback onTap, int badge = 0}) {
    // Petit bouton circulaire réutilisable (badge optionnel).
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white12, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          if (badge > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                child: Center(
                    child: Text('$badge',
                        style: GoogleFonts.nunito(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Colors.white))),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(int total) {
    // Carte qui affiche le total des transactions du mois et boutons
    // rapides pour créer une opération ou accéder à l'historique.
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF1A6E35), Color(0xFF0D4A22)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total transactions ce mois",
              style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: Colors.white60,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: '${_fmtAmt(total)} ',
                style: GoogleFonts.nunito(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white)),
            TextSpan(
                text: 'FCFA',
                style: GoogleFonts.nunito(fontSize: 16, color: Colors.white70)),
          ])),
          const SizedBox(height: 4),
          Text(
              "${txns.length} opérations · ${txns.where((t) => t.status == 'ok').length} réussies",
              style: GoogleFonts.nunito(
                  fontSize: 11, color: Colors.white.withOpacity(0.5))),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: _balBtn("➕ Nouvelle opération", onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Step1OperatorScreen(
                          onTransactionAdded: _addTransaction)));
            })),
            const SizedBox(width: 10),
            Expanded(
                child: _balBtn("📋 Historique",
                    onTap: () => setState(() => _tab = 1))),
          ]),
        ],
      ),
    );
  }

  Widget _balBtn(String label, {required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: Colors.white24, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(label,
                  style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white))),
        ),
      );

  Widget _buildOperators() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Opérateurs",
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white70)),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Step1OperatorScreen(
                          onTransactionAdded: _addTransaction))),
              child: Text("Voir tout →",
                  style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4ADE80))),
            ),
          ]),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Orange', 'MTN', 'Moov']
                  .map((op) => GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Step1OperatorScreen(
                                  onTransactionAdded: _addTransaction,
                                  preselectedOp: op),
                            )),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color:
                                AppColors.operatorColor(op).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.operatorColor(op)
                                    .withOpacity(0.3)),
                          ),
                          child: Column(children: [
                            _opLogo(op),
                            const SizedBox(height: 8),
                            Text(op,
                                style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white)),
                          ]),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _opLogo(String op) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: op == 'Moov'
            ? AppColors.moov
            : op == 'MTN'
                ? AppColors.mtn
                : AppColors.orange,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
          child: Text(op == 'Orange' ? 'o' : op,
              style: GoogleFonts.nunito(
                  fontSize: op == 'MTN' ? 13 : 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white))),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': '📱', 'label': 'Internet'},
      {'icon': '📞', 'label': 'Appels'},
      {'icon': '💬', 'label': 'SMS'},
      {'icon': '🔄', 'label': 'Transférer'},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Actions rapides",
              style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            children: actions
                .map((a) => Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Step1OperatorScreen(
                                    onTransactionAdded: _addTransaction))),
                        child: Container(
                          margin: EdgeInsets.only(
                              right: a == actions.last ? 0 : 10),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Column(children: [
                            Text(a['icon']!,
                                style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 6),
                            Text(a['label']!,
                                style: GoogleFonts.nunito(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withOpacity(0.6)),
                                textAlign: TextAlign.center),
                          ]),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F2F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Transactions récentes",
                style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary)),
            GestureDetector(
              onTap: () => setState(() => _tab = 1),
              child: Text("Tout voir →",
                  style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
            ),
          ]),
          const SizedBox(height: 14),
          ...txns.take(4).map((t) => _txnItem(t)),
        ],
      ),
    );
  }

  Widget _txnItem(Transaction t) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => TransactionDetailScreen(transaction: t))),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider))),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: AppColors.operatorColor(t.operator).withOpacity(0.1),
                borderRadius: BorderRadius.circular(14)),
            child: Center(
                child:
                    Text(t.serviceIcon, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('${t.operator} · ${t.service}',
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
                Text('${t.operation} · ${_dateStr(t.date)}',
                    style: GoogleFonts.nunito(
                        fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                StatusBadge(t.status),
              ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('-${_fmtAmt(t.amount)}',
                style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.red)),
            Text('FCFA',
                style: GoogleFonts.nunito(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHint)),
          ]),
        ]),
      ),
    );
  }

  String _fmtAmt(int n) {
    // Formatte un entier en chaîne lisible (ex: 1000 -> "1 000").
    if (n >= 1000)
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)} 000';
    return '$n';
  }

  String _dateStr(DateTime d) {
    // Renvoie une représentation courte de la date : aujourd'hui, hier ou
    // jour + mois (ex: 12 Jan).
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inDays == 0)
      return "Aujourd'hui ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
    if (diff.inDays == 1) return "Hier";
    return "${d.day} ${[
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ][d.month - 1]}";
  }
}

// ─── Transaction Detail Screen ────────────────────────────────────────────────
class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;
  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final isOk = t.status == 'ok';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF0D5C2C), Color(0xFF1A7A3C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 20,
              left: 20,
              right: 20),
          child: Column(children: [
            Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 16)),
              ),
              const Expanded(
                  child: Center(
                      child: Text('Détail transaction',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900)))),
              const SizedBox(width: 36),
            ]),
          ]),
        ),
        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color:
                            isOk ? AppColors.primaryLight : AppColors.redLight,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(children: [
                      Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                              color: isOk ? AppColors.primary : AppColors.red,
                              shape: BoxShape.circle),
                          child: Center(
                              child: Text(isOk ? '✅' : '❌',
                                  style: const TextStyle(fontSize: 30)))),
                      const SizedBox(height: 14),
                      Text(isOk ? 'Transaction réussie' : 'Transaction échouée',
                          style: GoogleFonts.nunito(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: isOk ? AppColors.primary : AppColors.red)),
                      const SizedBox(height: 4),
                      Text(
                          isOk
                              ? 'Votre opération a été effectuée avec succès'
                              : "Le paiement n'a pas pu être traité",
                          style: GoogleFonts.nunito(
                              fontSize: 13, color: AppColors.textSecondary),
                          textAlign: TextAlign.center),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  TolCard(
                      padding: EdgeInsets.zero,
                      child: Column(children: [
                        _row('📋', 'Référence', t.id, AppColors.primary),
                        _row('📡', 'Opérateur', t.operator,
                            AppColors.operatorColor(t.operator)),
                        _row('🌐', 'Service', t.service, AppColors.blue),
                        _row('🔄', 'Opération', t.operation, AppColors.primary),
                        _row('📞', 'Numéro', t.phone, null),
                        _row('💲', 'Montant', '${t.amount} FCFA', null),
                        _row('💳', 'Paiement', t.paymentMethod,
                            AppColors.orange),
                        _row(
                            '📅',
                            'Date',
                            '${t.date.day}/${t.date.month}/${t.date.year}',
                            null),
                        _row(
                            '🕐',
                            'Heure',
                            '${t.date.hour.toString().padLeft(2, '0')}:${t.date.minute.toString().padLeft(2, '0')}',
                            null),
                        _row('🛡️', 'Statut', t.statusLabel,
                            isOk ? AppColors.primary : AppColors.red,
                            last: true),
                      ])),
                  if (isOk) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: AppColors.blueLight,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(children: [
                        Container(
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(
                                color: AppColors.blue, shape: BoxShape.circle),
                            child: const Center(
                                child: Text('i',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12)))),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(
                                'Votre forfait ${t.service} a été activé avec succès. Vous pouvez commencer à l\'utiliser immédiatement.',
                                style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    color: const Color(0xFF444444)))),
                      ]),
                    ),
                  ],
                ]))),
      ]),
    );
  }

  Widget _row(String icon, String key, String val, Color? valColor,
      {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          border: last
              ? null
              : Border(bottom: const BorderSide(color: Color(0xFFF5F5F5)))),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
            child: Text(key,
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600))),
        Text(val,
            style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: valColor ?? AppColors.textPrimary)),
      ]),
    );
  }
}
