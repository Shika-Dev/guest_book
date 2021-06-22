import 'dart:io';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:guest_book_app/helper/database.dart';
import 'package:guest_book_app/model/model.dart';

class PdfApi {
  static Future<File> generateTable() async {
    var count = 1;
    DbHelper dbHelper = DbHelper();
    DateTime now = new DateTime.now();
    var date = new DateFormat('dd-MM-yyy hh:mm:ss');
    String formattedDate = date.format(now);

    final pdf = Document();

    final headers = [
      'No',
      'Nama Lengkap',
      'Nama Istri',
      'Bin/Binti',
      'Almarhum',
      'Almarhumah',
      'Alamat',
      'Telephone',
      'Kali',
      'Besar'
    ];

    List<Guest> users = await dbHelper.getGuestList();

    final data = users
        .map((user) => [
              count++,
              user.name,
              user.namaIstri,
              user.bin,
              user.alm1,
              user.alm2,
              user.alamat,
              user.telp,
              user.kali,
              user.besar
            ])
        .toList();

    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.landscape,
        build: (context) => [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FORM ASNAF',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0.8 * PdfPageFormat.cm),
                  Text(formattedDate),
                  SizedBox(height: 0.8 * PdfPageFormat.cm),
                  Text('Jumlah data : ' + (count - 1).toString()),
                  SizedBox(height: 0.8 * PdfPageFormat.cm),
                ],
              ),
              buildInvoice(headers, data)
            ]));

    return saveDocument(name: 'Form asnaf.pdf', pdf: pdf);
  }

  static Widget buildInvoice(headers, data) {
    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
        6: Alignment.centerLeft,
        7: Alignment.centerLeft,
        8: Alignment.centerLeft,
        9: Alignment.centerLeft,
      },
    );
  }

  static Future<File> saveDocument({
    String name,
    Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
