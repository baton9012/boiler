import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final bool isSearch;
  final Function onTab;

  SearchButton({
    this.isSearch,
    this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    if (isSearch) {
      return IconButton(
        onPressed: onTab,
        icon: Icon(Icons.close),
      );
    } else {
      return IconButton(
        icon: Icon(Icons.search),
        onPressed: onTab,
      );
    }
  }
}
