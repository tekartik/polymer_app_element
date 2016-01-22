library domready_mixin;

import 'dart:async';

bool _debug= true; int _w;
abstract class DomReadyMixin {

  Completer _whenDomReadyCompleter = new Completer();

  Future get whenDomReady => _whenDomReadyCompleter.future;

  // call base
  domReady() {
    if (_debug) {
      print('$runtimeType domReady');
    }
    _whenDomReadyCompleter.complete();
  }


  // simulate domReady
  attached() {
    if (_debug) {
      print('$runtimeType attached');
    }
    new Future.delayed(new Duration(), domReady);
  }
}

