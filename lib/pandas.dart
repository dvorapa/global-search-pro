import 'package:angular/angular.dart';
import 'src/get_items.dart';

/// Creates angular components (items and modules).
@Component(
  selector: 'pandas',
  template: '''<div id="panda_items">
  <ul class="panda_items_list">
    <li class="panda_item" *ngFor="let whale of whales">
      <div class="panda_desc"><a href="{{whale.url}}">{{whale.title}}</a></div>
    </li>
  </ul>
</div>
<div id="panda_modules">
  <div class="panda_module_row">
    <div class="panda_module" *ngFor="let rhino of rhinos"><a href="{{rhino.url}}" id="{{rhino.title}}" class="{{rhino.cl}}">{{rhino.title}}</a></div>
  </div>
  <span>{{state}}</span>
</div>''',
  directives: [coreDirectives],
)
class AppComponent implements OnInit {
  List<Panda> whales = [];
  List<Panda> rhinos = [];
  String state = 'what should pandas look for?';

  // get whales and pandas async
  @override
  ngOnInit() async {
    String query = Uri.base.queryParameters['q'] ?? '';
    if (query.isNotEmpty) {
      state = '...pandas are searching for $query';
      List<String> babyWhales = await (Whales().getWhales());
      for (final String babyWhale in babyWhales) {
        state = '...pandas are searching for $query in $babyWhale';
        List<Panda> pandas = [];
        pandas = await (Pandas(babyWhale, query).getPandas());
        if (pandas.isNotEmpty) {
          String hugeWhale = await (Whale(babyWhale).getWhale());
          whales.add(Panda(hugeWhale, '#$babyWhale', 'whale'));
          rhinos.add(Panda(hugeWhale, '#$babyWhale', 'whale'));
          rhinos += pandas;
        }
      }
      if (rhinos.isNotEmpty) {
        state = '';
      } else {
        state = '...pandas found nothing, sorry :/';
      }
    }
  }
}
