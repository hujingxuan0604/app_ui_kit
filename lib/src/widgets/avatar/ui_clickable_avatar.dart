import 'package:flutter/material.dart';

import '../../theme/ui_theme_data.dart';
import '../../tokens/ui_radii.dart';
import 'ui_avatar.dart';

class UiClickableAvatar extends StatelessWidget {
  final ImageProvider? image;
  final String? label;
  final double size;
  final VoidCallback? onTap;
  final UiAvatarShape shape;
  final double? borderRadius;

  const UiClickableAvatar({
    super.key,
    this.image,
    this.label,
    this.size = 36,
    this.onTap,
    this.shape = UiAvatarShape.circle,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.uiTheme;
    return InkWell(
      customBorder: _tapBorder,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          UiAvatar(
            image: image,
            label: label,
            size: size,
            shape: shape,
            borderRadius: borderRadius,
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: size * 0.34,
              height: size * 0.34,
              decoration: BoxDecoration(
                color: theme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: theme.surface, width: 2),
              ),
              child: Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: size * 0.18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ShapeBorder get _tapBorder {
    if (shape == UiAvatarShape.circle) {
      return const CircleBorder();
    }
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? UiRadii.lg),
    );
  }
}
