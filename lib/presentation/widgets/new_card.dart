import 'package:flutter/material.dart';
import 'package:milkdy/data/models/sell_model.dart';
import 'package:milkdy/data/repositories/custumer_repo.dart';

class NewCard extends StatefulWidget{
  const NewCard({super.key});
  
  @override
  State<NewCard> createState() {
  return _NewCardState();    
  }
}

class _NewCardState extends State<NewCard>{

   final _textControllar = TextEditingController();
   final _phoneControllar = TextEditingController();
  //  FateCategory _fateCategory = FateCategory.hybrid;
  //  DateTime  _selectedDate =DateTime.now();

  bool _isLoading = false;
  String? _errormsg;
  String? _successMsg;

   late final CustomerRepo _reposetory;

   @override
  void initState() {
    super.initState();
    _reposetory = CustomerRepo();
  }
   

    // void _datePicker() async{
    //   final date = DateTime.now();
    //   final firstDate  = DateTime(date.year -1, date.month, date.day);
    //   final persentDate =await showDatePicker(context: context, initialDate: date, firstDate: firstDate, lastDate: date);
    //   if(persentDate != null){
    //   setState(() {
    //     _selectedDate = persentDate;
    //   });
    //   }
    // }

    void _saveData () async{
      String inputName = _textControllar.text.trim();
      String PhoneName = _phoneControllar.text.trim();
      if (inputName.isEmpty) {
    setState(() => _errormsg = 'Name and Phone both are required');
    return;
  }

      setState(() => _isLoading = true);
        try{
      
        // final customer = AddCustomerModel(
        //   name: inputName,
        //    phone: PhoneName
        //    );
       final newCustumer =
         await _reposetory.addCustumer(
          AddCustomerModel(
            name: inputName,
             phone: PhoneName
             ),);
         setState(() {
        _successMsg = 'Customer saved succesfully';
      });
      _textControllar.clear();
      _phoneControllar.clear();
      // save locally immidiatlly
       if(mounted) {
        Navigator.pop(context, newCustumer);
       }
      
        }catch(e){
        setState(() =>
         _errormsg = 'Error saving data: $e');
      }finally{
        setState(() => _isLoading = false);
      }
    }

  
    
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
       //  mainAxisAlignment: MainAxisAlignment.end,
         crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
             controller: _textControllar,
              maxLength: 20,
              decoration: InputDecoration(
                label: Text('Name'),
              ),
            ),
            SizedBox(height: 8,),
             TextField(
             controller: _phoneControllar,
             keyboardType: TextInputType.phone,
              maxLength: 20,
              decoration: InputDecoration(
                label: Text('Phone'),
              ),
            ),
          //  Row(
          //   children: [
          //     Expanded(
          //       child: DropdownButton(
          //         borderRadius: BorderRadius.circular(20),
          //         value: _fateCategory,
          //         items: FateCategory.values.map((fatecategory) => 
          //         DropdownMenuItem(
          //           value: fatecategory,
          //           child: Text(fatecategory.name.toUpperCase(),),
          //           ),
          //         ).toList(),
          //          onChanged: (value){
          //           if(value == null){
          //             return;
          //           }
          //           setState(() {
          //             _fateCategory =value;
          //           });
          //          }
          //          ), 
          //     ),
          //     const SizedBox(width: 16,),
              
          //     Expanded(
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           Text(formatter.format(_selectedDate)), 
          //            IconButton(
          //               onPressed: (){
          //                 _datePicker();
          //               },
          //               icon: Icon(Icons.calendar_month),
          //               ),
                    
          //         ],
          //       ),
          //     )
          //   ],
          //  ),
           SizedBox(height: 30,),
           Row(
             children: [
               TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                 child: Text('Cencal'),
                 ),
             
           SizedBox(width: 30,),
           ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 40),
            ),
            onPressed: _isLoading ? null : _saveData,
             child: _isLoading 
             ? const SizedBox(width: 20, height: 20, 
             child: CircularProgressIndicator(
              strokeWidth: 2, color: Colors.white,),)
             : const Text('Save'),
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
    _textControllar.dispose();
    _phoneControllar.dispose();
    super.dispose();
    
  }
}
