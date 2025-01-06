import 'package:flutter/material.dart';
import 'package:shopping_card/data/categories.dart';
import 'package:shopping_card/models/category.dart';
import 'package:shopping_card/models/grocery_item.dart';

class NewItem extends StatefulWidget{
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem>
{
  final _formKey=GlobalKey<FormState>();
  var _enteredName='';
  var _enterQuantity=1;
  var _selectedCategory=categories[Categories.vegetables]!;

  void _saveItem(){
    if(    _formKey.currentState!.validate()){
    _formKey.currentState!.save();
    Navigator.of(context).pop(GroceryItem(id: DateTime.now().toString(),
     name: _enteredName, 
     quantity: _enterQuantity, 
     category: _selectedCategory),
     );
    }
  }
 @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: const Text('Add new item'),
        ),
        body: Padding(
          padding:const EdgeInsets.all(12),
          child: Form(
            key: _formKey ,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Name')
                  ),
                  validator: (value){
                    if(value==null || 
                    value.isEmpty || 
                    value .trim().length<=1 || 
                    value.trim().length>50){
                    return 'Must be between 1 and 50 characters';
                  }
                  return null;
                  },
                  onSaved: (value){
                   // if(value==null){
                    //  return;
                   // }
                    _enteredName=value!;
                  },
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                   Expanded(child: TextFormField(
                      decoration: InputDecoration(
                        label: Text('Quantity'),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enterQuantity.toString(),
                      validator: (value){
                    if(value==null || 
                    value.isEmpty || 
                    int.tryParse(value)==null ||
                    int.tryParse(value)! <=0){
                    return 'Must be a valid positive number';
                  }
                  return null;
                  },
                  onSaved: (value){
                    _enterQuantity=int.parse(value!);
                  },
                    ),
                   ),
                    SizedBox(width: 8,),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                          for(final catergory in categories.entries)
                            DropdownMenuItem(
                              value: catergory.value,
                              child: Row(
                              children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: catergory.value.color,
                              ),
                              SizedBox(width: 6,),
                              Text(catergory.value.title)
                        ]
                        ),
                            )
                        ], 
                        onChanged: (value){
                          setState(() {
                            
                          _selectedCategory=value!;
                          });
                        }),
                    )
                  ],
                ),
                SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){
                      _formKey.currentState!.reset();
                    }, child:const Text('Reset')),
                    ElevatedButton(onPressed: _saveItem, child: const Text('Add Item'))
                  ],
                )
              ],
            ))
          ),
      
   );
  }
}