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
          print(snapshot.data.toString());
          List<dynamic> filteredList = snapshot.data
              .where((element) => snapshot.data.indexOf(element) != 0)
              .toList();
          print(filteredList);
          DbHelper().deleteAll();
          return snapshot.hasData
              ? Center(
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width * .40, 44),
                    primary: Color(0xff2C977D),
                    onPrimary: Color(0xff2C977D),
                    side: BorderSide(
                      color: Color(0xff2C977D),
                    ),
                  ),
                  onPressed: () {
                    filteredList.map((e) => Guest(
                        e.data[0].toString(),
                        e.data[1].toString(),
                        e.data[2].toString(),
                        e.data[3].toString(),
                        e.data[4].toString(),
                        e.data[5].toString(),
                        e.data[6].toString(),
                        e.data[7].toString(),
                        e.data[8].toString(),
                        e.data[9].toString())
                    );
                    print('Success add data');
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_)=>Homepage(notif: true, message: 'Berhasi Import Data',)
                        ));
                  },
                  child: Text(
                    'Import Data',
                    style: textStyle.copyWith(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ))
              /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: snapshot.data
                  .map(
                    (data) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          data[0].toString(),
                        ),
                        SizedBox(width: 3),
                        Text(
                          data[1].toString(),
                        ),
                        SizedBox(width: 3),
                        Text(
                          data[2].toString(),
                        ),
                        SizedBox(width: 3),
                        Text(
                          data[3].toString(),
                        ),
                        SizedBox(width: 3),
                        Text(
                          data[4].toString(),
                        ),
                        SizedBox(width: 3),
                        Text(
                          data[5].toString(),
                        ),
                        SizedBox(width: 3),
                        Text(
                          data[6].toString(),
                        ),
                        SizedBox(width: 3),
                        Text(
                          data[7].toString(),
                        ),
                        SizedBox(width: 3),
                        Text(
                          data[8].toString(),
                        ),
                        SizedBox(width: 3),
                        Text(
                          data[9].toString(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          )*/
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
