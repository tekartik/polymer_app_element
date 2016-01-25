@TestOn("browser")
import 'package:dev_test/test.dart';
import 'dart:html';
import 'package:tekartik_app_element/app_prefs.dart';
main() {
  group('AppPrefs', () {
    test('set_get', () {
      String prefix = 'com.tekartik.tekartik_app_element.test.${testDescriptions.join('_')}';
      AppPrefs prefs = new AppPrefs(prefix);
      prefs['test'] = null;
      expect(prefs['test'], null);
      prefs['test1'] = "value1";
      prefs['test2'] = "";
      expect(prefs['test'], null);
      expect(window.localStorage['${prefix}.test'], isNull);
      expect(window.localStorage['${prefix}.test1'], 'value1');
      expect(prefs['test1'], "value1");
      expect(prefs['test2'], "");
      prefs['test2'] = "value2";
      prefs['test1'] = null;
      prefs['test'] = "value";
      expect(prefs['test'], "value");
      expect(prefs['test1'], null);
      expect(prefs['test2'], "value2");

    });
  });

}