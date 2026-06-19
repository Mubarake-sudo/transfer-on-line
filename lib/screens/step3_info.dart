import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'step4_payment.dart';

// Écran de saisie d'informations (numéro, montant).
// Explique les champs et propose des montants rapides.

class Step3InfoScreen extends StatefulWidget {
  final String operator;
  final String service;
  final String operation;
  final Function(Transaction) onTransactionAdded;

  const Step3InfoScreen({
    super.key,
    required this.operator,
    required this.service,
    required this.operation,
    required this.onTransactionAdded,
  });

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

  Color get _bannerColor {
    if (_isTransfer && _isTiers) return AppColors.purple;
    if (_isTransfer) return AppColors.amber;
    if (_isTiers) return AppColors.blue;
    return AppColors.primary;
  }

  Color get _bannerBg {
    if (_isTransfer && _isTiers) return AppColors.purpleLight;
    if (_isTransfer) return AppColors.amberLight;
    if (_isTiers) return AppColors.blueLight;
    return AppColors.primaryLight;
  }

  String get _bannerIcon {
    if (_isTransfer && _isTiers) return '👥';
    if (_isTransfer) return '🔄';
    if (_isTiers) return '👤';
    return '📋';
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _amtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        GreenHeader(
            title: 'Saisir les informations',
            subtitle: 'Entrez le numéro et le montant',
            icon: '📋',
            step: 3),
        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: _bannerBg,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(children: [
                        Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                color: _bannerColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle),
                            child: Center(
                                child: Text(_bannerIcon,
                                    style: const TextStyle(fontSize: 18)))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(widget.operation,
                                  style: GoogleFonts.nunito(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary)),
                              Text(
                                  _isTiers
                                      ? 'Saisissez le numéro du bénéficiaire.'
                                      : 'Saisissez votre numéro Orange, MTN ou Moov.',
                                  style: GoogleFonts.nunito(
                                      fontSize: 11,
                                      color: AppColors.textSecondary)),
                            ])),
                      ]),
                    ),
                    const SizedBox(height: 18),

                    // Phone
                    Text('Numéro',
                        style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      height: 50,
                      child: Row(children: [
                        const Text('📞', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: TextField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: 'Entrez le numéro',
                            hintStyle:
                                GoogleFonts.nunito(color: AppColors.textHint),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.nunito(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        )),
                        Text(_isTiers ? '📇' : '👤',
                            style: const TextStyle(fontSize: 18)),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 2),
                      child: Text('Exemple : 07XXXXXXXX',
                          style: GoogleFonts.nunito(
                              fontSize: 11, color: AppColors.textHint)),
                    ),
                    const SizedBox(height: 16),

                    // Amount
                    Text('Montant',
                        style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      height: 50,
                      child: Row(children: [
                        const Text('💲', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: TextField(
                          controller: _amtCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (v) {
                            final n = int.tryParse(v) ?? 0;
                            setState(() => _selectedAmt = n);
                          },
                          decoration: InputDecoration(
                            hintText: 'Entrez le montant',
                            hintStyle:
                                GoogleFonts.nunito(color: AppColors.textHint),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.nunito(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        )),
                        Row(children: [
                          Text('FCFA',
                              style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary)),
                          const Icon(Icons.keyboard_arrow_down,
                              color: AppColors.primary, size: 18),
                        ]),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 2),
                      child: Text(
                          _isTransfer
                              ? 'Entrez le montant à transférer'
                              : 'Entrez le montant à souscrire',
                          style: GoogleFonts.nunito(
                              fontSize: 11, color: AppColors.textHint)),
                    ),
                    const SizedBox(height: 16),

                    // Quick amounts
                    Row(children: [
                      const Text('⚡',
                          style: TextStyle(
                              fontSize: 18, color: AppColors.success)),
                      const SizedBox(width: 6),
                      Text('Montants rapides',
                          style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary)),
                    ]),
                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2.2,
                      children: _quickAmts
                          .map((a) => QuickAmountButton(
                                amount: a,
                                selected: a == 0
                                    ? !_quickAmts.contains(_selectedAmt)
                                    : _selectedAmt == a,
                                onTap: () {
                                  if (a == 0) {
                                    _showCustomAmtDialog();
                                  } else {
                                    setState(() {
                                      _selectedAmt = a;
                                      _amtCtrl.text = '$a';
                                    });
                                  }
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    TolButton(label: 'CONTINUER ›', onTap: _next),
                    const SizedBox(height: 20),
                  ],
                ))),
      ]),
    );
  }



  void _showCustomAmtDialog() {
    // Affiche une boîte de dialogue pour saisir un montant personnalisé.
    // Le montant saisi est validé et appliqué au champ principal.
    final ctrl = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text('Montant personnalisé',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w900)),
              content: TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    suffix: Text('FCFA',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary))),
                autofocus: true,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Annuler', style: GoogleFonts.nunito())),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  onPressed: () {
                    final v = int.tryParse(ctrl.text) ?? 0;
                    if (v > 0) {
                      setState(() {
                        _selectedAmt = v;
                        _amtCtrl.text = '$v';
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Valider',
                      style: GoogleFonts.nunito(
                          color: Colors.white, fontWeight: FontWeight.w900)),
                ),
              ],
            ));
  }

  void _next() {
    // Valide les champs et navigue vers l'écran de paiement si tout est ok.
    if (_phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez entrer un numéro', style: GoogleFonts.nunito()),
        backgroundColor: AppColors.red,
      ));
      return;
    }
    // Validation format ivoirien : 10 chiffres (07XXXXXXXX, 05XXXXXXXX, etc.)
    if (_phoneCtrl.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Le numéro doit contenir 10 chiffres', style: GoogleFonts.nunito()),
        backgroundColor: AppColors.red,
      ));
      return;
    }
    if (_selectedAmt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Veuillez entrer un montant', style: GoogleFonts.nunito()),
        backgroundColor: AppColors.red,
      ));
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Step4PaymentScreen(
            operator: widget.operator,
            service: widget.service,
            operation: widget.operation,
            phone: _phoneCtrl.text,
            amount: _selectedAmt,
            onTransactionAdded: widget.onTransactionAdded,
          ),
        ));
  }
}
