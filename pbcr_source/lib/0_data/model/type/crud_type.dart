enum CrudType {
  create,
  read,
  update,
  delete;

  static CrudType fromString(String value) {
    return CrudType.values.firstWhere((e) => e.name == value, orElse: () => CrudType.create);
  }

  static CrudType fromIndex(int value) {
    return CrudType.values.firstWhere((e) => e.index == value, orElse: () => CrudType.create);
  }
}
