import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

part 'src/constants/demo_assets.dart';
part 'src/models/catalog_section.dart';
part 'src/models/example_strings.dart';
part 'src/widgets/catalog_nav.dart';
part 'src/widgets/catalog_category.dart';
part 'src/widgets/example_card.dart';
part 'src/widgets/theme_mode_switch.dart';
part 'src/widgets/token_samples.dart';
part 'src/widgets/panel_mixin_previews.dart';
part 'src/sections/tokens_section.dart';
part 'src/sections/buttons_section.dart';
part 'src/sections/inputs_section.dart';
part 'src/sections/display_section.dart';
part 'src/sections/surfaces_section.dart';
part 'src/sections/navigation_section.dart';
part 'src/sections/panels_section.dart';
part 'src/sections/dialogs_section.dart';
part 'src/sections/avatar_section.dart';
part 'src/sections/feedback_section.dart';
part 'src/sections/recipes_section.dart';
part 'src/sections/composite_section.dart';
part 'src/example_app.dart';
part 'src/example_home.dart';

void main() {
  runApp(const ToastificationWrapper(child: ExampleApp()));
}
