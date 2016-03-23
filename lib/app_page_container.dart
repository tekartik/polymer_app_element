import 'dart:html';
import 'src/base_import.dart';
import 'app_page.dart';

typedef AppPageContainerSelectPageId(String pageId);
typedef AppPage AppPageContainerResolvePage(String pageId);

class AppPageContainer {
  String _currentPageId;

  String get currentPageId => _currentPageId;

  AppPageContainerSelectPageId _selectPageId;
  AppPageContainerResolvePage _resolvePage;
  AppPageContainer(
      {AppPageContainerSelectPageId selectPageId,
      AppPageContainerResolvePage resolvePage}) {
    _selectPageId = selectPageId;
    _resolvePage = resolvePage;
  }

  // single entry point
  selectPageId(String pageId, {bool force}) {
    //devPrint('_selectPage: $pageId/$_lastSelectedPageId');
    if (currentPageId != pageId || force) {
      String previousPageId = currentPageId;
      _currentPageId = pageId;

      if (_selectPageId != null) {
        _selectPageId(pageId);
      }
      if (_resolvePage != null) {
        AppPage newSelectedPage = _resolvePage(pageId);

        // activate new
        if (newSelectedPage == null) {
          window.console.error("cannot find page $pageId");
        } else {
          newSelectedPage.onActivate();
          if (previousPageId != null) {
            AppPage previousSelectedPage = _resolvePage(previousPageId);
            if (previousSelectedPage != null) {
              // unactivate old
              previousSelectedPage.onUnactivate();
            }
          }
        }
      }
    }
  }
}
