import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

// Create a reusable widget to display the date in Khmer format
class KhmerDate extends StatelessWidget {
  final DateTime dateTime;

  // Constructor to accept a DateTime object
  KhmerDate({required this.dateTime});

  // Function to convert date to Khmer date format
  String convertToKhmerDate(DateTime dateTime) {
    // Khmer month names
    final List<String> khmerMonths = [
      'មករា', 'កុម្ភៈ', 'មីនា', 'មេសា', 'ឧសភា', 'មិថុនា',
      'កក្កដា', 'សីហា', 'កញ្ញា', 'តុលា', 'វិច្ឆិកា', 'ធ្នូ'
    ];

    // Khmer weekday names
    final List<String> khmerDays = [
      'អាទិត្យ', 'ច័ន្ទ', 'អង្គារ', 'ពុធ', 'ព្រហស្បតិ៍', 'សុក្រ', 'សៅរ៍'
    ];

    // Khmer date format: "Day KhmerDay, Month KhmerMonth, Year"
    final day = DateFormat('d').format(dateTime);
    final month = khmerMonths[dateTime.month - 1]; // Month index starts from 0
    final year = DateFormat('y').format(dateTime);
    final weekday = khmerDays[dateTime.weekday % 7]; // Weekday starts from 1 (Monday)

    return '$weekday, $day $month $year';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      convertToKhmerDate(dateTime),
      style: TextStyle(fontSize: 14, color: Colors.grey),
    );
  }
}
