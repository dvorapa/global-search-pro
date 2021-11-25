import 'dart:async';
import 'dart:convert' as jsonlib;
import 'dart:html';
import 'package:pool/pool.dart';

final pool = Pool(15, timeout: Duration(seconds: 30));

/// Gets anything from API. (so called The Big Getter)
///
/// @param query: query to be requested from API
/// @type query: String
class Getter {
  // instantiate empty request
  String query;

  // initializer
  Getter(this.query);

  // get raw json
  Future getJson() async {
    // async completer
    Completer c = Completer();
    // API url
    String url = 'https://global-pandas.toolforge.org/api/$query';
    // request raw result
    String raw = '[]';
    try {
      raw = await pool.withResource(() => HttpRequest.requestCrossOrigin(url));
    } catch (_) {}
    // jsonify
    List json = jsonlib.jsonDecode(raw);
    // async return
    c.complete(json);
    return c.future;
  }
}

/// Gets whales from The Big Getter.
class Whales {
  // instantiate whale request
  String action = 'wikis';

  // instantiate empty list
  List<String> whales = [];

  // compile new list of whales
  Future getWhales() async {
    // async completer
    Completer c = Completer();
    // instantiate request
    Getter request = Getter(action);
    // request json
    List json = await (request.getJson());
    // fill list
    for (final str in json) {
      whales.add(str);
    }
    // async return
    c.complete(whales);
    return c.future;
  }
}

/// Gets whale name from The Big Getter.
class Whale {
  // instantiate whale name request
  late String whale;

  Whale(this.whale);

  // instantiate empty whale name
  late String whaleName;

  // compile new whale name
  Future getWhale() async {
    // async completer
    Completer c = Completer();
    // instantiate request
    Getter request = Getter('wiki/$whale');
    // request json
    List json = await (request.getJson());
    // fill whale name
    for (final str in json) {
      whaleName = str;
    }
    // async return
    c.complete(whaleName);
    return c.future;
  }
}

/// Gets pandas from The Big Getter.
class Pandas {
  // instantiate panda request
  String whale;
  String query;

  Pandas(this.whale, this.query);

  // instantiate empty list
  List<Panda> pandas = [];

  // compile new list of pandas
  Future getPandas() async {
    // async completer
    Completer c = Completer();
    // instantiate request
    Getter request = Getter('query/$whale?q=$query');
    // request json
    List json = await (request.getJson());
    // fill list
    for (final map in json) {
      pandas.add(Panda(map['title']!, map['url']!, 'panda'));
    }
    // async return
    c.complete(pandas);
    return c.future;
  }
}

/// Panda class.
///
/// @param title: title of panda
/// @type title: String
/// @param url: url of panda
/// @type url: String
class Panda {
  // initialize class
  late String title;
  late String url;
  late String cl;
  Panda(this.title, this.url, this.cl);
}
