import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'step4_payment.dart';

class Step3InfoScreen extends StatefulWidget {
  final String operator;
  final String service;
  final String operation;
  final Function(Transaction) onTransactionAdded;

  const Step3InfoScreen({super.key, required this.operator, required this.service, required this.operation, required this.onTransactionAdded});

  @override
  State<Step3InfoScreen> createState() => _Step3InfoScreenState();
}

class _Step3InfoScreenState extends State<Step3InfoScreen> {
  final _phoneCtrl = TextEditingController();
  final _amtCtrl = TextEditingController(text: '1000');
  int _selectedAmt = 1000;
  final _quickAmts = [500, 1000, 2000, 5000, 10000, 0];

  bool get _isTransfer => widget.operation.contains('Transfert');
  bool get _isTiers => widget.operation.contains('tiers');

  @override
  void dispose() { _phoneCtrl.dispose(); _amtCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Column(children: [
        GreenHeader(title: 'Saisir les informations', subtitle: 'Entrez le numéro et le montant', icon: '📋', step: 3),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _isTiers ? AppColors.blueLight : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Container(width: 38, height: 38,
                  decoration: BoxDecoration(color: (_isTiers ? AppColors.blue : AppColors.primary).withOpacity(0.15), shape: BoxShape.circle),
                  child: Center(child: Icon(_isTiers ? Icons.person_outline : Icons.assignment_outlined,
                    color: _isTiers ? AppColors.blue : AppColors.primary, size: 20))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.operation, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                  Text(_isTiers ? 'Saisissez le numéro du bénéficiaire.' : 'Saisissez votre numéro Orange, MTN ou Moov.',
                    style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textSecondary)),
                ])),
              ]),
            ),
            const SizedBox(height: 16),

            // Phone
            Text('Numéro', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 14), height: 52,
              child: Row(children: [
                Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 10),
                Expanded(child: TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(hintText: 'Entrez le numéro',
                    hintStyle: GoogleFonts.nunito(color: AppColors.textHint, fontSize: 14),
                    border: InputBorder.none, isDense: true),
                  style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700),
                )),
                Icon(_isTiers ? Icons.contact_page_outlined : Icons.person_outline_rounded, color: AppColors.primary, size: 22),
              ]),
            ),
            Padding(padding: const EdgeInsets.only(top: 4, left: 2),
              child: Text('Exemple : 07XXXXXXXX', style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textHint))),
            const SizedBox(height: 14),

            // Amount
            Text('Montant', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 14), height: 52,
              child: Row(children: [
                Icon(Icons.monetization_on_outlined, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 10),
                Expanded(child: TextField(
                  controller: _amtCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) => setState(() => _selectedAmt = int.tryParse(v) ?? 0),
                  decoration: InputDecoration(hintText: 'Entrez le montant',
                    hintStyle: GoogleFonts.nunito(color: AppColors.textHint, fontSize: 14),
                    border: InputBorder.none, isDense: true),
                  style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700),
                )),
                Row(children: [
                  Text('FCFA', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.primary)),
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 18),
                ]),
              ]),
            ),
            Padding(padding: const EdgeInsets.only(top: 4, left: 2),
              child: Text(_isTransfer ? 'Entrez le montant à transférer' : 'Entrez le montant à souscrire',
                style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textHint))),
            const SizedBox(height: 14),

            // Quick amounts title
            Row(children: [
              const Text('⚡', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text('Montants rapides', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            ]),
            const SizedBox(height: 8),

            // Quick amounts grid - FIX overflow with proper aspect ratio
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.5,
              ),
              itemCount: _quickAmts.length,
              itemBuilder: (_, i) {
                final a = _quickAmts[i];
                final isSel = a == 0 ? !_quickAmts.sublist(0, 5).contains(_selectedAmt) : _selectedAmt == a;
                return GestureDetector(
                  onTap: () {
                    if (a == 0) { _showCustomAmt(); return; }
                    setState(() { _selectedAmt = a; _amtCtrl.text = '$a'; });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(a == 0 ? 'Autre' : _fmt(a),
                        style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w900,
                          color: isSel ? Colors.white : AppColors.textPrimary)),
                      Text(a == 0 ? 'montant' : 'FCFA',
                        style: GoogleFonts.nunito(fontSize: 10,
                          color: isSel ? Colors.white70 : AppColors.textHint)),
                    ]),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            TolButton(label: 'CONTINUER ›', onTap: _next),
          ]),
        )),
      ]),
    );
  }

  String _fmt(int n) => n >= 1000 ? '${n ~/ 1000} 000' : '$n';

  void _showCustomAmt() {
    final c = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Montant personnalisé', style: GoogleFonts.nunito(fontWeight: FontWeight.w900)),
      content: TextField(controller: c, keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(suffix: Text('FCFA', style: GoogleFonts.nunito(color: AppColors.primary, fontWeight: FontWeight.w700)),
          border: const OutlineInputBorder()),
        autofocus: true),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler', style: GoogleFonts.nunito())),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            final v = int.tryParse(c.text) ?? 0;
            if (v > 0) setState(() { _selectedAmt = v; _amtCtrl.text = '$v'; });
            Navigator.pop(context);
          },
          child: Text('OK', style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.w900)),
        ),
      ],
    ));
  }

  void _next() {
    if (_phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez entrer un numéro', style: GoogleFonts.nunito()),
        backgroundColor: AppColors.red, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
      return;
    }
    if (_selectedAmt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez entrer un montant valide', style: GoogleFonts.nunito()),
        backgroundColor: AppColors.red, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => Step4PaymentScreen(
      operator: widget.operator, service: widget.service, operation: widget.operation,
      phone: _phoneCtrl.text, amount: _selectedAmt, onTransactionAdded: widget.onTransactionAdded,
    )));
  }
}
