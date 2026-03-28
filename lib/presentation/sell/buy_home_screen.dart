import 'package:flutter/material.dart';
import 'package:milkdy/data/models/sell_model.dart';
import 'package:milkdy/data/repositories/auth_repo.dart';
import 'package:milkdy/data/repositories/initialise.dart';
import 'package:milkdy/presentation/sell/user_profle_screen.dart';
import 'package:milkdy/presentation/widgets/new_card.dart';
import 'package:milkdy/presentation/widgets/sell_card_list.dart';


class BuyHomeScreen extends StatefulWidget{
  const BuyHomeScreen ({super.key});


  @override
  State<BuyHomeScreen> createState() {
    return _HomeScreenDistState();    
  }

}

class _HomeScreenDistState extends State<BuyHomeScreen>{
  final GlobalKey<SellCardListState> _listKey = GlobalKey<SellCardListState>();

   void _newCardoverlay() async{
     final result = await showModalBottomSheet<CustumerModel?>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
       builder: (ctx) => NewCard(),
        );
       
        if(result != null ){
       _listKey.currentState?.addNewCustomer(result);
        }
  }

  @override
  Widget build(BuildContext context) {
     if (supabase.auth.currentSession == null ) {
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginUser()),
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
   return Scaffold(
    floatingActionButton: FloatingActionButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (ctx)=> ProfileScreen(),),);}, ),
    appBar: AppBar(
      backgroundColor: Colors.amber,
      title: Text('Distribution'),
      actions: [
        IconButton(
          onPressed: _newCardoverlay, 
          icon: Icon(Icons.add),
        ),
      ],
      
    ),
    body: Padding(
      padding: const EdgeInsetsGeometry.symmetric(
        vertical: 5, 
        horizontal: 5,
      ),
      child: SellCardList(key: _listKey,),
    ),
   );

  }
}