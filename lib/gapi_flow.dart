// Copyright (c) 2016, Alexandre Roux. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
///
/// content can contain items with the proper class
///
@HtmlImport('gapi_flow.html')
library tekartik_mdlistpad.user_page;

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

class GapiFlowEvent {
  // non null means connected
  AuthClient authClient;
  Userinfoplus userInfo;
//  DbUser user;

  @override
  String toString() =>
      "GapiFlowEvent: user ${userInfo == null ? null : userInfo.toJson()}";
}

@PolymerRegister('tk-gapi-flow')
class GapiFlowElement extends PolymerElement with DomReadyMixin {
  /// Constructor used to create instance of MainApp.
  GapiFlowElement.created() : super.created() {
    print("GapiFlowElement.created");
  }

  //@property String scopes = "https://www.googleapis.com/auth/drive.appdata";

  Element contentSignInButton;
  Element contentSignOutButton;
  Element contentSignSwitchButton;
  Element contentUserNameElement;
  Element contentUserEmailElement;
  Element contentUserImageElement;

  List<String> _scopes = ["profile"];

  String get clientId => _clientId;

  Userinfoplus _userInfo;

  /// Return the current user authentified in [AuthClient]
  /// null if none
  ///
  Userinfoplus get userInfo => _userInfo;
  String _clientId;

  Pool _flowPool = new Pool(1);

  // Make sure we create the flow twice
  Future<BrowserOAuth2Flow> _createFlow(String clientId) async {
    return (await _flowPool.withResource(() async {
      if (_flow == null) {
        _flow = await createImplicitBrowserFlow(
            new ClientId(clientId, null), _scopes);
      }
      return _flow;
    })) as BrowserOAuth2Flow;
  }

  /*
  // to set first
  set clientId(String clientId) {
    //_clientId = clientId;
    set("_clientId", clientId);
    _clientId = clientId;
    print("»»» ${this.clientId}/${clientId}");

    // create the flow as soon as we have a clientId
    createFlow(clientId);
  }
  */

  //DbUser user;
  AuthClient _authClient;

  /// return the current client to be used in Api
  /// null if not authentified yet
  ///
  AuthClient get authClient => _authClient;

  StreamController<GapiFlowEvent> _onSignInController;

  Stream<GapiFlowEvent> init(
      {String clientId, List<String> scopes, String initialUserId}) {
    _handleAuth(null);
    _flow = null;
    _setDisabled(contentSignInButton, true);

    if (_onSignInController != null) {
      _onSignInController.close();
    }
    _onSignInController = new StreamController();

    if (scopes != null) {
      _scopes = scopes;
    }
    whenDomReady.then((_) {
      _createFlow(clientId).then((_) async {
        _setDisabled(contentSignInButton, false);

        if (initialUserId != null) {
          AuthClient authClient = await _flow.clientViaUserConsent(
              userId: initialUserId, immediate: true);
          await _handleAuth(authClient);
        }
      });
    });

    return _onSignInController.stream;
  }

  _setDisabled(Element element, bool disabled) {
    if (element != null) {
      setDisabled(element, disabled);
    }
  }

  // call last
  tryInitialUserId(String userId) async {
    if (_flow == null) {
      await _createFlow(clientId);
    }
    AuthClient authClient =
        await _flow.clientViaUserConsent(userId: userId, immediate: true);
    await _handleAuth(authClient);
    return authClient;
  }

  BrowserOAuth2Flow _flow;

  _handleAuth(AuthClient client) async {
    Userinfoplus newUserInfo;
    print("auth: $client");
    // DbUser newUser;
    if (client != null) {
      Oauth2Api oauth2Api = new Oauth2Api(client);
      newUserInfo = await oauth2Api.userinfo.v2.me.get();

      //devPrint(newUserInfo.toJson());
      _setDisabled(contentSignInButton, true);
      _setDisabled(contentSignOutButton, false);
      _setDisabled(contentSignSwitchButton, false);

      if (contentUserEmailElement != null) {
        contentUserEmailElement.text = newUserInfo.email;
      }
      if (contentUserNameElement != null) {
        contentUserNameElement.text = newUserInfo.name;
      }
      if (contentUserImageElement is IronImage) {
        (contentUserImageElement as IronImage).src = newUserInfo.picture;
      }
      //print(newUserInfo.toJson());
      /*
      PlusApi plusApi = new PlusApi(client);
      // devPrint("getting me...");
      Person person = await plusApi.people.get("me");

      newUser = new DbUser()
        ..userId = person.id
        ..name = person.displayName;

      // get the email - not available anymore
      if (person.emails != null && person.emails.isNotEmpty) {
        newUser.email = person.emails.first.value;
      }
      */
    } else {
      _setDisabled(contentSignInButton, false);
      _setDisabled(contentSignOutButton, true);
      _setDisabled(contentSignSwitchButton, true);

      if (contentUserEmailElement != null) {
        contentUserEmailElement.text = '';
      }
      if (contentUserNameElement != null) {
        contentUserNameElement.text = '';
      }
      if (contentUserImageElement is IronImage) {
        (contentUserImageElement as IronImage).src = '';
      }
    }

    _sameUser(Userinfoplus info1, Userinfoplus info2) {
      return (info1 == null
          ? info2 == null
          : (info2 != null && info1.id == info2.id));
    }
    bool sameUser = _sameUser(userInfo, newUserInfo);

    _authClient = client;
    _userInfo = newUserInfo;
    if (!sameUser) {
      GapiFlowEvent event = new GapiFlowEvent()
        ..userInfo = userInfo
        ..authClient = authClient;
      _onSignInController.add(event);
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
  Future<AuthClient> _getAskedConsent(BrowserOAuth2Flow flow) {
    return flow.clientViaUserConsent(force: true);
  }

  Future signIn([_]) {
    return _getAskedConsent(_flow).then(_handleAuth).catchError((e, st) {
      print(e);
      print(st);
      return _handleAuth(null);
    });
  }

  signSwitch([_]) {
    AuthClient previousClient = authClient;
    signIn().then((_) {
      if (previousClient != null && previousClient != authClient) {
        previousClient.close();
      }
    });
  }

  signOut([_]) async {
    if (authClient != null) {
      authClient.close();
      _authClient = null;
    }
    _handleAuth(null);
  }

  @override
  domReady() {
    // could be null
    contentSignInButton = querySelector('.tk-gapi-flow-sign-in');
    contentSignSwitchButton = querySelector('.tk-gapi-flow-sign-switch');
    contentSignOutButton = querySelector('.tk-gapi-flow-sign-out');
    contentUserNameElement = querySelector('.tk-gapi-flow-user-name');
    contentUserEmailElement = querySelector('.tk-gapi-flow-user-email');
    contentUserImageElement = querySelector('.tk-gapi-flow-user-image');

    if (contentSignOutButton != null) {
      contentSignOutButton.onClick.listen((_) => signOut());
    }

    if (contentSignSwitchButton != null) {
      contentSignSwitchButton.onClick.listen((_) => signSwitch());
    }

    if (contentSignInButton != null) {
      contentSignInButton.onClick.listen((_) => signIn());
    }

    super.domReady();
  }

  @override

  /// needed to call mixin
  attached() {
    super.attached();
  }
}
