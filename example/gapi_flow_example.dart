import 'dart:html';
import 'package:polymer/init.dart';
import 'package:tekartik_app_element/gapi_flow.dart';
import 'package:tekartik_app_element/src/base_import.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:quiver/strings.dart';

String storageKeyPref = 'com.tekartik.tekartik_app_element.gapi_flow_example';
dynamic storageGet(String key) {
  return storage['$storageKeyPref.$key'];
}

String clientId;
String userId;
List<String> scopes;
GapiFlowElement flow;
PaperInput clientIdInput;

_init() {
  if (clientId != null) {
    flow.init(clientId: clientId, initialUserId: userId).listen((GapiFlowEvent event) {
      if (event.userInfo != null) {
        userId = event.userInfo.id;
        storageSet('userId', userId);
      } else {
        userId = null;
        storageSet('userId', null);
      }
    });
  }
}
main() async {
  await initPolymer();
  flow = document.body.querySelector('#flow');
  await flow.whenDomReady;

  clientIdInput = document.body.querySelector('#p_client_id');
  clientId = storageGet('clientId');
  if (clientId != null) {
    clientIdInput.value = clientId;
  }
  userId = storageGet('userId');
  _init();
  clientIdInput.onChange.listen((_) {
    String value = clientIdInput.value.trim();
    print(value);
    storageSet('clientId', emptyToNull(value));
    _init();

  });
}

void storageSet(String key, String value) {
  if (value == null) {
    storage.remove('$storageKeyPref.$key');
  } else {
    storage['$storageKeyPref.$key'] = value;
  }
}
Storage storage = window.localStorage;