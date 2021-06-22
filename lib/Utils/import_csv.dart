import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guest_book_app/UI/ui_home.dart';
import 'package:guest_book_app/helper/database.dart';
import 'package:guest_book_app/model/model.dart';

class LoadCsvDataScreen extends StatelessWidget {
  final String path;

  LoadCsvDataScreen({this.path});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textStyle = TextStyle(
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: Colors.white,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Import Data"),
        backgroundColor: Color(0xff2C977D),
      ),
      body: FutureBuilder(
        future: loadingCsvData(path),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          return snapshot.hasData
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/Images/Group_17.png',
                        width: MediaQuery.of(context).size.width * .5,
                        fit: BoxFit.fitWidth),
                    SizedBox(height: MediaQuery.of(context).size.height * .02),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Text(
                        'Penting !',
                        style: textStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                      child: Text(
                        'Dengan melakukan import data maka data yang tersedia sekarang akan terhapus. Data akan digantikan oleh data hasil import data.',
                        style: textStyle.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            height: 1.4,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .04),
                    Container(
                        child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(size.width * .40, 44),
                        primary: Color(0xff2C977D),
                        side: BorderSide(
                          color: Color(0xff2C977D),
                        ),
                      ),
                      onPressed: () {
                        List<dynamic> filteredList = snapshot.data
                            .where((element) =>
                                snapshot.data.indexOf(element) != 0)
                            .toList();
                        DbHelper().deleteAll();
                        List<Guest> guests = new List<Guest>();
                        for (int i = 0; i < filteredList.length; i++) {
                          guests.add(Guest(
                            filteredList[i][0].toString(),
                            filteredList[i][1].toString(),
                            filteredList[i][2].toString(),
                            filteredList[i][3].toString(),
                            filteredList[i][4].toString(),
                            filteredList[i][5].toString(),
                            filteredList[i][6].toString(),
                            filteredList[i][7].toString(),
                            filteredList[i][8].toString(),
                            filteredList[i][9].toString(),
                          ));
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Homepage(
                                    notif: true,
                                    message: 'Berhasi Import Data',
                                    guests: guests,
                                    restore: true)));
                      },
                      child: Text(
                        'Import Data',
                        style: textStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Color(0xff2C977D)),
                      ),
                    )),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  Future<List<List<dynamic>>> loadingCsvData(String path) async {
    final csvFile = new File(path).openRead();
    return await csvFile
        .transform(utf8.decoder)
        .transform(
          CsvToListConverter(),
        )
        .toList();
  }
}
