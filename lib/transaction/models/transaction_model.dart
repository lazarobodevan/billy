class Transaction {
  final int? id;
  final String name;
  final double value;
  final String category;
  final DateTime date;
  final DateTime? endDate;
  final bool? isPaid;

  Transaction(
      {this.id,
      required this.name,
      required this.value,
      required this.category,
      required this.date,
      this.endDate,
      this.isPaid});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'category': category,
      'date': date,
      'endDate': endDate,
      'isPaid': isPaid
    };
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      isPaid: map['isPaid'],
      name: map['name'],
      value: map['value'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }
}
