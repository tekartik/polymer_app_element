import 'dart:html';


void setDisabled(Element element, bool disabled) {
    if (disabled == true) {
      element.attributes['disabled'] = '';
    } else {
      element.attributes.remove('disabled');
    }
}