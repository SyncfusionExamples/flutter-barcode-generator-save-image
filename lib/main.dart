import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barcode Generator Sample',
      home: BarcodeSample(),
    );
  }
}

class BarcodeSample extends StatefulWidget {
  const BarcodeSample({super.key});

  @override
  State<BarcodeSample> createState() => BarcodeSampleState();
}

class BarcodeSampleState extends State<BarcodeSample> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Barcode Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150.0,
              width: 400.0,
              child: RepaintBoundary(
                key: _globalKey,
                child: SfBarcodeGenerator(value: 'http://www.syncfusion.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: ElevatedButton(
                onPressed: _renderBarcodeImage,
                child: const Text('Barcode to image'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Converts the barcode widget to a PNG image and displays it in a new screen.
  /// This method captures the current state of the barcode widget using [RenderRepaintBoundary],
  /// converts it to a PNG image with 3x pixel ratio for better quality.
  /// The generated image is then displayed in a new route with a white background.

  Future _renderBarcodeImage() async {
    final RenderRepaintBoundary? boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) return;

    final ui.Image data = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? bytes =
        await data.toByteData(format: ui.ImageByteFormat.png);

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Container(
                color: Colors.white,
                child: Image.memory(bytes!.buffer.asUint8List()),
              ),
            ),
          );
        },
      ),
    );
  }
}
