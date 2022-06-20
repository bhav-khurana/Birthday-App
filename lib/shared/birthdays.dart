class Birthday {
  final String name;
  final date;
  final String relation;
  final int dayth;

  const Birthday({
    required this.name,
    required this.date,
    required this.relation,
    required this.dayth,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'relation': relation,
      'dayth': dayth,
    };
  }
}