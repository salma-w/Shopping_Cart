import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:shopping_card/models/grocery_item.dart';
import 'package:shopping_card/widgets/new_item.dart';
class GroceryList  extends StatefulWidget{
const GroceryList({super.key,});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems=[];

void _addMethod () async{

final newItem=await Navigator.of(context).push<GroceryItem>
(MaterialPageRoute(
  builder: (ctx)=>const NewItem()
  ),
  );
  if(newItem ==null){
    return;
  }
  setState(() {
      _groceryItems.add(newItem);

  });
}

void _removeItem(GroceryItem item){
setState(() {
  _groceryItems.remove(item);
});
}

@override
  Widget build(BuildContext context) {
    Widget content=Center(child: Text('No Items added yet.'),);

    if(_groceryItems.isNotEmpty){
      content=ListView.builder
    (
      itemCount: _groceryItems.length,
      itemBuilder: (ctx,index)=>
      Dismissible(
        onDismissed: (direction){
          _removeItem(_groceryItems[index]);
        },
        key:ValueKey(_groceryItems[index].id),
        child: ListTile( 
          title:Text(_groceryItems[index].name),
          leading: Container(
            width: 24,
            height: 24,
           color:_groceryItems[index].category.color,
          ),
          trailing: Text(_groceryItems[index].quantity.toString()),
          ),
      ),
    );    
    }
   return Scaffold(
    appBar: AppBar(
      title: const Text('Your Groceries'),
      actions: [
        IconButton(
          onPressed: _addMethod, 
          icon: const Icon(Icons.add))
      ],
    ),
    body:content
   );
   }
}