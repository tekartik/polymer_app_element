import 'dart:html';


void setDisabled(Element element, bool disabled) {
    if (disabled == true) {
      element.attributes['disabled'] = '';
    } else {
      element.attributes.remove('disabled');
    }
}

void setHidden(Element element, bool hidden) {
  if (hidden == true) {
    element.attributes['hidden'] = '';
  } else {
    element.attributes.remove('hidden');
  }
}