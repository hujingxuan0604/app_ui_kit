import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';

enum UiAvatarShape { circle, square }

class UiAvatar extends StatelessWidget {
  final ImageProvider? image;
  final String? label;
  final double size;
  final Widget? placeholder;
  final UiAvatarShape shape;
  final double? borderRadius;

  const UiAvatar({
    super.key,
    this.image,
    this.label,
    this.size = 36,
    this.placeholder,
    this.shape = UiAvatarShape.circle,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    final normalizedLabel = label?.trim() ?? '';
    final initials = normalizedLabel.isEmpty
        ? ''
        : String.fromCharCode(normalizedLabel.runes.first).toUpperCase();
    final radius = shape == UiAvatarShape.circle
        ? BorderRadius.circular(size / 2)
        : BorderRadius.circular(borderRadius ?? UiRadii.lg);

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: 0.14),
          image: image == null
              ? null
              : DecorationImage(image: image!, fit: BoxFit.cover),
        ),
        child: image == null
            ? IconTheme.merge(
                data: IconThemeData(color: theme.primary, size: size * 0.46),
                child:
                    placeholder ??
                    Text(
                      initials,
                      style: TextStyle(
                        color: theme.primary,
                        fontSize: size * 0.38,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              )
            : null,
      ),
    );
  }
}
