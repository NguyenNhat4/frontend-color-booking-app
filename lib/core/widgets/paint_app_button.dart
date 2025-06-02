import 'package:flutter/material.dart';
import '../theme/paint_app_colors.dart';

/// Premium Paint App Button with Modern Styling
/// Implements paint-themed design with animations and multiple variants
class PaintAppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final PaintAppButtonVariant variant;
  final PaintAppButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? customShadow;
  final Gradient? customGradient;
  final Color? customColor;
  final TextStyle? customTextStyle;

  const PaintAppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.variant = PaintAppButtonVariant.primary,
    this.size = PaintAppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
    this.customShadow,
    this.customGradient,
    this.customColor,
    this.customTextStyle,
  }) : super(key: key);

  @override
  State<PaintAppButton> createState() => _PaintAppButtonState();
}

class _PaintAppButtonState extends State<PaintAppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _shadowAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.isFullWidth ? double.infinity : null,
              padding: widget.padding ?? _getPadding(),
              decoration: BoxDecoration(
                gradient: _getGradient(),
                color:
                    widget.variant == PaintAppButtonVariant.ghost
                        ? Colors.transparent
                        : widget.customColor,
                borderRadius:
                    widget.borderRadius ??
                    BorderRadius.circular(_getBorderRadius()),
                border: _getBorder(),
                boxShadow:
                    isEnabled
                        ? (widget.customShadow ?? _getShadow())
                            .map(
                              (shadow) => shadow.scale(_shadowAnimation.value),
                            )
                            .toList()
                        : null,
              ),
              child: Row(
                mainAxisSize:
                    widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null && !widget.isLoading) ...[
                    widget.icon!,
                    const SizedBox(width: 8),
                  ],

                  if (widget.isLoading) ...[
                    SizedBox(
                      width: _getLoadingSize(),
                      height: _getLoadingSize(),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTextColor(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  Text(
                    widget.isLoading ? 'Loading...' : widget.text,
                    style: widget.customTextStyle ?? _getTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (widget.size) {
      case PaintAppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case PaintAppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case PaintAppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getBorderRadius() {
    switch (widget.size) {
      case PaintAppButtonSize.small:
        return 8;
      case PaintAppButtonSize.medium:
        return 12;
      case PaintAppButtonSize.large:
        return 16;
    }
  }

  double _getLoadingSize() {
    switch (widget.size) {
      case PaintAppButtonSize.small:
        return 14;
      case PaintAppButtonSize.medium:
        return 16;
      case PaintAppButtonSize.large:
        return 18;
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = TextStyle(
      color: _getTextColor(),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );

    switch (widget.size) {
      case PaintAppButtonSize.small:
        return baseStyle.copyWith(fontSize: 14);
      case PaintAppButtonSize.medium:
        return baseStyle.copyWith(fontSize: 16);
      case PaintAppButtonSize.large:
        return baseStyle.copyWith(fontSize: 18);
    }
  }

  Color _getTextColor() {
    if (widget.onPressed == null) {
      return PaintAppColors.disabledText;
    }

    switch (widget.variant) {
      case PaintAppButtonVariant.primary:
        return PaintAppColors.textInverse;
      case PaintAppButtonVariant.secondary:
        return PaintAppColors.primary;
      case PaintAppButtonVariant.outline:
        return PaintAppColors.primary;
      case PaintAppButtonVariant.ghost:
        return PaintAppColors.primary;
      case PaintAppButtonVariant.success:
        return PaintAppColors.textInverse;
      case PaintAppButtonVariant.warning:
        return PaintAppColors.textInverse;
      case PaintAppButtonVariant.error:
        return PaintAppColors.textInverse;
    }
  }

  Gradient? _getGradient() {
    if (widget.customGradient != null) {
      return widget.customGradient;
    }

    if (widget.onPressed == null) {
      return null;
    }

    switch (widget.variant) {
      case PaintAppButtonVariant.primary:
        return PaintAppColors.primaryGradient;
      case PaintAppButtonVariant.success:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PaintAppColors.paintGreen,
            PaintAppColors.lighten(PaintAppColors.paintGreen, 0.1),
          ],
        );
      case PaintAppButtonVariant.warning:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PaintAppColors.paintYellow,
            PaintAppColors.lighten(PaintAppColors.paintYellow, 0.1),
          ],
        );
      case PaintAppButtonVariant.error:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PaintAppColors.paintRed,
            PaintAppColors.lighten(PaintAppColors.paintRed, 0.1),
          ],
        );
      default:
        return null;
    }
  }

  Border? _getBorder() {
    if (widget.onPressed == null) {
      return Border.all(color: PaintAppColors.disabled, width: 1.5);
    }

    switch (widget.variant) {
      case PaintAppButtonVariant.outline:
        return Border.all(color: PaintAppColors.primary, width: 1.5);
      case PaintAppButtonVariant.ghost:
        return _isPressed
            ? Border.all(
              color: PaintAppColors.primary.withOpacity(0.3),
              width: 1.5,
            )
            : null;
      default:
        return null;
    }
  }

  List<BoxShadow> _getShadow() {
    switch (widget.variant) {
      case PaintAppButtonVariant.primary:
        return [
          BoxShadow(
            color: PaintAppColors.shadowPrimary,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
      case PaintAppButtonVariant.secondary:
        return [
          BoxShadow(
            color: PaintAppColors.shadowMedium,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ];
      case PaintAppButtonVariant.success:
        return [
          BoxShadow(
            color: PaintAppColors.paintGreen.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
      case PaintAppButtonVariant.warning:
        return [
          BoxShadow(
            color: PaintAppColors.paintYellow.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
      case PaintAppButtonVariant.error:
        return [
          BoxShadow(
            color: PaintAppColors.paintRed.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
      default:
        return [
          BoxShadow(
            color: PaintAppColors.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ];
    }
  }
}

/// Paint App Button Variants
enum PaintAppButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  success,
  warning,
  error,
}

/// Paint App Button Sizes
enum PaintAppButtonSize { small, medium, large }
