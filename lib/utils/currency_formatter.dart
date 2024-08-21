import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class CurrencyFormatter{

  static String format(double amount) {
    final formatter = CurrencyTextInputFormatter.currency(
      locale: 'pt-BR',
      symbol: 'R\$',
    );
    return formatter.formatDouble(amount);
  }

}