import 'dart:html';

class AppPrefs {
  String _prefix;

  /// _prefix typically a package name com.tekartik.app.dev
  AppPrefs(this._prefix);

  //String get(String key) {}

  String operator [](String key) => _getItem(key);

  void operator []=(String key, String value) {
    _setItem(key, value);
  }

  _getKey(String key) => '${_prefix}.${key}';

  _setItem(String key, String value) {
    try {
      String _key = _getKey(key);
      if (value == null) {
        window.localStorage.remove(_key);
      } else {
        window.localStorage[_key] = value;
      }
    } catch (_) {}
  }

  String _getItem(String key) {
    return window.localStorage[_getKey(key)];
  }
}
