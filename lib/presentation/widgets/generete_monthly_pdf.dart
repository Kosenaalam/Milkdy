// import 'package:milkdy/data/models/each_milk_entry_model.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// Future<void> generateMonthlyPdf(
//   List<EachMilkEntryModel> entries,
//   String monthName,
// ) async {
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.MultiPage(
//       build: (context) => [

//         /// TITLE
//         pw.Text(
//           "Milk Report - $monthName",
//           style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
//         ),

//         pw.SizedBox(height: 10),

//         /// TABLE
//         pw.Table(
//           border: pw.TableBorder.all(),
//           children: [

//             /// HEADER
//             pw.TableRow(
//               children: [
//                 _cell("Date"),
//                 _cell("Milk"),
//                 _cell("Fat"),
//                 _cell("Rate"),
//                 _cell("Amount"),
//                 _cell("Rec"),
//                 _cell("Paid"),
//                 _cell('Feed'),
//                 _cell("Bal"),
//               ],
//             ),

//             /// DATA
//             ...entries.map((e) {
//               return pw.TableRow(
//                 children: [
//                   _cell("${e.date.day}/${e.date.month}"),
//                   _cell("${e.liters}"),
//                   _cell("${e.fat}"),
//                   _cell("${e.rate}"),
//                   _cell("${e.amount}"),
//                   _cell("${e.recived}"),
//                   _cell("${e.paid}"),
//                   _cell("${e.feed}"),
//                   _cell("${e.balance}"),
//                 ],
//               );
//             }).toList(),
//           ],
//         ),
//       ],
//     ),
//   );

//   await Printing.layoutPdf(
//     onLayout: (format) async => pdf.save(),
//   );
// }

// /// helper
// pw.Widget _cell(String text) {
//   return pw.Padding(
//     padding: const pw.EdgeInsets.all(5),
//     child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
//   );
// }