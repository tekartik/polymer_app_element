import 'package:polymer/polymer.dart';
import 'src/base_import.dart';
import 'dom_ready_mixin.dart';

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
