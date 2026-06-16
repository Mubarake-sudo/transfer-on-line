import 'package:flutter/material.dart';
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
    {
      'name': 'Orange',
      'sub': 'Orange CI',
      'desc': 'Réseau Orange Côte d\'Ivoire'
    },
    {
      'name': 'MTN',
      'sub': 'MTN Côte d\'Ivoire',
      'desc': 'Réseau MTN Côte d\'Ivoire'
    },
    {
      'name': 'Moov',
      'sub': 'Moov Africa CI',
      'desc': 'Réseau Moov Africa Côte d\'Ivoire'
    },
  ];

  static const _orangeColor = Color(0xFFFF6600);
  static const _mtnColor = Color(0xFFFFCC00);
  static const _moovColor = Color(0xFF0066CC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF011627), Color(0xFF000F08)],
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -60,
            right: -60,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00E676).withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NotificationsScreen(
                                    notifications: sampleNotifications),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Text(
                              '${sampleNotifications.where((n) => !n.read).length}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.refresh, color: Color(0xFFFF6600), size: 40),
                    ],
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      const TextSpan(
                        text: 'TRANSFER\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'ON LINE',
                        style: TextStyle(
                          color: const Color(0xFF00E676),
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Souscrivez ou transférez\nvos forfaits en toute simplicité',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white70, fontSize: 16, height: 1.3),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCircularActionButton(Icons.phone),
                      const SizedBox(width: 20),
                      _buildCircularActionButton(Icons.language),
                      const SizedBox(width: 20),
                      _buildCircularActionButton(Icons.chat_bubble),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    'Choisissez votre opérateur',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  _buildOperatorButton(
                    label: 'Orange',
                    color: _orangeColor,
                    logoPath: 'assets/images/orange.png',
                    onTap: () => setState(() => _selected = 'Orange'),
                  ),
                  const SizedBox(height: 16),
                  _buildOperatorButton(
                    label: 'MTN',
                    color: _mtnColor,
                    logoPath: 'assets/images/mtn.png',
                    onTap: () => setState(() => _selected = 'MTN'),
                  ),
                  const SizedBox(height: 16),
                  _buildOperatorButton(
                    label: 'Moov',
                    color: _moovColor,
                    logoPath: 'assets/images/moov.png',
                    onTap: () => setState(() => _selected = 'Moov'),
                  ),
                  const SizedBox(height: 24),
                  TolButton(
                    label: _selected != null
                        ? 'CONTINUER'
                        : 'SÉLECTIONNEZ UN OPÉRATEUR',
                    color: _selected != null
                        ? AppColors.primary
                        : const Color(0xFFB5B5B5),
                    onTap: _selected != null ? _next : null,
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.lock_outline,
                          color: Colors.greenAccent, size: 18),
                      SizedBox(width: 8),
                      Text('Sécurisé à 100%',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Vos transactions sont protégées',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle_outline,
                          color: Colors.greenAccent, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'AFRITECH-CI',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 1.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularActionButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0E3A2F),
        border:
            Border.all(color: Colors.greenAccent.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }

  Widget _opLogo(String op) {
    final key = op.toLowerCase();
    final assetPath = 'assets/images/$key.png';
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        assetPath,
        width: 38,
        height: 38,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Center(
          child: Text(
            op,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w900, color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildOperatorButton({
    required String label,
    required Color color,
    required String logoPath,
    required VoidCallback onTap,
  }) {
    final isSelected = _selected == label;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _opLogo(label),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
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
