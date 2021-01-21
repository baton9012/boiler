class Config {
  int sortTypeId;
  String localeTitle;

  Config({this.sortTypeId, this.localeTitle});

  factory Config.fromMap(Map<String, dynamic> configJson) => Config(
        sortTypeId: configJson['sort_type_id'],
        localeTitle: configJson['lang_id'],
      );

  Map<String, dynamic> toMap() => {
        'sort_type_id': sortTypeId,
        'lang_id': localeTitle,
      };
}
