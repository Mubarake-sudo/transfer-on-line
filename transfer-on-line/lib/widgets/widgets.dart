import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// Composants réutilisables de l'application (boutons, cartes, badges,
// barres de progression). Les commentaires aident à repérer leur rôle.

// ─── Step Progress Bar ───────────────────────────────────────────────────────
class StepProgressBar extends StatelessWidget {
  final int currentStep;
  const StepProgressBar({super.key, required this.currentStep});

  static const steps = ['Opérateur', 'Service', 'Informations', 'Paiement'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final lineStep = (i ~/ 2) + 1;
          return Expanded(
            child: Container(
              height: 2,
              color:
                  lineStep < currentStep ? AppColors.success : Colors.white24,
            ),
          );
        }
        final step = i ~/ 2 + 1;
        final isDone = step < currentStep;
        final isActive = step == currentStep;
        return Column(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? Colors.white24
                    : isActive
                        ? AppColors.success
                        : Colors.transparent,
                border: Border.all(
                  color: isDone || isActive ? Colors.white54 : Colors.white24,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  isDone ? '✓' : '$step',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isDone || isActive ? Colors.white : Colors.white38,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              steps[i ~/ 2],
              style: GoogleFonts.nunito(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : Colors.white38,
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ─── Green Header ─────────────────────────────────────────────────────────────
class GreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final int step;
  final bool showBack;
  final VoidCallback? onBack;

  const GreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.step,
    this.showBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D5C2C), Color(0xFF1A7A3C)],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (showBack)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: onBack ?? () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                    child: Text(icon,
                        style: const TextStyle(
                            fontSize: 24, color: Color(0xFF1A6E35)))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title,
              style: GoogleFonts.nunito(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: GoogleFonts.nunito(
                  fontSize: 13, color: Colors.white.withOpacity(0.85)),
              textAlign: TextAlign.center),
          const SizedBox(height: 18),
          StepProgressBar(currentStep: step),
        ],
      ),
    );
  }
}

// ─── TOL Button ───────────────────────────────────────────────────────────────
class TolButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final bool loading;

  const TolButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : Text(label,
                style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white)),
      ),
    );
  }
}

// ─── TOL Card ─────────────────────────────────────────────────────────────────
class TolCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const TolCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

// ─── Section Title ────────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.nunito(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: AppColors.textSecondary,
            letterSpacing: 0.8),
      ),
    );
  }
}

// ─── Transaction Status Badge ─────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final isOk = status == 'ok';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOk ? AppColors.primaryLight : AppColors.redLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOk ? 'Réussie' : 'Échouée',
        style: GoogleFonts.nunito(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: isOk ? AppColors.primary : AppColors.red,
        ),
      ),
    );
  }
}

// ─── Quick Amount Button ──────────────────────────────────────────────────────
class QuickAmountButton extends StatelessWidget {
  final int amount;
  final bool selected;
  final VoidCallback onTap;

  const QuickAmountButton(
      {super.key,
      required this.amount,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 2),
        ),
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Column(
          children: [
            Text(
              amount == 0 ? 'Autre' : _fmt(amount),
              style: GoogleFonts.nunito(
                fontSize: amount == 0 ? 12 : 14,
                fontWeight: FontWeight.w900,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (amount != 0)
              Text('FCFA',
                  style: GoogleFonts.nunito(
                      fontSize: 10,
                      color: selected ? Colors.white70 : AppColors.textHint)),
            if (amount == 0)
              Text('montant',
                  style: GoogleFonts.nunito(
                      fontSize: 10,
                      color: selected ? Colors.white70 : AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  String _fmt(int n) => n >= 1000
      ? '${n ~/ 1000} ${n % 1000 == 0 ? "" : (n % 1000).toString().padLeft(3, "0")} '
              .trim() +
          (n >= 1000 ? ' 000' : '')
      : '$n';
}
