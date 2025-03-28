import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:financial_dashboard/features/invoices/presentation/pages/create_invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CreateInvoiceRouter {
  final String path;
  final GlobalKey<NavigatorState> navigatorKey;

  CreateInvoiceRouter({required this.path, required this.navigatorKey});
  GoRoute get route => GoRoute(
    parentNavigatorKey: navigatorKey,
    path: path,
    pageBuilder: (context, state) => NoTransitionPage(child: CreateInvoicePage()),
    // pageBuilder: (context, state) => NoTransitionPage(child: PdfExportScreen()),
  );
}

class PdfExportScreen extends StatefulWidget {
  @override
  _PdfExportScreenState createState() => _PdfExportScreenState();
}

class _PdfExportScreenState extends State<PdfExportScreen> {
  GlobalKey globalKey = GlobalKey();

  Future<Uint8List> _captureWidgetToImage() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _generatePdfAndDownload() async {
    final pdf = pw.Document();
    final imageBytes = await _captureWidgetToImage();

    final image = pw.MemoryImage(imageBytes);
    pdf.addPage(
      pw.Page(build: (pw.Context context) => pw.Center(child: pw.Image(image))),
    );

    // Save and download PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Export Widget to PDF")),
      body: Column(
        children: [
          RepaintBoundary(
            key: globalKey,
            child: Container(
              color: Colors.blue[100],
              padding: EdgeInsets.all(16),
              child: Text(
                "This widget will be exported as a PDF!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _generatePdfAndDownload,
            child: Text("Export to PDF & Download"),
          ),
        ],
      ),
    );
  }
}
