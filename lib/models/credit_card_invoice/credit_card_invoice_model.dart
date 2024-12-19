import 'package:billy/utils/date_utils.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:intl/intl.dart';

class CreditCardInvoiceModel {
  final int? id;
  final double total;
  final String? name;
  final DateTime beginDate;
  final DateTime endDate;
  final bool? paid;

  CreditCardInvoiceModel(
      {this.id,
      required this.total,
      this.name,
      required this.beginDate,
      required this.endDate,
      this.paid = false});

  factory CreditCardInvoiceModel.empty() {
    return CreditCardInvoiceModel(
      id: null,
      total: 0.0,
      beginDate: MyDateUtils.getFirstDayOfMonth(),
      endDate: MyDateUtils.getLastDayOfMonth(),
      paid: false,
    );
  }

  CreditCardInvoiceModel copyWith({
    int? id,
    double? total,
    DateTime? beginDate,
    DateTime? endDate,
    bool? paid,
    DateTime? payDate
  }) {
    return CreditCardInvoiceModel(
      id: id ?? this.id,
      total: total ?? this.total,
      beginDate: beginDate ?? this.beginDate,
      endDate: endDate ?? this.endDate,
      paid: paid ?? this.paid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'begin_date': beginDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'paid': paid == true ? 1 : 0
    };
  }

  static CreditCardInvoiceModel fromMap(Map<String, dynamic> map) {
    return CreditCardInvoiceModel(
        id: map['invoice_id'] ?? map['id'],
        name: map['begin_date'] != null
            ? _getCreditCardDisplayName(map['begin_date'])
            : DateTime.now().toIso8601String(),
        total: map['total'] ?? 0,
        beginDate: map['begin_date'] != null ? DateTime.parse(map['begin_date']) : DateTime.now(),
        endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : DateTime.now(),
      paid: map['paid'] == 1 ? true : false
    );
  }

  static String _getCreditCardDisplayName(String dateIso) {
    DateTime date = DateTime.parse(dateIso);
    DateFormat dateFormat = DateFormat("MMM/yy");
    return dateFormat.format(date);
  }
}
