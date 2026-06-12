import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'notifications_screen.dart';
import 'step2_service.dart';

class Step1OperatorScreen extends StatefulWidget {
  final Function(Transaction) onTransactionAdded;
  final String? preselectedOp;

  const Step1OperatorScreen({
    super.key,
    required this.onTransactionAdded,
    this.preselectedOp,
  });

  @override
  State<Step1OperatorScreen> createState() => _Step1OperatorScreenState();
}

class _Step1OperatorScreenState extends State<Step1OperatorScreen> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.preselectedOp;
  }

  final ops = [
    {'name': 'Orange', 'sub': 'Orange CI', 'desc': 'Réseau Orange Côte d\'Ivoire'},
    {'name': 'MTN', 'sub': 'MTN Côte d\'Ivoire', 'desc': 'Réseau MTN Côte d\'Ivoire'},
    {'name': 'Moov', 'sub': 'Moov Africa CI', 'desc': 'Réseau Moov Africa Côte d\'Ivoire'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081F2D),
      body: Column(children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B273F), Color(0xFF07111F)],
            ),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20,
            left: 24,
            right: 24,
            bottom: 20,
          ),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.menu_rounded, color: Colors.white, size: 22),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => NotificationsScreen(
                            notifications: sampleNotifications)),
                  );
                },
                child: Stack(children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.notifications_none_rounded,
                        color: Colors.white, size: 22),
                  ),
                  if (sampleNotifications.where((n) => !n.read).isNotEmpty)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                            color: Color(0xFFEF4444), shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            '${sampleNotifications.where((n) => !n.read).length}',
                            style: GoogleFonts.nunito(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ]),
              ),
            ]),
            const SizedBox(height: 32),
            Text('TRANSFER',
                style: GoogleFonts.nunito(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white)),
            const SizedBox(height: 4),
            Text('ON LINE',
                style: GoogleFonts.nunito(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary)),
            const SizedBox(height: 14),
            Text('Souscrivez ou transférez vos forfaits en toute simplicité',
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _iconBubble(Icons.call_rounded, 'Appels'),
                _iconBubble(Icons.public_rounded, 'Internet'),
                _iconBubble(Icons.message_rounded, 'SMS'),
              ],
            ),
          ]),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Choisissez votre opérateur',
                  style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    ...ops.map((op) => _operatorCard(op)).toList(),
                    const SizedBox(height: 20),
                    TolButton(
                      label: _selected != null
                          ? 'CONTINUER'
                          : 'SÉLECTIONNEZ UN OPÉRATEUR',
                      color: _selected != null ? AppColors.primary : AppColors.textHint,
                      onTap: _selected != null ? _next : () {},
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.lock_rounded,
                              color: AppColors.success, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sécurisé à 100%',
                                  style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text('Vos transactions sont protégées',
                                  style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Text('AFRITECH-CI',
                            style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary)),
                      ]),
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _iconBubble(IconData icon, String label) {
    return Column(children: [
      Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
      const SizedBox(height: 8),
      Text(label,
          style: GoogleFonts.nunito(
              fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white70)),
    ]);
  }

  Widget _operatorCard(Map<String, String> op) {
    final name = op['name']!;
    final isSelected = _selected == name;
    final color = AppColors.operatorColor(name);

    return GestureDetector(
      onTap: () => setState(() => _selected = name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 14,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                name == 'Orange' ? 'o' : name,
                style: GoogleFonts.nunito(
                    fontSize: name == 'MTN' ? 18 : 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(op['sub']!,
                    style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(op['desc']!,
                    style: GoogleFonts.nunito(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Icon(isSelected ? Icons.check_circle_rounded : Icons.arrow_forward_ios_rounded,
              size: 22,
              color: isSelected ? color : AppColors.textHint),
        ]),
      ),
    );
  }

  void _next() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Step2ServiceScreen(
          operator: _selected!,
          onTransactionAdded: widget.onTransactionAdded,
        ),
      ),
    );
  }
}
