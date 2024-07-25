import 'package:MarketEase/model/model.dart';

class ShiftRecord extends Model {
  ShiftType type;
  DateTime timestamp;

  ShiftRecord({required this.type, required this.timestamp});

  ShiftRecord.fromMap(Map<String, dynamic> data):
      type = ShiftType.fromString(data['shift_record_type']),
      timestamp = DateTime.parse(data['created_at']),
      super(id: data['id']);
}

enum ShiftType {
  clockIn(label: 'Clock In', value: 'start_shift'),
  clockOut(label: 'Clock Out', value: 'end_shift'),
  breakStart(label: 'Break Start', value: 'start_break'),
  breakEnd(label: 'Break End', value: 'end_break'),
  error(label: 'Error', value: 'error');

  const ShiftType({required this.label, required this.value});

  static ShiftType fromString(string) {
    switch (string) {
      case 'start_shift':
        return ShiftType.clockIn;
      case 'end_shift':
        return ShiftType.clockOut;
      case 'start_break':
        return ShiftType.breakStart;
      case 'end_break':
        return ShiftType.breakEnd;

      default:
        return ShiftType.error;
    }
  }

  final String label;
  final String value;
}