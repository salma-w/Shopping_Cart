import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_card/data/categories.dart';

import 'package:shopping_card/models/grocery_item.dart';
import 'package:shopping_card/widgets/new_item.dart';
class GroceryList  extends StatefulWidget{
const GroceryList({super.key,});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
   final List<GroceryItem> _groceryItems=[];

 //  var _isLoading=true;
 late Future <List<GroceryItem>>_loadedItems;
   String? _error;

@override
  void initState() {
    super.initState();
   _loadedItems= _loadItems();
  }

   Future<List<GroceryItem>> _loadItems()async{
 final url=Uri.https('flutter-prep-708ec-default-rtdb.firebaseio.com','shopping-list.json');
 // try{
  final response= await http.get(url);
    if(response.statusCode>=400){
   // setState(() {
    //  _error='Failed to fetch data. please try again';

  //  });
  }
  if(response.body=='null')
  {
  //  setState(() {
   //   _isLoading=false;
  //  });
    return [];
  }
  final Map<String, dynamic> listData=json.decode(response.body);
  final List<GroceryItem> loadedItem=[];
  for (final item in listData.entries){
    final catergory=categories.entries.firstWhere((catItem)=>catItem.value.title==item.value['category']).value;
    loadedItem.add(
      GroceryItem(
        id: item.key, 
        name: item.value['name'], 
        quantity: item.value['quantity'], 
        category: catergory)
        );

 }
  return loadedItem;
 // setState(() {
   // _groceryItems=loadedItem;
  //  _isLoading=false;
 // });
  //}
//  catch (error){
   // throw Exception(error);
     //  setState(() {
   //   _error='Something went wrong';

   // });
 // }

  }

void _addItem () async{

final newItem=await Navigator.of(context).push<GroceryItem>
(MaterialPageRoute(
  builder: (ctx)=>const NewItem()
  ),
  );
// _loadItems();
if(newItem==null){
return;}

setState(() {
  _groceryItems.add(newItem);
});
}

void _removeItem(GroceryItem item) async{
  final index=_groceryItems.indexOf(item);
  setState(() {
  _groceryItems.remove(item);
});

   final url=Uri.https('flutter-prep-708ec-default-rtdb.firebaseio.com','shopping-list/${item.id}.json');
 final response=await   http.delete(url);
 if(response.statusCode>=400){
//    setState(() {
 // _groceryItems.insert(index,item);
//});
throw Exception('Failed to fetch grocery items. Please try again later');
 }
}

@override
  Widget build(BuildContext context) {
  //  Widget content=Center(child: Text('No Items added yet.'),);

    //if(_error !=null){
      //content=Center(child: Text((_error)!),);
   // }
   return Scaffold(
    appBar: AppBar(
      title: const Text('Your Groceries'),
      actions: [
        IconButton(
          onPressed: _addItem, 
          icon: const Icon(Icons.add))
      ],
    ),
    body:FutureBuilder(
      future: _loadedItems, 
      builder: (context,snapshot)
      {
        if(snapshot.connectionState == ConnectionState.waiting){
    return Center(
        child: CircularProgressIndicator(),
      );
        }
        if(snapshot.hasError){
          return   Center(child: Text((snapshot.error.toString()
          ),
          ),
          );
        }
        if(snapshot.data!.isEmpty){
          return Center(child: Text('No Items added yet.'),);
        }
        return ListView.builder
    (
      itemCount: snapshot.data!.length,
      itemBuilder: (ctx,index)=>
      Dismissible(
        onDismissed: (direction){
          _removeItem(snapshot.data![index]);
        },
        key:ValueKey(snapshot.data![index].id),
        child: ListTile( 
          title:Text(snapshot.data![index].name),
          leading: Container(
            width: 24,
            height: 24,
           color:snapshot.data![index].category.color,
          ),
          trailing: Text(snapshot.data![index].quantity.toString()),
          ),
      ),
    );    
      }
    )
   );
   }
}