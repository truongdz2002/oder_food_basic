import 'package:intl/intl.dart';

extension CurrencyProperty on String {
  String get formatCurrency {
    final money = num.parse(this);
    final format =
        NumberFormat.currency(locale: "vi", decimalDigits: 0, symbol: "đ");
    return format.format(money).replaceAll(".", ",");
  }

  String get formatNoSymbolCurrency {
    final money = num.parse(this);
    final format =
        NumberFormat.currency(locale: "vi", decimalDigits: 0, symbol: "");
    return format.format(money).replaceAll(" ", "");
    ; //.replaceAll(".", ",");
  }

  String get removeCurrency {
    return this.replaceAll(".", "").replaceAll(" ", "");
  }
}
