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
 
  bool _isLoading = false;
  String? _errormsg;
  String? _successMsg;

   late final CustomerRepo _reposetory;

   @override
  void initState() {
    super.initState();
    _reposetory = CustomerRepo();
  }

    void _saveData () async{
      String inputName = _textControllar.text.trim();
      String PhoneName = _phoneControllar.text.trim();
      if (inputName.isEmpty) {
    setState(() => _errormsg = 'Name and Phone both are required');
    return;
  }

      setState(() => _isLoading = true);
        try{
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
         _errormsg = 'Error saving data: something went wrong');
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
