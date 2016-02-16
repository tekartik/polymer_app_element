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


// Recursive into the parent to find the first parent matching the give id
/// [includeElement] if true also check the current element id
Element findFirstAncestorWithId(Element element, String id,
    [bool includeElement]) {
  Element parent;
  if (includeElement == true) {
    parent = element;
  } else {
    parent = element.parent;
  }
  while (parent.id != id) {
    parent = parent.parent;
    if (parent == null) {
      return null;
    }
  }
  return parent;
}

// Recursive into the parent to find the first parent matching the class
/// [includeElement] if true also check the current element id
Element findFirstAncestorWithClass(Element element, String klass,
    [bool includeElement]) {
  Element parent;
  if (includeElement == true) {
    parent = element;
  } else {
    parent = element.parent;
  }
  while (!parent.classes.contains(klass)) {
    parent = parent.parent;
    if (parent == null) {
      return null;
    }
  }
  return parent;
}
