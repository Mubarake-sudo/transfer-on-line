import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

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

  final payMethods = [
    {'name': 'Wave', 'icon': '🐧', 'color': 0xFF00B4F5},
    {'name': 'Orange Money', 'icon': '💳', 'color': 0xFFFF6A00},
    {'name': 'MTN Money', 'icon': '📱', 'color': 0xFFF5C400},
    {'name': 'Moov Money', 'icon': '💰', 'color': 0xFF0048C8},
  ];

  @override
  Widget build(BuildContext context) {
    final isTransfer = widget.operation.contains('Transfert');
    final rows = [
      {'icon': '📡', 'key': 'Opérateur', 'val': widget.operator, 'cls': 'op'},
      {'icon': '🌐', 'key': 'Service', 'val': widget.service, 'cls': 'svc'},
      {'icon': '🔄', 'key': 'Opération', 'val': isTransfer ? 'Transfert' : 'Souscription', 'cls': 'green'},
      {'icon': '📞', 'key': 'Numéro', 'val': widget.phone, 'cls': ''},
      {'icon': '💲', 'key': 'Montant', 'val': '${widget.amount} FCFA', 'cls': ''},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        GreenHeader(
          title: 'Récapitulatif & Paiement',
          subtitle: 'Vérifiez les informations avant de procéder au paiement',
          icon: '✅',
          step: 4,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TolCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: rows.asMap().entries.map((e) {
                      final r = e.value;
                      final isLast = e.key == rows.length - 1;
                      return _sumRow(r['icon']!, r['key']!, r['val']!, r['cls']!, isLast: isLast);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    Text('Total à payer', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    const Spacer(),
                    Text('${widget.amount} ', style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary)),
                    Text('FCFA', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.primary)),
                  ]),
                ),
                const SizedBox(height: 18),
                Text('Choisir le moyen de paiement', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3.4,
                  children: payMethods.map((p) => _payTile(p)).toList(),
                ),
                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.lock_rounded, size: 14, color: AppColors.textHint),
                  const SizedBox(width: 6),
                  Text('Paiement 100% sécurisé', style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textHint)),
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

  Widget _sumRow(String icon, String key, String val, String cls, {bool isLast = false}) {
    Color valColor = AppColors.textPrimary;
    if (cls == 'op') valColor = AppColors.operatorColor(widget.operator);
    if (cls == 'svc') valColor = AppColors.blue;
    if (cls == 'green') valColor = AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF5F5F5)))),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(child: Text(key, style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600))),
        Text(val, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w900, color: valColor)),
      ]),
    );
  }

  Widget _payTile(Map<String, dynamic> p) {
    final sel = _payMethod == p['name'];
    final color = Color(p['color'] as int);
    return GestureDetector(
      onTap: () => setState(() => _payMethod = p['name']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: sel ? AppColors.success : Colors.transparent, width: 2),
        ),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(p['icon'], style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(p['name'], style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary))),
        ]),
      ),
    );
  }

  Future<void> _confirm() async {
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

// ─── Success Screen ───────────────────────────────────────────────────────────
class SuccessScreen extends StatelessWidget {
  final Transaction transaction;
  const SuccessScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Container(width: 64, height: 64, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Center(child: Text('✅', style: TextStyle(fontSize: 30)))),
            const SizedBox(height: 14),
            Text('Transaction réussie', style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary)),
            const SizedBox(height: 4),
            Text('Votre opération a été effectuée avec succès', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textSecondary), textAlign: TextAlign.center),
          ]),
        ),
        const SizedBox(height: 16),
        TolCard(padding: EdgeInsets.zero, child: Column(children: [
          _row('📋', 'Référence', t.id, AppColors.primary),
          _row('📡', 'Opérateur', t.operator, AppColors.operatorColor(t.operator)),
          _row('🌐', 'Service', t.service, AppColors.blue),
          _row('🔄', 'Type d\'opération', t.operation, AppColors.primary),
          _row('📞', 'Numéro', t.phone, null),
          _row('💲', 'Montant', '${t.amount} FCFA', null),
          _row('💳', 'Moyen de paiement', t.paymentMethod, AppColors.orange),
          _row('📅', 'Date', '${t.date.day}/${t.date.month}/${t.date.year}', null),
          _row('🕐', 'Heure', '${t.date.hour.toString().padLeft(2, '0')}:${t.date.minute.toString().padLeft(2, '0')}', null),
          _row('🛡️', 'Statut', 'Réussie', AppColors.primary, last: true),
        ])),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Container(width: 26, height: 26, decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
              child: const Center(child: Text('i', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)))),
            const SizedBox(width: 10),
            Expanded(child: Text('Votre forfait ${t.service} a été activé avec succès. Vous pouvez commencer à l\'utiliser immédiatement.',
              style: GoogleFonts.nunito(fontSize: 12, color: const Color(0xFF444444)))),
          ]),
        ),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, height: 52,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
            icon: const Text('📋', style: TextStyle(fontSize: 16)),
            label: Text('VOIR DANS L\'HISTORIQUE', style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, height: 52,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.moov, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
            icon: const Text('➕', style: TextStyle(fontSize: 16)),
            label: Text('NOUVELLE OPÉRATION', style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          child: Text('Retour à l\'accueil', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
        ),
        const SizedBox(height: 20),
      ]))),
    );
  }

  Widget _row(String icon, String key, String val, Color? color, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: last ? null : const Border(bottom: BorderSide(color: Color(0xFFF5F5F5)))),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(child: Text(key, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600))),
        Text(val, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w900, color: color ?? AppColors.textPrimary)),
      ]),
    );
  }
}
