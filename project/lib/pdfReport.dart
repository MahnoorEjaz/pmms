import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PdfReport {
  // Example method to generate and save a PDF report
  Future<void> generatePdfReport() async {
    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    // Create a file in the documents directory
    final file = File('$path/report.pdf');

    // Perform your PDF generation and save it to the file
    // Example: Write "Hello, PDF!" to the file
    await file.writeAsString('Hello, PDF!');

    // Print the file path for verification
    print('PDF Report saved to: ${file.path}');
  }
}

// void main() async {
//   // Ensure that plugins are initialized before runApp
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Create an instance of PdfReport
//   final pdfReport = PdfReport();
//
//   // Generate and save the PDF report
//   await pdfReport.generatePdfReport();
//
//   runApp(MyApp());
// }