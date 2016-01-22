// Copyright (c) {{year}}, {{author}}. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('gapi_flow.html')
library tekartik_mdlistpad.user_page;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:tekartik_googleapis_auth/auth_browser.dart';
import 'dart:html';
import 'src/base_import.dart';
import 'package:googleapis/plus/v1.dart';
import 'package:pool/pool.dart';
import 'dom_ready_mixin.dart';

class GapiFlow {
  // non null means connected
  AuthClient client;
//  DbUser user;


  @override
  String toString() => "signin event: ${client}";

}

@PolymerRegister('tk-gapi-flow')
class GapiFlowElement extends PolymerElement with DomReadyMixin {
  /// Constructor used to create instance of MainApp.
  GapiFlowElement.created() : super.created() {
    print("GapiFlowElement.created");
  }

  Element userNameElement;
  Element userIdElement;
  PaperButton signInButton;

  //@property String scopes = "https://www.googleapis.com/auth/drive.appdata";

  Element contentSignInButton;

  List<String> _scopes = ["profile"];

  String get clientId => _clientId;

  // lazily initialized  = "124267391961.apps.googleusercontent.com";

  String _clientId;
  bool signInSetup = false;

  Pool flowPool = new Pool(1);

  // Make sure we create the flow twice
  Future<BrowserOAuth2Flow> createFlow(String clientId) async {
    return flowPool.withResource(() async {
      if (flow == null) {
        flow = await createImplicitBrowserFlow(
            new ClientId(clientId, null), _scopes);
        //scopes.split(" "));

        // init buttons if needed
        /*
    if (signInButton == null) {
      signInButton.attributes.remove("disabled");
    }
    */
        return flow;
      }
    });
  }

  // to set first
  set clientId(String clientId) {
    //_clientId = clientId;
    set("_clientId", clientId);
    _clientId = clientId;
    print("»»» ${this.clientId}/${clientId}");

    // create the flow as soon as we have a clientId
    createFlow(clientId);
  }

  //DbUser user;
  AuthClient authClient;

  StreamController<GapiFlow> _onSignInController;

  // do second
  Stream<GapiFlow> get onSignIn {
    _onSignInController = new StreamController();
    return _onSignInController.stream;
  }

  Stream<GapiFlow> init({String clientId, List<String> scopes, String initialUserId}) {
    _onSignInController = new StreamController();

    if (scopes != null) {
      _scopes = scopes;
    }
    whenDomReady.then((_) {
      createFlow(clientId).then((_) async {
        if (contentSignInButton != null) {
          contentSignInButton.attributes.remove('disabled');
          contentSignInButton.onClick.listen(signIn);
        }
        if (initialUserId != null) {
          authClient =
          await flow.clientViaUserConsent(
              userId: initialUserId, immediate: true);
          await _handleAuth(authClient);
        }
      });
    });



      return _onSignInController.stream;
  }
  // call last
  tryInitialUserId(String userId) async {
    if (flow == null) {
      await createFlow(clientId);
    }
    authClient =
        await flow.clientViaUserConsent(userId: userId, immediate: true);
    await _handleAuth(authClient);
    return authClient;
  }

  BrowserOAuth2Flow flow;

  _handleAuth(AuthClient client) async {
    print("auth: $client");
    // DbUser newUser;
    if (client != null) {
      PlusApi plusApi = new PlusApi(client);
      // devPrint("getting me...");
      Person person = await plusApi.people.get("me");
/* TODO
      newUser = new DbUser()
        ..userId = person.id
        ..name = person.displayName;

      // get the email - not available anymore
      if (person.emails != null && person.emails.isNotEmpty) {
        newUser.email = person.emails.first.value;
      }
      */
    } else {
      $['app_sign_in'].attributes.remove("disabled");
    }

    /* TODO
    print("$newUser/$user");
    if (newUser != user) {
      user = newUser;

      if (user != null) {
        $['app_sign_in'].attributes["disabled"] = "disabled";
        userNameElement.text = user.name;
        userIdElement.text = user.userId;
      } else {
        userNameElement.text = null;
        userIdElement.text = null;
      }
      if (_onSignInController != null) {
        SignInEvent event;
        if (user != null) {
          event = new SignInEvent()
            ..client = client
            ..user = user;
        }

        print("signin: ${event}");
        _onSignInController.add(event);
      }
    }
    */
  }

  // not async to work on click
  Future<AuthClient> getAskedConsent(BrowserOAuth2Flow flow) {
    return flow.clientViaUserConsent(force: true);
  }

  Future signIn([_]) {
    return getAskedConsent(flow).then(_handleAuth).catchError((e, st) {
      print(e);
      print(st);
      return _handleAuth(null);
    });
  }

  @override
  domReady() {
    userNameElement = $['app_user_name'];
    userIdElement = $['app_user_id'];
    $['app_switch_user'].onClick.listen((_) {
      AuthClient previousClient = authClient;
      signIn().then((_) {
        if (previousClient != null && previousClient != authClient) {
          authClient.close();
        }
      });
    });
    $['app_disconnect_user'].onClick.listen((_) async {
      if (authClient != null) {
        authClient.close();
        authClient = null;
      }
      _handleAuth(null);
      //TODO fire(disconnectEvent);
    });

    $["app_sign_in"].onClick.listen((_) {
      signIn();
    });

    // could be null
    contentSignInButton = querySelector('.tk-gapi-flow-sign-in');

    super.domReady();
  }

  @override
  attached() {
    devPrint('attached');
    super.attached();
  }
}
