import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:guest_book_app/helper/database.dart';
import 'package:guest_book_app/model/model.dart';
import 'package:sqflite/sqflite.dart';

class PdfApi {
  static Future<File> generateTable() async {
    DbHelper dbHelper = DbHelper();

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
              user.id,
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

    pdf.addPage(Page(
      build: (context) => Table.fromTextArray(
        headers: headers,
        data: data,
      ),
    ));

    return saveDocument(name: 'Form asnaf.pdf', pdf: pdf);
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
