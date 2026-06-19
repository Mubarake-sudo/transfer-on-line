import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

// ─── Step 4 : Récapitulatif & Paiement ──────────────────────────────────────

class Step4PaymentScreen extends StatefulWidget {
  final String operator;
  final String service;
  final String operation;
  final String phone;
  final int amount;
  final Function(Transaction) onTransactionAdded;

  const Step4PaymentScreen({
    super.key,
    required this.operator,
    required this.service,
    required this.operation,
    required this.phone,
    required this.amount,
    required this.onTransactionAdded,
  });

  @override
  State<Step4PaymentScreen> createState() => _Step4PaymentScreenState();
}

class _Step4PaymentScreenState extends State<Step4PaymentScreen> {
  String _payMethod = 'Orange Money';
  bool _loading = false;

  final List<Map<String, dynamic>> payMethods = [
    {'name': 'Wave',         'image': 'assets/images/wave.jpg',                  'color': 0xFF00B4F5},
    {'name': 'Orange Money', 'image': 'assets/images/Orange-Money-logo.png',     'color': 0xFFFF6A00},
    {'name': 'MTN Money',   'image': 'assets/images/mtn_money.jpg',              'color': 0xFFF5C400},
    {'name': 'Moov Money',  'image': 'assets/images/moov_money_ci.png',          'color': 0xFF0048C8},
  ];

  String _opImage(String op) {
    if (op == 'MTN') return 'assets/images/mtn.jpg';
    if (op == 'Moov') return 'assets/images/moov.jpeg';
    return 'assets/images/Orange_logo.png';
  }

  @override
  Widget build(BuildContext context) {
    final isTransfer = widget.operation.contains('Transfert');

    // Logo opérateur réel pour le récapitulatif
    final opLogo = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        _opImage(widget.operator),
        width: 28, height: 28, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.business_rounded, size: 20),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        GreenHeader(
          title: 'Récapitulatif & Paiement',
          subtitle: 'Vérifiez les informations avant\nde procéder au paiement',
          icon: '✅',
          step: 4,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Récapitulatif ──
                TolCard(
                  padding: EdgeInsets.zero,
                  child: Column(children: [
                    _sumRow(opLogo, 'Opérateur', widget.operator,
                        AppColors.operatorColor(widget.operator)),
                    _sumRow(const Text('🌐', style: TextStyle(fontSize: 16)),
                        'Service', widget.service, AppColors.blue),
                    _sumRow(const Text('🔄', style: TextStyle(fontSize: 16)),
                        'Opération', isTransfer ? 'Souscription' : 'Souscription',
                        AppColors.primary),
                    _sumRow(const Text('📞', style: TextStyle(fontSize: 16)),
                        'Numéro', widget.phone, null),
                    _sumRow(const Text('💲', style: TextStyle(fontSize: 16)),
                        'Montant', '${widget.amount} FCFA', null,
                        isLast: true),
                  ]),
                ),

                const SizedBox(height: 12),

                // ── Total à payer ──
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    Text('Total à payer',
                        style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary)),
                    const Spacer(),
                    Text('${widget.amount} ',
                        style: GoogleFonts.nunito(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary)),
                    Text('FCFA',
                        style: GoogleFonts.nunito(
                            fontSize: 14, color: AppColors.primary)),
                  ]),
                ),

                const SizedBox(height: 18),

                Text('Choisir le moyen de paiement',
                    style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 10),

                // ── Grille 2×2 des moyens de paiement ──
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3.0,
                  children: payMethods.map(_payTile).toList(),
                ),

                const SizedBox(height: 14),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.lock_rounded,
                      size: 14, color: AppColors.textHint),
                  const SizedBox(width: 6),
                  Text('Paiement 100% sécurisé',
                      style: GoogleFonts.nunito(
                          fontSize: 11, color: AppColors.textHint)),
                ]),

                const SizedBox(height: 14),

                TolButton(
                  label: isTransfer ? 'TRANSFÉRER' : 'SOUSCRIRE',
                  onTap: _confirm,
                  loading: _loading,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _sumRow(Widget leading, String key, String val, Color? color,
      {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFF5F5F5)))),
      child: Row(children: [
        leading,
        const SizedBox(width: 10),
        Expanded(
            child: Text(key,
                style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600))),
        Text(val,
            style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: color ?? AppColors.textPrimary)),
      ]),
    );
  }

  Widget _payTile(Map<String, dynamic> p) {
    final sel = _payMethod == p['name'];
    final color = Color(p['color'] as int);
    final imagePath = p['image'] as String;
    return GestureDetector(
      onTap: () => setState(() => _payMethod = p['name'] as String),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: sel ? AppColors.success : const Color(0xFFEEEEEE),
              width: sel ? 2 : 1),
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 32, height: 32, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.payment_rounded, color: color, size: 18),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(p['name'] as String,
                style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary),
                maxLines: 2),
          ),
        ]),
      ),
    );
  }

  Future<void> _confirm() async {
    // ignore: use_build_context_synchronously
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));

    final txn = Transaction(
      id: 'TRX-2025-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      operator: widget.operator,
      service: widget.service,
      operation: widget.operation,
      phone: widget.phone,
      amount: widget.amount,
      paymentMethod: _payMethod,
      date: DateTime.now(),
      status: 'ok',
    );
    widget.onTransactionAdded(txn);

    if (mounted) {
      setState(() => _loading = false);
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => SuccessScreen(transaction: txn),
      ));
    }
  }
}

