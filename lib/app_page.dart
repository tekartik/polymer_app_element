import 'element_utils.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:tekartik_googleapis_auth/auth_browser.dart';
import 'dart:html';
import 'src/base_import.dart';
import 'package:googleapis/oauth2/v2.dart';
import 'package:pool/pool.dart';
import 'dom_ready_mixin.dart';
import 'package:polymer_elements/iron_image.dart';

abstract class AppPage extends PolymerElement with DomReadyMixin {
  AppPage.created() : super.created();

  /// Override with proper id
  //String pageId;

  bool activated;

  /// call base
  void onActivate() {
    activated = true;
  }

  /// call base
  void onUnactivate() {
    activated = false;
  }

  @override
  /// needed to call mixin
  attached() {
    super.attached();
  }

}
