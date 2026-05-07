import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milkdy/presentation/widgets/range_dashboard_buttons.dart';
import 'package:milkdy/presentation/widgets/widget/range_dashboard_detailed.dart';
import 'package:milkdy/presentation/widgets/widget/range_dashboard_monthly.dart';
import 'package:milkdy/provider/milk_entry_repo_provider.dart';
import 'package:milkdy/presentation/widgets/pdf_total.dart';


class RangeDashboardScreen extends ConsumerStatefulWidget {
  final String customerId;
  final String? customerName;

  const RangeDashboardScreen({super.key, required this.customerId, this.customerName});

  @override
  ConsumerState<RangeDashboardScreen> createState() => _RangeDashboardScreenState();
}

class _RangeDashboardScreenState extends ConsumerState<RangeDashboardScreen> {
  DateTime selectedMonth = DateTime.now();
  int selectedDays = 1;
  int months = 0;
  bool _showdetails = false;




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
    }
  }

  String getMonthName(DateTime date) {
    const months = ["January", "February", "March", "April", "May", "June",
                    "July", "August", "September", "October", "November", "December"];
    return "${months[date.month - 1]} ${date.year}";
  }

  
  

@override
Widget build(BuildContext context) {
  final entriesAsync = ref.watch(
    getEntriesProvider(
      (customerId: widget.customerId, days: selectedDays),
      ),);
      final monthlyAsync = ref.watch(getMonthlyCollectionProvider(
        (customerId: widget.customerId, months: months)
      ),);
      final getPdfAsync = ref.watch(getpdfDataProvider(
        (customerId: widget.customerId, month: selectedMonth.month, year: selectedMonth.year)
      ),);

  return Scaffold(
    appBar: AppBar(title:  Text(widget.customerName?.toUpperCase() ?? "Customer Dashboard"),
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
      onPressed: getPdfAsync.maybeWhen(
    data: (pdfEntries) => () => generateFullReportPdf(
      entries: pdfEntries,
      month: getMonthName(selectedMonth),
      customerName: widget.customerName ?? "Customer",
    ),
    orElse: () => () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data still loading, please wait...")),
      );
    },
  ),
  icon: const Icon(Icons.download),
  label: const Text("PDF"),
),
    ],
  ),
),
          RangeDashboardButtons(
            selectedDays: selectedDays,
            onChanged: (days) {
              setState(() => selectedDays = days);
            },
          ),
        

          const SizedBox(height: 8),

          Expanded(
              child: entriesAsync.when(  
                data: (entries) => entries.isEmpty
                    ? const Center(child: Text("No Data Found"))   
                    : ListView(                                
                        children: [
                          RangeDashboardMonthly(
                            monthlyData: monthlyAsync.valueOrNull ?? [],
                          ),
                          const Divider(),
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

                          // Detailed Entries
                          if (_showdetails)
                            RangeDashboardDetailed(
                              entries: entries,
                              onDelete: (id) async {
                                try {
                                  await ref.read(milkEntryRepoProvider).deletedata(id);
                                  ref.invalidate(milkEntryRepoProvider);
                                  ref.invalidate(getMonthlyCollectionProvider);
                                  ref.invalidate(getpdfDataProvider);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Entry deleted successfully!')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to delete entry. something went wrong')),
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),

                error: (error, stackTrace) => const Center(
                  child: Text("Error loading data"),
                ),
              ),  
            ),
        ],
      ),
    ),
  );
}
}