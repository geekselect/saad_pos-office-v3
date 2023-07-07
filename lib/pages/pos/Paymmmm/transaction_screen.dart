import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionScreen extends StatefulWidget {

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(title: Text('Transaction Payment')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Stack(
          alignment: Alignment.topCenter, // Align the dialog at the top center
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
                SizedBox(height: 16.0),
                // ElevatedButton(
                //   onPressed: transactionPayment,
                //   child: Text('Pay'),
                // ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

