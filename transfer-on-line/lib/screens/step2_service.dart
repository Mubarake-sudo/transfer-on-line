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

  final services = [
    {
      'name': 'Appels',
      'sub': 'Forfaits voix',
      'icon': '📞',
      'color': 0xFF00A854
    },
    {
      'name': 'Internet',
      'sub': 'Forfaits data',
      'icon': '🌐',
      'color': 0xFF1A6AF5
    },
    {'name': 'SMS', 'sub': 'Forfaits SMS', 'icon': '💬', 'color': 0xFF8B5CF6},
  ];

  final operations = [
    {
      'name': 'Souscription pour moi',
      'sub': 'Acheter un forfait pour mon propre numéro',
      'icon': '📋',
      'color': 0xFF1A6E35
    },
    {
      'name': 'Souscription pour un tiers',
      'sub': 'Acheter un forfait pour un autre numéro',
      'icon': '👤',
      'color': 0xFF1A6AF5
    },
    {
      'name': 'Transfert pour moi',
      'sub': 'Transférer un forfait de mon numéro vers un autre',
      'icon': '🔄',
      'color': 0xFFD97706
    },
    {
      'name': 'Transfert pour un tiers',
      'sub': 'Transférer un forfait d\'un autre numéro vers un autre',
      'icon': '👥',
      'color': 0xFF7C3AED
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000F08),
      body: Column(children: [
        GreenHeader(
            title: 'Choisir le service',
            subtitle:
                'Sélectionnez le type de service et l’opération souhaitée',
            icon: '📋',
            step: 2),
        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('1. Type de service'),
                    Row(
                        children: services
                            .map((s) => Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.only(
                                      right: s == services.last ? 0 : 8),
                                  child: _svcTile(s),
                                )))
                            .toList()),
                    const SizedBox(height: 20),
                    const SectionTitle('2. Type d\'opération'),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFF08110A),
                          borderRadius: BorderRadius.circular(14)),
                      child: Column(
                          children: operations
                              .asMap()
                              .entries
                              .map((e) => _opRow(e.value,
                                  isLast: e.key == operations.length - 1))
                              .toList()),
                    ),
                    const SizedBox(height: 16),
                    TolButton(label: 'CONTINUER', onTap: _next),
                    const SizedBox(height: 20),
                  ],
                ))),
      ]),
    );
  }

  Widget _svcTile(Map<String, dynamic> s) {
    final sel = _service == s['name'];
    final color = Color(s['color'] as int);
    return GestureDetector(
      onTap: () => setState(() => _service = s['name']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: sel ? AppColors.success : Colors.transparent, width: 2),
        ),
        child: Stack(children: [
          if (sel)
            Positioned(
                top: -8,
                right: -8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: AppColors.success, shape: BoxShape.circle),
                  child: const Center(
                      child: Text('✓',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900))),
                )),
          Column(children: [
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.15), shape: BoxShape.circle),
                child: Center(
                    child:
                        Text(s['icon'], style: const TextStyle(fontSize: 20)))),
            const SizedBox(height: 6),
            Text(s['name'],
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white)),
            Text(s['sub'],
                style: GoogleFonts.nunito(fontSize: 9, color: Colors.white70),
                textAlign: TextAlign.center),
          ]),
        ]),
      ),
    );
  }

  Widget _opRow(Map<String, dynamic> op, {bool isLast = false}) {
    final sel = _operation == op['name'];
    final color = Color(op['color'] as int);
    return GestureDetector(
      onTap: () => setState(() => _operation = op['name']),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
            border: isLast
                ? null
                : const Border(bottom: BorderSide(color: Color(0xFFF5F5F5)))),
        child: Row(children: [
          Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(11)),
              child: Center(
                  child:
                      Text(op['icon'], style: const TextStyle(fontSize: 18)))),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(op['name'],
                    style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                const SizedBox(height: 2),
                Text(op['sub'],
                    style: GoogleFonts.nunito(
                        fontSize: 11, color: Colors.white70, height: 1.3)),
              ])),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: sel ? AppColors.success : Colors.white12, width: 2),
            ),
            child: sel
                ? Container(
                    margin: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: AppColors.success, shape: BoxShape.circle))
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
        ));
  }
}
