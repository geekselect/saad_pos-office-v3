import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';

class Dummy extends StatelessWidget {
  final double totalAmount;
   Dummy({Key? key, required this.totalAmount}) : super(key: key);
  void testReceipt(NetworkPrinter printer) {
    printer.text("${totalAmount.toString()}");
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    printer.text('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: 'CP1252'));

    printer.text('Bold text', styles: PosStyles(bold: true));
    printer.text('Reverse text', styles: PosStyles(reverse: true));
    printer.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    printer.text('Align left', styles: PosStyles(align: PosAlign.left));
    printer.text('Align center', styles: PosStyles(align: PosAlign.center));
    printer.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    printer.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    printer.feed(2);
    printer.cut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: ()   async {
          const PaperSize paper = PaperSize.mm80;
          final profile = await CapabilityProfile.load();
          final printer = NetworkPrinter(paper, profile);
          print('Print result: ${printer}');


          final PosPrintResult res = await printer.connect('192.168.18.62', port: 9100);

          if (res == PosPrintResult.success) {
            testReceipt(printer);
            printer.disconnect();
          }

          // print('Print result: ${res.msg}');
        }, child: Text("Print"),),
      ),
    );
  }
}
