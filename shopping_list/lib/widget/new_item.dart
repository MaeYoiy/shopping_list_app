import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItem();
  }
}

class _NewItem extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;

  void _saveItem() async {
    //ถ้าเป็นจริงจะทำการ Save
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      final url = Uri.https('flutter-prep-7b448-default-rtdb.firebaseio.com',
          'shopping-list.json');

      final response = await http.post(
        url,
        // headers เป็นรูปแบบ json
        headers: {
          'Content-Type': 'application/json',
        },
        // body เป็นข้อมูลการ save item ที่เราได้ add ไปโดยเรา encode เพื่อแปลง body เป็น json ซึ่งเราจะใช้ map
        // ซึ่ง firebase จะ generate 'id' ให้เราเอง
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _selectedCategory.title,
          },
        ),
      );

      print(response.body);
      print(response.statusCode);

      final Map<String, dynamic> resData = json.decode(response.body);

      if (context.mounted) {
        Navigator.of(context).pop(
          GroceryItem(
              id: resData['name'],
              name: _enteredName,
              quantity: _enteredQuantity,
              category: _selectedCategory),
        );
      }

      // if (!context.mounted) {
      //   return;
      // }
      // Navigator.of(context).pop();

      // print(_enteredName);
      // print(_enteredQuantity);
      // print(_selectedCategory);
      // Navigator.of(context).pop(
      //   GroceryItem(
      //       id: DateTime.now().toString(),
      //       name: _enteredName,
      //       quantity: _enteredQuantity,
      //       category: _selectedCategory),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 character.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                // ทำให้ row TextFormField และ row DropdownButtonFormField อยู่ในระนาบเดียวกัน
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            // แปลงจาก String '1' => int 1
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid, position number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        // ข้อแตกต่างระหว่าง parse กับ tryParse คือ parse จะส่งข้อผิดผลาดหากไม่สามารถแปลงสตริงเป็นตัวเลขได้
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                // ทำการจัดแกนหลักซึ่งก็คือแกนแนวนอน ( ตาม Row ) ให้ถูกดันจนสุดตามแนวแกน ( ซึ่งก็คือดันทั้ง TextButton และ ElevatedButton ไปขวาสุด)
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Add Item'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
