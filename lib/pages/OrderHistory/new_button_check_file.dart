import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewFile extends StatelessWidget {
  const NewFile({Key? key}) : super(key: key);

  printKitchenReceipt(NetworkPrinter printer) {
    // // Print image
    // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
    // final Uint8List bytes = data.buffer.asUint8List();
    // final img.Image? image = img.decodeImage(bytes);
    // printer.image(image!);

    // printer.text("*** PRINT ***",
    //     styles: PosStyles(
    //       align: PosAlign.center,
    //       height: PosTextSize.size2,
    //       width: PosTextSize.size2,
    //       reverse: true
    //     ),);

    printer.text("*** Kitchen ***",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    printer.hr(ch: '=', linesAfter: 1);

    printer.feed(2);
    printer.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    printer.feed(1);
    printer.cut();
  }

  void testPrintKitchen(BuildContext ctx) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res =
        await printer.connect('nasirkhanems.nayatel.net', port: 8888);

    if (res == PosPrintResult.success) {
      testReceipt(printer);
      printer.disconnect();
    }

    print('Print result: ${res.msg}');
    // // TODO Don't forget to choose printer's paper size
    // const PaperSize paper = PaperSize.mm80;
    // final profile = await CapabilityProfile.load();
    // final printer = NetworkPrinter(paper, profile);
    // // final PosPrintResult res = await printer.connect(
    // //   'nasirkhanems.nayatel.net',
    // //   port: 8888,
    // // );
    // //
    // // Get.snackbar("", res.msg);
    // //
    // // print('Print result: ${res.msg}');
    // printer.connect('203.175.78.102', port: 8888).then((printer) {
    //   print("printer ${printer.msg}");
    // }).catchError((e) {
    //   //handle the exception the way you want, like following
    //   print('Caught error when processing: $e');
    // });
  }

  void testReceipt(NetworkPrinter printer) {
    printer.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
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
      child: TextButton(
        onPressed: () {
          testPrintKitchen(context);
        },
        child: Text("Print"),
      ),
    ));
  }
}