// ─── Success Screen (Détail notification) ───────────────────────────────────
class SuccessScreen extends StatelessWidget {
  final Transaction transaction;
  const SuccessScreen({super.key, required this.transaction});

  String _opImage(String op) {
    if (op == 'MTN') return 'assets/images/mtn.jpg';
    if (op == 'Moov') return 'assets/images/moov.jpeg';
    return 'assets/images/Orange_logo.png';
  }

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final date =
        '${t.date.day.toString().padLeft(2, '0')}/${t.date.month.toString().padLeft(2, '0')}/${t.date.year}';
    final heure =
        '${t.date.hour.toString().padLeft(2, '0')}:${t.date.minute.toString().padLeft(2, '0')}';

    final opLogo = ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(_opImage(t.operator),
          width: 24, height: 24, fit: BoxFit.cover),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
        ),
        centerTitle: true,
        title: Text('Détail notification',
            style: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(children: [
          // ── Badge succès ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: [
              Container(
                width: 64, height: 64,
                decoration: const BoxDecoration(
                    color: AppColors.primary, shape: BoxShape.circle),
                child: const Center(
                  child: Icon(Icons.check_rounded, color: Colors.white, size: 36),
                ),
              ),
              const SizedBox(height: 14),
              Text('Transaction réussie',
                  style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary)),
              const SizedBox(height: 4),
              Text('Votre opération a été effectuée avec succès',
                  style: GoogleFonts.nunito(
                      fontSize: 12, color: AppColors.textSecondary),
                  textAlign: TextAlign.center),
            ]),
          ),

          const SizedBox(height: 16),

          // ── Détails ──
          TolCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              _row('📋', 'Référence transaction', t.id, AppColors.primary),
              _rowWidget(opLogo, 'Opérateur', t.operator,
                  AppColors.operatorColor(t.operator)),
              _row('🌐', 'Service', t.service, AppColors.blue),
              _row('🔄', 'Type d\'opération', t.operation, AppColors.primary),
              _row('📞', 'Numéro', t.phone, null),
              _row('💲', 'Montant', '${t.amount} FCFA', null),
              _row('💳', 'Moyen de paiement', t.paymentMethod, AppColors.orange),
              _row('📅', 'Date', date, null),
              _row('🕐', 'Heure', heure, null),
              _row('✅', 'Statut', 'Réussie', AppColors.primary, last: true),
            ]),
          ),

          const SizedBox(height: 16),

          // ── Message ──
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26, height: 26,
                  decoration: const BoxDecoration(
                      color: AppColors.blue, shape: BoxShape.circle),
                  child: const Center(
                    child: Icon(Icons.info_rounded, color: Colors.white, size: 16),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Message',
                          style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(
                        'Votre forfait ${t.service} a été activé avec succès. '
                        'Vous pouvez commencer à l\'utiliser immédiatement.',
                        style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Bouton principal ──
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.history_rounded, color: Colors.white, size: 20),
              label: Text('VOIR DANS L\'HISTORIQUE',
                  style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
            ),
          ),

          const SizedBox(height: 12),

          TextButton(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: Text('Fermer',
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ),
        ]),
      ),
    );
  }

  Widget _row(String icon, String key, String val, Color? color,
      {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: Color(0xFFF0F0F0)))),
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
                color: color ?? AppColors.textPrimary)),
      ]),
    );
  }

  Widget _rowWidget(Widget leading, String key, String val, Color? color,
      {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: Color(0xFFF0F0F0)))),
      child: Row(children: [
        leading,
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
                color: color ?? AppColors.textPrimary)),
      ]),
    );
  }
}
