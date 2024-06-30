import 'package:intl/intl.dart';

class Helper {
  static String getCurrencyString(double value) {
    return NumberFormat.currency(symbol: '\$').format(value);
  }
}