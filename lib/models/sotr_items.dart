class SortItems {
  int id;
  String title;

  SortItems({this.id, this.title});

  List<SortItems> getSortItems() {
    List<SortItems> sortItems = List<SortItems>();
    sortItems.add(SortItems(
      id: 0,
      title: 'Дата добавления',
    ));
    sortItems.add(SortItems(
      id: 1,
      title: 'Тип работы',
    ));
    sortItems.add(SortItems(
      id: 2,
      title: 'Имя заказчика',
    ));
    sortItems.add(SortItems(
      id: 3,
      title: 'Статус',
    ));
    sortItems.add(SortItems(
      id: 4,
      title: 'Населенный пункт',
    ));
    return sortItems;
  }
}
