import 'package:doctro/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:nbrg_pdf_viewer_flutter/nbrg_pdf_viewer_flutter.dart';

class PdfViewerPage extends StatelessWidget {
  final String? path;
  const PdfViewerPage({Key? key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: path!,
      appBar:PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: Container(color: colorWhite),
    ),
    );
  }
}