import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milkdy/data/repositories/milk_entry_repo.dart';
import 'package:milkdy/provider/milk_entry_repo_provider.dart';

class NewMilkEntryCard extends ConsumerStatefulWidget {
  const NewMilkEntryCard({super.key, required this.customerId});
  final String customerId;

  @override
  ConsumerState<NewMilkEntryCard> createState() => _NewMilkEntryCardState();
}

class _NewMilkEntryCardState extends ConsumerState<NewMilkEntryCard> {
  final _formKey = GlobalKey<FormState>();
  final _litersControllar = TextEditingController();
  final _actualFatControllar = TextEditingController();
  final _dailyRateControllar = TextEditingController();
  final _receivedControllar = TextEditingController();
  final _paidControllar = TextEditingController();
  final _feedControllar = TextEditingController();
  String fatType = "non_fat";   
  double fatBase = 60;          
  String? entryType; 
  DateTime _selectedDate =DateTime.now();
  String? successmssg;
  String? errormssg;
  bool _isSaving =false;

  void _datePicker()async{
    final date = DateTime.now();
    final firstDate =  DateTime(date.year, date.month, date.day - 3);
    final persentDate = await showDatePicker(
      context: context,
      initialDate: date,
       firstDate: firstDate,
        lastDate: date
        );
    if(persentDate != null){
      setState(() {
        _selectedDate = persentDate;
      });
    }
  }

  void _saveMilk() async{
   

    double liters = double.tryParse(_litersControllar.text)?? 0;
    double fat = double.tryParse(_actualFatControllar.text) ?? 0;
    double rate = double.tryParse(_dailyRateControllar.text)?? 0;
    double received = double.tryParse(_receivedControllar.text)?? 0;
    double paid = double.tryParse(_paidControllar.text)?? 0;
    String feedValue = _feedControllar.text.trim();

  try{
    final _newRepo = ref.read(milkEntryRepoProvider);
    await _newRepo.addMilkEntry(
       customerId: widget.customerId,
       date: _selectedDate,
       liters: liters,
       fat: fat,
       rate: rate,
       received: received,
       paid: paid,
       feedValue: feedValue,
       fatType: fatType,
       fatbase: fatBase,
       entryType: entryType!,
        );

        ref.invalidate(getEntriesProvider);
        ref.invalidate(getMonthlyCollectionProvider);
        ref.invalidate(getpdfDataProvider);
    setState(() {
      successmssg = 'Saved successfully';
    });
    _litersControllar.clear();
    _actualFatControllar.clear();
    _dailyRateControllar.clear();
    _receivedControllar.clear();
    _paidControllar.clear();
    _feedControllar.clear();
    if(mounted){
      Navigator.pop(context);
    }

  }catch(e){
    setState(() {
      _isSaving = false;
      errormssg = 'Failed to save entry. Something went wrong';
    });
  }
  
  }
  @override
 Widget build(BuildContext context) {
  return Padding(
   padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom, 
    ),
    child: Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView (
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 4, width: 40,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ), 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
                    child: Column(
                      children: [
                      DropdownButtonFormField<String>(
                      value: entryType,
                      isExpanded: true,
                       borderRadius: BorderRadius.circular(8),
                      hint: const Text("Select Entry Type"),
                     items: const [
                    DropdownMenuItem(value: "distribution", child: Text("Distribution")),
                    DropdownMenuItem(value: "collection", child: Text("Collection")),
                  ],
                    onChanged: (v) {
                    setState(() => entryType = v!);
                },
                   validator: (value){
                if (value == null || value.isEmpty) {
                  return 'Please select an entry type';
                }
                return null;
                },
                ),
                  const SizedBox(height: 20),
                        // Liters
                        TextFormField(
                          controller: _litersControllar,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Quantity (Liters)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                
                        const SizedBox(height: 20),
                
                        TextFormField(
                          controller: _actualFatControllar,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Your milk Fat ',
                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 20),
                
                        // Fat Section 
                        Row(
                          children: [
                            // Fat Type 
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: fatType,
                                decoration: InputDecoration(
                                  labelText: 'Fat Type',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                items: const [
                                  DropdownMenuItem(value: "non_fat", child: Text("Non Fat")),
                                  DropdownMenuItem(value: "fixed", child: Text("Fixed Fat")),
                                ],
                                onChanged: (val) {
                                  setState(() => fatType = val!);
                                },
                              ),
                            ),
                
                            const SizedBox(width: 12),
                
                            if (fatType == "fixed")
                              Expanded(
                                child: DropdownButtonFormField<double>(
                                  value: fatBase,
                                  decoration: InputDecoration(
                                    labelText: 'Fat Value',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 50, child: Text("50 Fat")),
                                    DropdownMenuItem(value: 55, child: Text("55 Fat")),
                                    DropdownMenuItem(value: 60, child: Text("60 Fat")),
                                    DropdownMenuItem(value: 65, child: Text("65 Fat")),
                                  ],
                                  onChanged: (val) {
                                    setState(() => fatBase = val!);
                                  },
                                ),
                              ),
                          ],
                        ),
                
                        const SizedBox(height: 20),
                
                        // Daily Rate
                        TextFormField(
                          controller: _dailyRateControllar,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Your Rate per Liter',
                            prefixText: '₹',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                
                        const SizedBox(height: 20),
                
                        // Received Money
                          Row(
                            children: [
                              if(entryType == "distribution")
                              Expanded(
                                child: TextFormField(
                                  controller: _receivedControllar,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Money you received OR Feed cost',
                                    prefixText: '₹',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                          //   ],
                          // ),
                          const SizedBox(width: 12),
                          if(entryType == "collection")
                           Expanded(
                             child: TextFormField(
                              controller: _paidControllar,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Money you paid OR Feed cost',
                                prefixText: '₹',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                                             ),
                           ),
                            ],
                          ),
                
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _feedControllar,
                                keyboardType: TextInputType.text,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  labelText: 'Feed or Name!',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                              IconButton(
                                onPressed: _datePicker,
                                icon: const Icon(Icons.calendar_month, size: 32),
                              ),
                                ],
                              ),
                            ),
                          ],
                        ),
                
                        const SizedBox(height: 40),
                
                        // Cancel & Save Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(150, 48),
                              ),
                              onPressed: _isSaving ? null 
                              :  (){
                              if (_formKey.currentState!.validate()) {
                             _saveMilk(); 
                              }
                              },
                              child: _isSaving ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.grey,
                              ),
                              )
                              : const Text('Save'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    ),
  );
}
  @override
  void dispose() {
    _litersControllar.dispose();
    _actualFatControllar.dispose();
    _dailyRateControllar.dispose();
    _paidControllar.dispose();
    _receivedControllar.dispose();
    _feedControllar.dispose();
    super.dispose();
  }
}