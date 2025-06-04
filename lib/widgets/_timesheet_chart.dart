// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class TimesheetChart extends StatelessWidget {
//   final List<DateTime> dates;
//   final List<double> hours;

//   const TimesheetChart({required this.dates, required this.hours, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.6,
//       child: LineChart(
//         LineChartData(
//           titlesData: FlTitlesData(
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, _) {
//                   final index = value.toInt();
//                   if (index < 0 || index >= dates.length) const SizedBox();
//                   final date = dates[index];
//                   return Text(
//                     "${date.month}/${date.day}",
//                     style: const TextStyle(fontSize: 10),
//                   );
//                 },
//               ),
//             ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 interval: 2,
//                 getTitlesWidget: (value, _) => Text("${value.toInt()}h"),
//               ),
//             ),
//           ),
//           gridData: FlGridData(show: true),
//           lineBarsData: [
//             LineChartBarData(
//               isCurved: true,
//               color: Colors.blue,
//               barWidth: 3,
//               dotData: FlDotData(show: true),
//               spots: List.generate(
//                 hours.length,
//                 (index) => FlSpot(index.toDouble(), hours[index]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
