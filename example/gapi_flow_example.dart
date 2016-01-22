import 'dart:html';
import 'package:tekartik_google_jsapi/gapi.dart';
import 'package:tekartik_google_jsapi/gapi_auth.dart';

import 'package:polymer/init.dart';
import 'package:tekartik_app_element/gapi_flow.dart';
import 'package:tekartik_app_element/src/base_import.dart';
String storageKeyPref = 'com.tekartik.tekartik_app_element.gapi_flow_example';
dynamic storageGet(String key) {
  return storage['$storageKeyPref.$key'];
}

main() async {
  await initPolymer();
  GapiFlowElement flow = document.body.querySelector('#flow');
  await flow.whenDomReady;

  flow.init().listen((GapiFlow signInEvent) {
    print(signInEvent);
  });
  devPrint('salut');
}

void storageSet(String key, String value) {
  if (value == null) {
    storage.remove('$storageKeyPref.$key');
  } else {
    storage['$storageKeyPref.$key'] = value;
  }
}
Storage storage = window.localStorage;