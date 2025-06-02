import 'package:flutter/material.dart';

/// Paint App Color System - Professional Premium Paint-Centric Design
/// Based on design philosophy: Paint-centric, Professional Premium, Trust & Reliability
class PaintAppColors {
  // Private constructor to prevent instantiation
  PaintAppColors._();

  // ======================
  // PRIMARY BRAND COLORS
  // ======================

  /// Deep, rich blue for trust and reliability
  static const Color primaryBlue = Color(0xFF1E3A8A);

  /// Warm gray for sophisticated professional look
  static const Color primaryWarm = Color(0xFF374151);

  /// Primary color (main brand color)
  static const Color primary = primaryBlue;

  // ======================
  // PAINT-SPECIFIC COLORS
  // ======================

  /// Vibrant red for paint visualization
  static const Color paintRed = Color(0xFFDC2626);

  /// Forest green for success states and completed visualizations
  static const Color paintGreen = Color(0xFF059669);

  /// Warm amber for important actions and warnings
  static const Color paintYellow = Color(0xFFF59E0B);

  /// Professional purple for premium features
  static const Color paintPurple = Color(0xFF7C3AED);

  /// Elegant teal for accents
  static const Color paintTeal = Color(0xFF0891B2);

  // ======================
  // UI BACKGROUND COLORS
  // ======================

  /// Clean white with subtle warm tint
  static const Color backgroundPrimary = Color(0xFFFEFEFE);

  /// Subtle warm background for cards
  static const Color backgroundSecondary = Color(0xFFFAFAFA);

  /// Light gray for subtle divisions
  static const Color backgroundTertiary = Color(0xFFF8FAFC);

  /// Very light blue-gray for sections
  static const Color backgroundAccent = Color(0xFFF1F5F9);

  // ======================
  // TEXT COLORS
  // ======================

  /// Primary text color - deep charcoal
  static const Color textPrimary = Color(0xFF111827);

  /// Secondary text color - medium gray
  static const Color textSecondary = Color(0xFF6B7280);

  /// Tertiary text color - light gray
  static const Color textTertiary = Color(0xFF9CA3AF);

  /// Inverse text for dark backgrounds
  static const Color textInverse = Color(0xFFFFFFFF);

  // ======================
  // SEMANTIC COLORS
  // ======================

  /// Success color - forest green
  static const Color success = paintGreen;

  /// Warning color - warm amber
  static const Color warning = paintYellow;

  /// Error color - vibrant red
  static const Color error = paintRed;

  /// Info color - primary blue
  static const Color info = primaryBlue;

  // ======================
  // SURFACE COLORS
  // ======================

  /// White surface
  static const Color surface = Color(0xFFFFFFFF);

  /// Light surface with subtle tint
  static const Color surfaceLight = Color(0xFFFCFCFC);

  /// Card surface color
  static const Color surfaceCard = Color(0xFFFFFFFF);

  /// Elevated surface color
  static const Color surfaceElevated = Color(0xFFFFFFFF);

  // ======================
  // BORDER COLORS
  // ======================

  /// Light border color
  static const Color borderLight = Color(0xFFE5E7EB);

  /// Medium border color
  static const Color borderMedium = Color(0xFFD1D5DB);

  /// Dark border color
  static const Color borderDark = Color(0xFF9CA3AF);

  /// Focus border color
  static const Color borderFocus = primaryBlue;

  // ======================
  // GRADIENT DEFINITIONS
  // ======================

  /// Primary gradient for premium feel
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, Color(0xFF2563EB)],
  );

  /// Warm gradient for welcoming screens
  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFEFEFE), Color(0xFFF8FAFC)],
  );

  /// Paint gradient for visualization features
  static const LinearGradient paintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [paintTeal, paintPurple],
  );

  /// Glassmorphism gradient for modern cards
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x40FFFFFF), Color(0x20FFFFFF)],
  );

  // ======================
  // SHADOW COLORS
  // ======================

  /// Light shadow
  static const Color shadowLight = Color(0x0A000000);

  /// Medium shadow
  static const Color shadowMedium = Color(0x14000000);

  /// Dark shadow
  static const Color shadowDark = Color(0x1F000000);

  /// Colored shadow for primary elements
  static Color shadowPrimary = primaryBlue.withValues(alpha: 0.15);

  // ======================
  // INTERACTION COLORS
  // ======================

  /// Hover state color
  static Color hover = primaryBlue.withValues(alpha: 0.08);

  /// Pressed state color
  static Color pressed = primaryBlue.withValues(alpha: 0.12);

  /// Focus state color
  static Color focus = primaryBlue.withValues(alpha: 0.16);

  /// Disabled color
  static const Color disabled = Color(0xFFE5E7EB);

  /// Disabled text color
  static const Color disabledText = Color(0xFFD1D5DB);

  // ======================
  // HELPER METHODS
  // ======================

  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Get darker shade of a color
  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Get lighter shade of a color
  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Get color for different user types
  static Color getUserTypeColor(String userType) {
    switch (userType.toLowerCase()) {
      case 'contractor':
        return paintYellow;
      case 'homeowner':
        return paintGreen;
      case 'company':
        return paintPurple;
      case 'regular':
      default:
        return primaryBlue;
    }
  }

  /// Get gradient for different user types
  static LinearGradient getUserTypeGradient(String userType) {
    final color = getUserTypeColor(userType);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, lighten(color, 0.1)],
    );
  }
}
