import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class OperatorSelectionPage extends StatefulWidget {
  const OperatorSelectionPage({super.key});

  @override
  State<OperatorSelectionPage> createState() => _OperatorSelectionPageState();
}

class _OperatorSelectionPageState extends State<OperatorSelectionPage>
    with TickerProviderStateMixin {
  late AnimationController _rotateCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _waveCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    _pulseCtrl.dispose();
    _waveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF061A0E),
      body: Stack(
        children: [
          // Animated wave background
          AnimatedBuilder(
            animation: _waveCtrl,
            builder: (_, __) => CustomPaint(
              painter: _WavePainter(_waveCtrl.value),
              size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Notification button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, right: 16),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                          ),
                          child: const Icon(Icons.notifications_outlined, color: Color(0xFF1A1A1A), size: 22),
                        ),
                        Positioned(
                          top: -4, right: -4,
                          child: Container(
                            width: 18, height: 18,
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            child: Center(child: Text('3', style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Animated Logo
                AnimatedBuilder(
                  animation: _rotateCtrl,
                  builder: (_, __) => SizedBox(
                    width: 90, height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer ring orange
                        Transform.rotate(
                          angle: _rotateCtrl.value * 2 * math.pi,
                          child: CustomPaint(painter: _ArcPainter(const Color(0xFFFF6B00), 0.7), size: const Size(90, 90)),
                        ),
                        // Inner ring green
                        Transform.rotate(
                          angle: -_rotateCtrl.value * 2 * math.pi,
                          child: CustomPaint(painter: _ArcPainter(const Color(0xFF00C853), 0.6), size: const Size(70, 70)),
                        ),
                        Container(
                          width: 50, height: 50,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.swap_horiz_rounded, color: Color(0xFF1A6E35), size: 26),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(text: 'TRANSFER\n', style: GoogleFonts.nunito(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1, letterSpacing: -1)),
                    TextSpan(text: 'ON LINE', style: GoogleFonts.nunito(fontSize: 36, fontWeight: FontWeight.w900, color: const Color(0xFF00E05A), height: 1.1, letterSpacing: -1)),
                  ]),
                ),

                const SizedBox(height: 10),

                Text(
                  'Souscrivez ou transférez\nvos forfaits en toute simplicité',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(fontSize: 14, color: Colors.white60, height: 1.5),
                ),

                const SizedBox(height: 24),

                // Service icons with glow
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _glowIcon(Icons.phone_rounded, const Color(0xFF00C853)),
                    const SizedBox(width: 28),
                    _glowIcon(Icons.language_rounded, const Color(0xFF00C853)),
                    const SizedBox(width: 28),
                    _glowIcon(Icons.message_rounded, const Color(0xFF00C853)),
                  ],
                ),

                const SizedBox(height: 28),

                Text('Choisissez votre opérateur',
                  style: GoogleFonts.nunito(fontSize: 14, color: Colors.white60, fontWeight: FontWeight.w600)),

                const SizedBox(height: 14),

                // Operator buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    _opButton(
                      name: 'Orange',
                      gradient: const [Color(0xFFE55A00), Color(0xFFFF7A1A)],
                      logo: _OrangeLogo(),
                    ),
                    const SizedBox(height: 12),
                    _opButton(
                      name: 'MTN',
                      gradient: const [Color(0xFFC7960A), Color(0xFFF5C400)],
                      logo: _MTNLogo(),
                    ),
                    const SizedBox(height: 12),
                    _opButton(
                      name: 'Moov',
                      gradient: const [Color(0xFF0048C8), Color(0xFF1A6AF5)],
                      logo: _MoovLogo(),
                    ),
                  ]),
                ),

                const Spacer(),

                // Secure badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shield_rounded, color: Color(0xFF00C853), size: 16),
                    const SizedBox(width: 6),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Sécurisé à 100%', style: GoogleFonts.nunito(fontSize: 12, color: Colors.white60, fontWeight: FontWeight.w700)),
                      Text('Vos transactions sont protégées', style: GoogleFonts.nunito(fontSize: 10, color: Colors.white38)),
                    ]),
                  ],
                ),

                const SizedBox(height: 12),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.verified_rounded, color: Color(0xFF00C853), size: 14),
                  const SizedBox(width: 4),
                  Text('AFRITECH-CI', style: GoogleFonts.nunito(fontSize: 11, color: const Color(0xFF00C853), fontWeight: FontWeight.w800, letterSpacing: 2)),
                ]),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowIcon(IconData icon, Color color) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (_, __) => Container(
        width: 52, height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.15 + _pulseCtrl.value * 0.1),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3 + _pulseCtrl.value * 0.2), blurRadius: 12 + _pulseCtrl.value * 8, spreadRadius: 1)],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _opButton({required String name, required List<Color> gradient, required Widget logo}) {
    return GestureDetector(
      onTap: () {
        // Navigate to step 2
      },
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient, begin: Alignment.centerLeft, end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: gradient.first.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(children: [
          const SizedBox(width: 10),
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Center(child: logo),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(name, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white))),
          const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 28),
          const SizedBox(width: 12),
        ]),
      ),
    );
  }
}

// ─── Custom Logo Widgets ──────────────────────────────────────────────────────

class _OrangeLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38, height: 38,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE55A00), width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text('orange', style: GoogleFonts.nunito(fontSize: 9, fontWeight: FontWeight.w900, color: const Color(0xFFE55A00))),
      ),
    );
  }
}

class _MTNLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42, height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFFF5C400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text('MTN', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF1A1A1A))),
      ),
    );
  }
}

class _MoovLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Moov', style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFF0048C8))),
        Text('Africa', style: GoogleFonts.nunito(fontSize: 8, fontWeight: FontWeight.w700, color: const Color(0xFF0048C8))),
      ],
    );
  }
}

// ─── Custom Painters ──────────────────────────────────────────────────────────

class _ArcPainter extends CustomPainter {
  final Color color;
  final double fraction;
  _ArcPainter(this.color, this.fraction);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width, height: size.height),
      0, 2 * math.pi * fraction, false, paint,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}

class _WavePainter extends CustomPainter {
  final double t;
  _WavePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00C853).withOpacity(0.06)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      final path = Path();
      path.moveTo(0, size.height * 0.5);
      for (double x = 0; x <= size.width; x++) {
        final y = size.height * 0.55 +
            math.sin((x / size.width * 2 * math.pi) + t * 2 * math.pi + i * 0.8) * size.height * 0.08;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint..color = const Color(0xFF00C853).withOpacity(0.04 + i * 0.02));
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
