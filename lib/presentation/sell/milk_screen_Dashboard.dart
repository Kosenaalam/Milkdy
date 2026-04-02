import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:milkdy/data/models/add_milk_entry_model.dart';
import 'package:milkdy/data/models/each_milk_entry_model.dart';
import 'package:milkdy/data/models/monthly_model.dart';
import 'package:milkdy/data/models/sell_model.dart';
import 'package:milkdy/data/repositories/milk_entry_repo.dart';
import 'package:milkdy/presentation/widgets/generete_monthly_pdf.dart';
import 'package:milkdy/presentation/widgets/range_dashboard_buttons.dart';
import 'package:milkdy/presentation/widgets/widget/range_dashboard_detailed.dart';
import 'package:milkdy/presentation/widgets/widget/range_dashboard_monthly.dart';
import 'package:milkdy/presentation/widgets/widget/range_dashboard_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:milkdy/presentation/widgets/pdf_total.dart';
import 'package:month_year_picker/month_year_picker.dart';


class RangeDashboardScreen extends StatefulWidget {
  final String customerId;
  final String? customerName;

  const RangeDashboardScreen({super.key, required this.customerId, this.customerName});

  @override
  State<RangeDashboardScreen> createState() => _RangeDashboardScreenState();
}

class _RangeDashboardScreenState extends State<RangeDashboardScreen> {
  DateTime selectedMonth = DateTime.now();
  final repo = MilkRepo();
   //final now = DateTime.now();
  //int nowYear = DateTime.now().year;
  int selectedDays = 1;
  int months = 0;
  bool isLoading = true;
  bool _showdetails = false;
  bool isOffline = false;

//  List<RangeDashboardModel> data = [];
  List<EachMilkEntryModel> entries = [];
  List<MonthlyModel> monthlyData = [];

  @override
  void initState() {
    super.initState();
    _loadCachedData();
    loadData();
  }

  // ==================== ALL YOUR ORIGINAL METHODS (100% UNCHANGED) ====================

  Future<void> _loadCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cachedSummary = prefs.getString('summary_${widget.customerId}');
      final String? cachedEntries = prefs.getString('entries_${widget.customerId}');

      if (cachedSummary != null) {
        final List<dynamic> decoded = jsonDecode(cachedSummary);
       // data = decoded.map((e) => RangeDashboardModel.fromMap(e)).toList();
      }
      if (cachedEntries != null) {
        final List<dynamic> decoded = jsonDecode(cachedEntries);
        entries = decoded.map((e) => EachMilkEntryModel.fromMap(e)).toList();
      }
      setState(() {});
    } catch (e) {
      print("CACHE ERROR: $e");
    }
  }

  Future<void> _saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
   // final summaryJson = jsonEncode(data.map((e) => e.toMap()).toList());
    final entriesJson = jsonEncode(entries.map((e) => e.toMap()).toList());

   // await prefs.setString('summary_${widget.customerId}', summaryJson);
    await prefs.setString('entries_${widget.customerId}', entriesJson);
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    try {
     // final summary = await repo.getRangeDashboard(widget.customerId, selectedDays);
      final entryData = await repo.getEntries(widget.customerId, selectedDays);
      final mData = await repo.getMonthlyCollection(widget.customerId, months );

      setState(() {
       // data = summary;
        entries = entryData;
        monthlyData = mData;
        isLoading = false;
        isOffline = false;
      });
      await _saveToCache();
    } catch (e) {
      setState(() => isOffline = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Offline Mode - Showing cached data")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void deleteEntry(String id) async {
    await repo.deletedata(id);
    await repo.recalculateBalance(id);
    setState(() {
      entries.removeWhere((c) => c.id == id);
    });
    await loadData();
  }

  Future<void> pickMonth() async {
     final date = DateTime.now();
    final firstDate = DateTime(date.year, date.month - 2);
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedMonth = picked);
      loadMonthlyData();
    }
  }

  String getMonthName(DateTime date) {
    const months = ["January", "February", "March", "April", "May", "June",
                    "July", "August", "September", "October", "November", "December"];
    return "${months[date.month - 1]} ${date.year}";
  }

  Future<void> loadMonthlyData() async {
    try {
      final res = await repo.getMonthEntries(
        widget.customerId,
        selectedMonth.month,
        selectedMonth.year,
      );
      setState(() => entries = res);
    } catch (e) {
      print("MONTH LOAD ERROR: $e");
    }
  }
   Future<void> reportpdf()async{
    final entries = await repo.getMonthEntries(
      widget.customerId,
      selectedMonth.month,
      selectedMonth.year,
    );

    await generateFullReportPdf(
      entries: entries,
       month: getMonthName(selectedMonth),
       customerName: widget.customerName ?? "Customer",
       );
   }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title:  Text(widget.customerName ?? "Customer Dashboard"),
    centerTitle: true,
    ),
    body: SafeArea(
      child: Column(
        children: [
          Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        getMonthName(selectedMonth),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),  

      ElevatedButton.icon(
        onPressed: pickMonth,
        icon: const Icon(Icons.calendar_month),
        label: const Text("Change"),
      ),
       ElevatedButton.icon(
        onPressed: reportpdf,
       icon: const Icon(Icons.download),
       label: Text("PDF"),
),
    ],
  ),
),
          RangeDashboardButtons(
            selectedDays: selectedDays,
            onChanged: (days) {
              setState(() => selectedDays = days);
              loadData();
            },
          ),
        

          const SizedBox(height: 8),

          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (
            //data.isEmpty && 
          entries.isEmpty)
            const Expanded(child: Center(child: Text("No Data Found")))
          else
            Expanded(
              child: ListView(
                children: [
                  RangeDashboardMonthly(monthlyData: monthlyData),
                  const Divider(),
              //    RangeDashboardSummary(data: data),
                //  const Divider(),

                  // Toggle Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showdetails = !_showdetails;
                          });
                        },
                        icon: Icon(
                          _showdetails ? Icons.visibility_off : Icons.visibility,
                        ),
                        label: Text(
                          _showdetails ? 'Hide Detailed Entries' : 'Show Detailed Entries',
                        ),
                      ),
                    ),
                  ),

                  // Detailed Entries - Now properly shown
                  if (_showdetails)
                    RangeDashboardDetailed(
                      entries: entries,
                      onDelete: deleteEntry,
                    ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
}