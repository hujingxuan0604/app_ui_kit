import 'package:flutter/material.dart';

class UiAvatarOption {
  final String id;
  final ImageProvider image;
  final String? label;

  const UiAvatarOption({required this.id, required this.image, this.label});
}
