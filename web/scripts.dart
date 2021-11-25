import 'package:angular/angular.dart';
import 'package:global_pandas/pandas.template.dart' as pandas;
import 'dart:html';

class AllowAll implements NodeValidator {
  @override
  bool allowsAttribute(Element element, String attributeName, String value) {
    return true;
  }

  @override
  bool allowsElement(Element element) {
    return true;
  }
}

/// Main method called onload.
void main() {
  // lazy load styles
  HtmlElement head = querySelector('head') as HtmlElement;
  head.setInnerHtml(head.innerHtml! + querySelector('noscript')!.innerHtml!,
      validator: AllowAll());
  // list pandas
  runApp(pandas.AppComponentNgFactory);
}
