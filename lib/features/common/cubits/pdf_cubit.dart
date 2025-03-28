import 'dart:ui' as ui;

import 'package:financial_dashboard/features/common/cubits/pdf_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PdfCubit extends Cubit<PdfState> {
  PdfCubit() : super(PdfInitial());

  Future<void> generatePdfAndDownload(GlobalKey widgetKey) async {
    try {
      emit(PdfLoading());

      await Future.delayed(Duration(milliseconds: 1000));

      final pdfBytes = await compute(_generatePdf, widgetKey);

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );

      emit(PdfLoaded());
    } catch (e) {
      emit(PdfError(message: 'Error generating PDF: $e'));
    }
  }

  // ฟังก์ชันแยกงานหนักไปใน compute()
  Future<Uint8List> _generatePdf(GlobalKey widgetKey) async {
    final pdf = pw.Document();
    final imageBytes = await _captureWidgetToImage(widgetKey);

    final image = pw.MemoryImage(imageBytes);
    pdf.addPage(
      pw.Page(build: (pw.Context context) => pw.Center(child: pw.Image(image))),
    );

    return pdf.save();
  }

  Future<Uint8List> _captureWidgetToImage(GlobalKey widgetKey) async {
    RenderRepaintBoundary boundary =
        widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 1.5);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
