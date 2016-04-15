import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

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

bool isHidden(Element element) {
  return element.attributes.containsKey('hidden');
}

bool isDisabled(Element element) {
  return element.attributes.containsKey('disabled');
}

///
/// Fired when an element is manually selected in a menu
/// even if it is the same
/// detail['selected'] contains the future selection
///
Stream<CustomEvent> onIronActivate(Element element) {
  return element.on['iron-activate'].transform(
      new StreamTransformer<Event, CustomEvent>.fromHandlers(
          handleData: (Event event, EventSink<CustomEvent> sink) {
    sink.add(convertToDart(event) as CustomEvent);
  }));
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
