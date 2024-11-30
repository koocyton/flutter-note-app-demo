import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class TimeUtil {

  static final Logger logger = Logger();

  static String? formatYmdHis(DateTime? dateTime) {
    return dateTime==null 
      ? null 
      : DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }
}