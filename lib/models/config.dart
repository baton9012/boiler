class Config {
  int sort_type_id;
  int language_id;

  Config({this.sort_type_id, this.language_id});

  factory Config.fromMap(Map<String, dynamic> configJson) => Config(
        sort_type_id: configJson['sort_type_id'],
        language_id: configJson['lang_id'],
      );

  Map<String, dynamic> toMap() => {
        'sort_type_id': sort_type_id,
        'lang_id': language_id,
      };
}
