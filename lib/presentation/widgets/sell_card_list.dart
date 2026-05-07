import 'package:flutter/material.dart';
import 'package:milkdy/data/models/sell_model.dart';
import 'package:milkdy/data/repositories/custumer_repo.dart';
import 'package:milkdy/presentation/widgets/sell_card_items.dart';

class SellCardList extends StatefulWidget{
   SellCardList ({super.key});

  @override
  State<SellCardList> createState() => SellCardListState();
}

class SellCardListState extends State<SellCardList> {
 final _searchControllar = TextEditingController();
   List<CustumerModel> _customers = [];
   List<CustumerModel> _filterCustomers = [];
   bool _isLoading = true;
   String? _errorMessage;

   @override
  void initState() {
    super.initState();
    _loadCustomers();
    _searchControllar.addListener(_filterdCustomers);
  }
  @override
  void dispose() {
    _searchControllar.dispose();
    super.dispose();
  }

   Future<void> _loadCustomers({bool showLoading = true,}) async{
    if(showLoading){
      setState(() {
        _isLoading = true;
      });
    }
    final data = await CustomerRepo().fetchCustomer();
   try{
    setState(() {
      _customers = data;
      _filterCustomers = List.from(data);
      _isLoading = false;
      _errorMessage = null;
    });
   } catch (e) {
    setState(() {
      _errorMessage = e.toString();
      _isLoading = false;
    });
   }
   }

   void addNewCustomer(CustumerModel newCustomer) {
    setState(() {
       _customers.insert(0, newCustomer);       
      _filterCustomers.insert(0, newCustomer);
    });
   }

  void _filterdCustomers(){
    final Query = _searchControllar.text.trim().toLowerCase();
    setState(() {
    if(Query.isEmpty){
      _filterCustomers = List.from(_customers);
    }else{
      _filterCustomers = _customers.where((customer){
        final name = customer.name.toString().toLowerCase();
        return name.contains(Query);
      }).toList();
    }
     });
  }

  Future<void> removeCustomer(String customerId) async {
  try {
    await CustomerRepo().deleteCustomer(customerId);

    setState(() {
      _customers.removeWhere((c) => c.id == customerId);
      _filterCustomers.removeWhere((c) => c.id == customerId);
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Customer deleted successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to delete. Something went wrong')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
  
      if(_isLoading){
      return const Center(child: CircularProgressIndicator(),);
      }
      if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error loading customers',//:\n$_errorMessage',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _loadCustomers(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
     if(_customers.isEmpty){
  return Center(
    child: Text(
        'Ooh! there is no listing! please add custumers'
    ),
  );
}
        return Column(
          children: [
                TextField(
                  controller: _searchControllar,
                  decoration: InputDecoration(
                    label: Text('Search'),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchControllar.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchControllar.clear();
                  },
                )
              : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
       
  const SizedBox(height: 10,),
       Expanded(
         child:   _filterCustomers.isEmpty
           ?  Center(
             child: Text(
        'No customers  matching your search',
    ),
  )
         : RefreshIndicator(
          onRefresh: () => _loadCustomers(showLoading: false),
          child: ListView.builder(
            itemCount: _filterCustomers.length,
            itemBuilder: (context, index){
              final  custumer= _filterCustomers[index];
              return SellCardItems(customer: custumer,
            onDelete: () async {
            final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
            title: const Text('Delete Customer?'),
           content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), 
        child: const Text('Cancel')),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirm == true) {
    removeCustomer(custumer.id);
  }
},
          );
        },
       ),
     ),),
   ],);
 }
}

