import 'dart:html';
import 'package:polymer/init.dart';
import 'package:polymer/polymer.dart';
//import 'package:tekartik_app_element/gapi_flow.dart';
import 'package:tekartik_app_element/src/base_import.dart';
import 'package:tekartik_app_element/element_utils.dart';
import 'package:polymer_elements/paper_menu.dart';

out(String msg) {
  outElement.appendText('$msg\n');
}

PreElement outElement;
StreamSubscription subscription1;
StreamSubscription subscription2;
StreamSubscription subscription3;
main() async {
  await initPolymer();

  PaperMenu menu = document.body.querySelector('#p_menu');
  outElement = document.body.querySelector('#p_out');

  _toogleSubscription() {
    if (subscription1 == null) {
      // iron activate
      subscription1 = menu.on['iron-activate'].listen((Event e) {
        out('iron-activate ${e} ${(convertToDart(e) as CustomEvent).detail}');
      });

      subscription2 = menu.on['iron-select'].listen((Event e) {
        out('iron-select ${e} ${(convertToDart(e) as CustomEvent).detail}');
      });

      subscription3 = onIronActivate(menu).listen((CustomEvent e) {
        out('onIronActivate ${e.detail}');
        if (e.detail['selected'] == 2) {
          e.preventDefault();
        }
      });
    } else {
      out('cancelling subscription');
      subscription1.cancel();
      subscription2.cancel();
      subscription3.cancel();
      subscription1 = null;
    }
  }
  _toogleSubscription();
  menu.select('0');
  document.body.querySelector('#p_button').on['tap'].listen((_) {
    _toogleSubscription();
  });
}
