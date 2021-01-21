import 'package:boiler/widgets/app_localization.dart';

class SortItems {
  int id;
  String title;

  SortItems({this.id, this.title});

  static List<SortItems> getSortItems(AppLocalizations local) {
    List<SortItems> sortItems = [
      SortItems(
        id: 0,
        title: local.translate('date_attached'),
      ),
      SortItems(
        id: 1,
        title: local.translate('work_type'),
      ),
      SortItems(
        id: 2,
        title: local.translate('customer_name'),
      ),
      SortItems(
        id: 3,
        title: local.translate('status'),
      ),
      SortItems(
        id: 4,
        title: local.translate('city'),
      )
    ];
    return sortItems;
  }
}
