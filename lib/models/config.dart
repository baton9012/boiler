class Config {
  int sortTypeId;
  int languageId;

  Config({this.sortTypeId, this.languageId});

  factory Config.fromMap(Map<String, dynamic> configJson) => Config(
        sortTypeId: configJson['sort_type_id'],
        languageId: configJson['lang_id'],
      );

  Map<String, dynamic> toMap() => {
        'sort_type_id': sortTypeId,
        'lang_id': languageId,
      };
}
