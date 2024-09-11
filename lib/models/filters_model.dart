enum FilterStatus { high, low, medium, all }

class FiltersModel {
  const FiltersModel(
      {required this.isOldFirst, required this.status, required this.isDone});

  final bool isOldFirst;
  final FilterStatus status;
  final bool isDone;

  FiltersModel copyWith({
    FilterStatus? status,
    bool? isDone,
    bool? isOldFirst,
  }) {
    return FiltersModel(
      status: status ?? this.status,
      isDone: isDone ?? this.isDone,
      isOldFirst: isOldFirst ?? this.isOldFirst,
    );
  }
}
