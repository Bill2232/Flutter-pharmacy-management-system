import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:tugas1_login/pages/home.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  final List<Map<String, dynamic>> _data = [
    {'name': 'Product 1', 'brand': 'Brand A', 'price': 10, 'quantity': 5},
    {'name': 'Product 2', 'brand': 'Brand B', 'price': 20, 'quantity': 10},
    // Add more data as needed
  ];

  Future<void> _scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Scanner overlay color
      'Cancel', // Cancel button text
      true, // Use flash
      ScanMode.BARCODE, // Scan mode
    );

    if (!mounted) return;

    setState(() {
      // Handle barcode scan result
      print('Barcode: $barcodeScanRes');
      // Add your logic here to process the barcode scan result
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                    dropdownColor: Colors.white,
                    items: const [
                      DropdownMenuItem(
                        value: 'category1',
                        child: Text(
                          'Category 1',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'category2',
                        child: Text(
                          'Category 2',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      // Add more categories as needed
                    ],
                    onChanged: (value) {
                      // Handle category selection
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Sort By',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                    dropdownColor: Colors.white,
                    items: const [
                      DropdownMenuItem(
                        value: 'name',
                        child: Text(
                          'Name',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'price',
                        child: Text(
                          'Price',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      // Add more sorting options as needed
                    ],
                    onChanged: (value) {
                      setState(() {
                        // Handle sorting selection
                        if (value == 'name') {
                          _sortColumnIndex = 0;
                        } else if (value == 'price') {
                          _sortColumnIndex = 2;
                        }
                        _sortAscending = !_sortAscending;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortAscending: _sortAscending,
                sortColumnIndex: _sortColumnIndex,
                columns: [
                  DataColumn(
                    label: const Text('Name'),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortAscending = ascending;
                        _sortColumnIndex = columnIndex;
                        if (ascending) {
                          _data.sort((a, b) => a['name'].compareTo(b['name']));
                        } else {
                          _data.sort((a, b) => b['name'].compareTo(a['name']));
                        }
                      });
                    },
                  ),
                  const DataColumn(label: Text('Brand')),
                  DataColumn(
                    label: const Text('Price'),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortAscending = ascending;
                        _sortColumnIndex = columnIndex;
                        if (ascending) {
                          _data.sort((a, b) => a['price'].compareTo(b['price']));
                        } else {
                          _data.sort((a, b) => b['price'].compareTo(a['price']));
                        }
                      });
                    },
                  ),
                  const DataColumn(label: Text('Quantity')),
                ],
                rows: _data
                    .map(
                      (item) => DataRow(
                    cells: [
                      DataCell(Text(item['name'])),
                      DataCell(Text(item['brand'])),
                      DataCell(Text('\$${item['price']}')),
                      DataCell(Text('${item['quantity']}')),
                    ],
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanBarcode,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
