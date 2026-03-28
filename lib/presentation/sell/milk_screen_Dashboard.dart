import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:milkdy/data/models/add_milk_entry_model.dart';
import 'package:milkdy/data/models/each_milk_entry_model.dart';
import 'package:milkdy/data/repositories/milk_entry_repo.dart';
import 'package:milkdy/presentation/widgets/milk_card_item.dart';
import 'package:milkdy/presentation/widgets/milk_card_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RangeDashboardScreen extends StatefulWidget {
  final String customerId;

  const RangeDashboardScreen({super.key, required this.customerId});

  @override
  State<RangeDashboardScreen> createState() => _RangeDashboardScreenState();
}

class _RangeDashboardScreenState extends State<RangeDashboardScreen> {
  final repo = MilkRepo();

  int selectedDays = 1;        // Default to 30 days
  bool isLoading = true;
  bool _showdetails = false;
  bool isOffline = false;
  List<RangeDashboardModel> data = [];
  List<EachMilkEntryModel> entries = [];

  @override
  void initState() {
    super.initState();
    _loadCachedData();
    loadData();
  }

  Future<void>_loadCachedData()async{
    final prefs = await SharedPreferences.getInstance();
    final String? cachedSummery = prefs.getString('summery_${widget.customerId}');
    final String? cachedEntries = prefs.getString('entries_${widget.customerId}');
    if(cachedSummery != null){
      final List<dynamic> decoded = jsonDecode(cachedSummery);
      data = decoded.map((e) => RangeDashboardModel.fromMap(e)).toList();
    }
    if(cachedEntries != null){
      final List<dynamic> decoded = jsonDecode(cachedEntries);
      entries = decoded.map((e) => EachMilkEntryModel.fromMap(e)).toList();
    }
    setState(() {
    });
  }
   // Save to cache
  Future<void> _saveToCache() async {
    final prefs = await SharedPreferences.getInstance();

    final summaryJson = jsonEncode(data.map((e) => e.toMap).toList());
    final entriesJson = jsonEncode(entries.map((e) => e.toMap()).toList());

    await prefs.setString('summary_${widget.customerId}', summaryJson);
    await prefs.setString('entries_${widget.customerId}', entriesJson);
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
  try{
    final summary = await repo.getRangeDashboard(widget.customerId, selectedDays);
    final entryData = await repo.getEntries(widget.customerId, selectedDays);

    setState(() {
      data = summary;
      entries = entryData;
      isLoading = false;
      isOffline = false;
    });
    await _saveToCache();
  }catch(e){
    setState(() => isOffline = true);
      // If no internet, cached data is already shown from initState
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Offline Mode - Showing cached data")),
      );
    } finally {
      setState(() => isLoading = false);
  }
  }
   void deleteEntry(String CustomerId) async {
    await repo.deletedata(CustomerId);
    await repo.recalculateBalance(CustomerId);
    setState(() {
      entries.removeWhere((c) => c.id == CustomerId);
    });
    await loadData();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Milk Dashboard"),
        actions: [
          if (isOffline)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Chip(label: Text("Offline"), backgroundColor: Colors.orange),
            ),
        ],
      ),
      body: Column(
        children: [
          // Buttons (7 / 15 / 30 Days)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _btn(7),
                _btn(15),
                _btn(30),
              ],
            ),
          ),

          const SizedBox(height: 8),

          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (data.isEmpty && entries.isEmpty)
            const Expanded(child: Center(child: Text("No Data Found")))
          else
            Expanded(
              child: Column(
                children: [
                  // First List - Summary (Range Dashboard)
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return MilkCardItem(item: item);
                      },
                    ),
                  ),

                  const Divider(height: 1, thickness: 1),

                    SafeArea(
                    child: 
                    ElevatedButton.icon(onPressed: (){
                      setState(() {
                        _showdetails =! _showdetails;
                      });
                    },
                    icon: Icon(_showdetails ? Icons.visibility_off : Icons.visibility),
                     label: Text(_showdetails ? 'Hide Detailed Entries' : 'show detailed Entries'),
                     ),
                  ),

                //  Second List - Detailed Daily Entries
                
                  if(_showdetails)
                  Expanded(
                    flex: 2,   // Give more space to detailed list
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 700,

                        child: Column(
                          children: [
                             Container(
                              color: Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: const [
                               Text("MilkDate"),
                                Text("Milk"),
                                Text("TodayFat"),
                                Text("TodayRate"),
                                Text("Amount"),
                                 Text("Recived"),
                                 Text("Paid"),
                                 Text("total Remaining"),
                ],
              ),
            ),
                 const Divider(height: 1,),
                            Expanded(
                              child: ListView.builder(
                                itemCount: entries.length,
                                itemBuilder: (context, index) {
                                  final item = entries[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                     child: MilkCardItems(item: item,
                                      onDelete: () async {
                                  final isLastEntry = item.id != entries.first.id;
                          if(isLastEntry){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('This entry cannot delete '),
                                ),
                                );
                                return;
                          }
                            /// ✅ ALLOW DELETE
                       final confirm = await showDialog<bool>(
                       context: context,
                        builder: (ctx) => AlertDialog(
                        title: const Text("Delete Entry?"),
                         content: const Text("This cannot be undone"),
                          actions: [
                           TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                       child: const Text("Cancel"),
                      ),
                  TextButton(
                   onPressed: () => Navigator.pop(ctx, true),
                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                   ),
                  ],
                ),
              );

              if (confirm == true) {
                deleteEntry(item.id);

              setState(()  {
                 entries.removeAt(index);
               });
             }
               },
          ),
                                   
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Button Widget
  Widget _btn(int days) {
    final isSelected = selectedDays == days;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.amber : null,
      ),
      onPressed: () {
        setState(() {
          selectedDays = days;
        });
        loadData();
      },
      child: Text("$days Days"),
    );
  }
}