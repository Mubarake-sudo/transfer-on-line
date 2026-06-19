import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'step3_info.dart';

class Step2ServiceScreen extends StatefulWidget {
  final String operator;
  final Function(Transaction) onTransactionAdded;

  const Step2ServiceScreen(
      {super.key, required this.operator, required this.onTransactionAdded});

  @override
  State<Step2ServiceScreen> createState() => _Step2ServiceScreenState();
}

class _Step2ServiceScreenState extends State<Step2ServiceScreen> {
  String _service = 'Internet';
  String _operation = 'Souscription pour moi';

  // ── Services : vraies images depuis assets ──
  final List<Map<String, dynamic>> services = [
    {
      'name': 'Appels',
      'sub': 'Forfaits voix',
      'image': 'assets/images/telephone.png',
      'color': 0xFF00A854,
    },
    {
      'name': 'Internet',
      'sub': 'Forfaits data',
      'image': 'assets/images/internet.png',
      'color': 0xFF1A6AF5,
    },
    {
      'name': 'SMS',
      'sub': 'Forfaits SMS',
      'image': 'assets/images/sms.png',
      'color': 0xFF8B5CF6,
    },
  ];

  // ── Opérations : vraies images depuis assets ──
  final List<Map<String, dynamic>> operations = [
    {
      'name': 'Souscription pour moi',
      'sub': 'Acheter un forfait pour\nmon propre numéro',
      'image': 'assets/images/icône_de souscription.png',
      'color': 0xFF1A6E35,
    },
    {
      'name': 'Souscription pour un tiers',
      'sub': 'Acheter un forfait pour\nun autre numéro',
      'image': 'assets/images/icône de souscription pour un tier.png',
      'color': 0xFF1A6AF5,
    },
    {
      'name': 'Transfert pour moi',
      'sub': 'Transférer un forfait de mon\nnuméro vers un autre',
      'image': 'assets/images/transfert_pour_moi.png',
      'color': 0xFFD97706,
    },
    {
      'name': 'Transfert pour un tiers',
      'sub': 'Transférer un forfait d\'un autre\nnuméro vers un autre',
      'image': 'assets/images/transfert_pour_un_tier.png',
      'color': 0xFF7C3AED,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(children: [
        GreenHeader(
          title: 'Choisir le service',
          subtitle: 'Sélectionnez le type de service\net l\'opération souhaitée',
          icon: '📋',
          step: 2,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. TYPE DE SERVICE ──
                const SectionTitle('1. TYPE DE SERVICE'),
                const SizedBox(height: 10),
                Row(
                  children: services.map((s) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: s == services.last ? 0 : 10),
                        child: _svcTile(s),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 22),

                // ── 2. TYPE D'OPÉRATION ──
                const SectionTitle('2. TYPE D\'OPÉRATION'),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]),
                  child: Column(
                    children: operations.asMap().entries.map((e) {
                      return _opRow(e.value,
                          isLast: e.key == operations.length - 1);
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                TolButton(label: 'CONTINUER', onTap: _next),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  // ── Tuile service (Appels / Internet / SMS) ──
  Widget _svcTile(Map<String, dynamic> s) {
    final sel = _service == s['name'];
    final color = Color(s['color'] as int);
    return GestureDetector(
      onTap: () => setState(() => _service = s['name'] as String),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: sel ? AppColors.success : const Color(0xFFEEEEEE),
            width: sel ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Sticker vert ✓ bien visible sur le bord ──
            if (sel)
              Positioned(
                top: -14,
                right: -10,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Center(
                    child: Icon(Icons.check_rounded,
                        color: Colors.white, size: 13),
                  ),
                ),
              ),
            // ── Contenu ──
            Column(
              children: [
                // Icône dans cercle coloré
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(11),
                    child: Image.asset(
                      s['image'] as String,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.circle, color: color, size: 26),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(s['name'] as String,
                    style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(s['sub'] as String,
                    style: GoogleFonts.nunito(
                        fontSize: 10, color: AppColors.textSecondary),
                    textAlign: TextAlign.center),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Ligne opération ──
  Widget _opRow(Map<String, dynamic> op, {bool isLast = false}) {
    final sel = _operation == op['name'];
    final color = Color(op['color'] as int);
    return GestureDetector(
      onTap: () => setState(() => _operation = op['name'] as String),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFF0F0F0))),
        ),
        child: Row(children: [
          // ── Icône opération (vraie image) ──
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Image.asset(
                op['image'] as String,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.circle, color: color, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(op['name'] as String,
                    style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(op['sub'] as String,
                    style: GoogleFonts.nunito(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.3)),
              ],
            ),
          ),
          // ── Bouton radio ──
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: sel ? AppColors.success : const Color(0xFFCCCCCC),
                width: 2,
              ),
            ),
            child: sel
                ? Container(
                    margin: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: AppColors.success, shape: BoxShape.circle),
                  )
                : null,
          ),
        ]),
      ),
    );
  }

  void _next() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Step3InfoScreen(
          operator: widget.operator,
          service: _service,
          operation: _operation,
          onTransactionAdded: widget.onTransactionAdded,
        ),
      ),
    );
  }
}
