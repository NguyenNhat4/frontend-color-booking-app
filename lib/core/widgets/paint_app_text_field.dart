import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/paint_app_colors.dart';

/// Premium Paint App Text Field with Modern Styling
/// Implements glassmorphism design and paint-themed visual elements
class PaintAppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final String? errorText;
  final String? helperText;
  final bool showFocusedBorder;
  final Color? fillColor;
  final bool showShadow;

  const PaintAppTextField({
    Key? key,
    required this.label,
    this.hint,
    this.prefixText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.contentPadding,
    this.errorText,
    this.helperText,
    this.showFocusedBorder = true,
    this.fillColor,
    this.showShadow = true,
  }) : super(key: key);

  @override
  State<PaintAppTextField> createState() => _PaintAppTextFieldState();
}

class _PaintAppTextFieldState extends State<PaintAppTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderColorAnimation;
  late FocusNode _internalFocusNode;

  bool get _isFocused => _internalFocusNode.hasFocus;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _borderColorAnimation = ColorTween(
      begin: PaintAppColors.borderLight,
      end: PaintAppColors.borderFocus,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(PaintAppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    _hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            if (widget.label.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        _hasError
                            ? PaintAppColors.error
                            : _isFocused
                            ? PaintAppColors.primary
                            : PaintAppColors.textSecondary,
                  ),
                ),
              ),
            ],

            // Text Field Container
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow:
                      widget.showShadow
                          ? [
                            BoxShadow(
                              color:
                                  _isFocused
                                      ? PaintAppColors.shadowPrimary
                                      : PaintAppColors.shadowLight,
                              blurRadius: _isFocused ? 12 : 6,
                              offset: const Offset(0, 3),
                            ),
                          ]
                          : null,
                ),
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _internalFocusNode,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: widget.onSubmitted,
                  onTap: widget.onTap,
                  validator: widget.validator,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  maxLength: widget.maxLength,
                  inputFormatters: widget.inputFormatters,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: PaintAppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: PaintAppColors.textTertiary,
                    ),
                    prefixText: widget.prefixText,
                    prefixIcon:
                        widget.prefixIcon != null
                            ? Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 12,
                              ),
                              child: widget.prefixIcon,
                            )
                            : null,
                    suffixIcon:
                        widget.suffixIcon != null
                            ? Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 16,
                              ),
                              child: widget.suffixIcon,
                            )
                            : null,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    contentPadding:
                        widget.contentPadding ??
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                    filled: true,
                    fillColor:
                        widget.fillColor ??
                        (_isFocused
                            ? PaintAppColors.backgroundPrimary
                            : PaintAppColors.backgroundSecondary),

                    // Border Styling
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: PaintAppColors.borderLight,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            _hasError
                                ? PaintAppColors.error
                                : PaintAppColors.borderLight,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder:
                        widget.showFocusedBorder
                            ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color:
                                    _hasError
                                        ? PaintAppColors.error
                                        : _borderColorAnimation.value ??
                                            PaintAppColors.borderFocus,
                                width: 2.0,
                              ),
                            )
                            : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: PaintAppColors.borderLight,
                                width: 1.5,
                              ),
                            ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: PaintAppColors.error,
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: PaintAppColors.error,
                        width: 2.0,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: PaintAppColors.disabled,
                        width: 1.5,
                      ),
                    ),

                    // Remove default error text as we handle it separately
                    errorText: null,
                    counterText: '',
                  ),
                ),
              ),
            ),

            // Helper/Error Text
            if (widget.helperText != null || widget.errorText != null) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.errorText ?? widget.helperText ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                        widget.errorText != null
                            ? PaintAppColors.error
                            : PaintAppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
