import 'package:flutter/material.dart';
import 'package:milkdy/data/repositories/milk_entry_repo.dart';

class NewMilkEntryCard extends StatefulWidget{
  const NewMilkEntryCard({super.key, required this.customerId});
  final String customerId;

  @override
  State<NewMilkEntryCard> createState() => _NewMilkEntryCardState();
}

class _NewMilkEntryCardState extends State<NewMilkEntryCard> {
  final _litersControllar = TextEditingController();
  final _actualFatControllar = TextEditingController();
  final _dailyRateControllar = TextEditingController();
  final _receivedControllar = TextEditingController();
  final _paidControllar = TextEditingController();
  late final MilkRepo _milkRepo;
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

  try{
    
    await _milkRepo.addMilkEntry(
       customerId: widget.customerId,
       date: _selectedDate,
       liters: liters,
       fat: fat,
       rate: rate,
       received: received,
       paid: paid,
       feedValue: 'feed',
        );
    setState(() {
      successmssg = 'Saved successfully';
    });
    _litersControllar.clear();
    _actualFatControllar.clear();
    _dailyRateControllar.clear();
    _receivedControllar.clear();
    _paidControllar.clear();
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
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 16,
        ),
        child: Column(
          children: [
                          TextField(
                            controller: _litersControllar,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: Text('Quantity'),
                              prefixText: 'Liters',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),

                          ),
                   
                  const SizedBox(height: 20,),
                      TextField(
                        controller: _actualFatControllar,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: Text('Your  Fat'),
                        prefixText: 'Fat',
                         border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                      ),
                  ),
                   const SizedBox(height: 20,),
                
               TextField(
                  controller: _dailyRateControllar,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text('Your Rate per liter'),
                    prefixText: '₹',
                     border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                     ),
                  ),
                ),
                                  
               const SizedBox(height: 20,),
                 TextField(
                       controller: _receivedControllar,
                       keyboardType: TextInputType.number,
                       decoration: InputDecoration(
                       label: Text('Money you will receive'),
                       prefixText: '₹',
                       border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                       ),
                  ),
               ),
            
                const SizedBox(height: 20,),

             Row(
               children: [
                 Expanded(
                   child: TextField(
                    controller: _paidControllar,
                             keyboardType: TextInputType.number,
                             decoration: InputDecoration(
                               label: Text('Money you paid'),
                               prefixText: '₹',
                               border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                             ),
                           ),
                 ),                 
                    const SizedBox(width: 10,),
                     Expanded(
                       child:  Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                      //  crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           IconButton(
                            onPressed: (){
                            _datePicker();
                           },
                            icon: Icon(Icons.calendar_month, size: 30,),
                            ),
                         ],
                       ),
                     ),
                       ],
             ),
             const SizedBox(height: 30,),
             Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  ),
                const SizedBox(width: 10,),
               ElevatedButton(
                 style: ElevatedButton.styleFrom(
                 minimumSize: const Size(150, 40),
                 ),
                onPressed: _saveMilk,
                child: Text('Save'),
                ),                 
              ],
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
    super.dispose();
  }
}