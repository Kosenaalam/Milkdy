import 'package:flutter/material.dart';
import 'package:milkdy/data/repositories/milk_entry_repo.dart';

class NewMilkEntryCard extends StatefulWidget{
  const NewMilkEntryCard({super.key, required this.customerId});
  final String customerId;

  @override
  State<NewMilkEntryCard> createState() => _NewMilkEntryCardState();
}

class _NewMilkEntryCardState extends State<NewMilkEntryCard> {
  final _formKey = GlobalKey<FormState>();
  final _litersControllar = TextEditingController();
  final _actualFatControllar = TextEditingController();
  final _dailyRateControllar = TextEditingController();
  final _receivedControllar = TextEditingController();
  final _paidControllar = TextEditingController();
  final _feedControllar = TextEditingController();
  late final MilkRepo _milkRepo;
  String fatType = "non_fat";   // default
  double fatBase = 60;          // default
  String? entryType; // Make it nullable
  DateTime _selectedDate =DateTime.now();
  String? successmssg;
  String? errormssg;

  @override
  void initState() {
    super.initState();
    _milkRepo = MilkRepo();
  }
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
     print('clicked');
    await _milkRepo.addMilkEntry(
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
        print('saved');
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
      errormssg = 'Failed to save entry: ${e.toString()}';
    });
  }
  
  }
  @override
 Widget build(BuildContext context) {
  final mediaQuery = MediaQuery.of(context).size.height;
  return Container(
    height: mediaQuery * 0.95,
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 4, width: 40,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
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
            
                    // Fat Section - Now in ONE clean line
                    Row(
                      children: [
                        // Fat Type (Non-Fat / Fixed)
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
            
                        // Fixed Fat Value (only show when Fixed is selected)
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
                                labelText: 'Money you received',
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
                            labelText: 'Money you paid',
                            prefixText: '₹',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                                         ),
                       ),
                        ],
                      ),
            
                    const SizedBox(height: 10),
            
                    // Paid + Date Picker in one line
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _feedControllar,
                            keyboardType: TextInputType.text,
                            maxLength: 15,
                            decoration: InputDecoration(
                              labelText: 'Feed or Name!',
                             // prefixText: '₹',
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
                          onPressed: (){
                          if (_formKey.currentState!.validate()) {
                         _saveMilk(); 
                        print("Form is valid, saving...");
                          }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
                 ),
          ),
        ],
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