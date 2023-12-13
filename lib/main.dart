// add http package: flutter pub add http
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _formKey = GlobalKey<FormState>();
  var _item = '';
  var _quantity = 0;

  void _savedItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      debugPrint('Item: $_item, quantity: $_quantity');
      final url = Uri.https(
          'flutter-groceries-41c15-default-rtdb.asia-southeast1.firebasedatabase.app',
          'shopping-groceries.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _item,
            'quantity': _quantity,
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Form Validation')),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Item',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _item = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Quantity',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null ||
                        int.tryParse(value)! <= 0) {
                      return 'Must be a valid, positive number.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _quantity = int.tryParse(value!)!;
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    _savedItem();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
