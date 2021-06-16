import 'dart:io';

import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

getCsv(List associateList) async {

  //create an element rows of type list of list. All the above data set are stored in associate list
  //Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

  List<List<dynamic>> rows = List<List<dynamic>>();
  for (int i = 0; i <=associateList.length;i++) {
    List<dynamic> row = List();
    if(i==0){
    row.add('Nama');
    row.add('Bin/Bnt');
    row.add('Almarhum');
    row.add('Almarhum');
    row.add('Alamat');
    row.add('No Telp');
    row.add('Kali');
    row.add('Besar');
    row.add('Tanggal Diperbaharui');
    rows.add(row);
  } else{
    row.add(associateList[i-1].name);
    row.add(associateList[i-1].bin);
    row.add(associateList[i-1].alm1);
    row.add(associateList[i-1].alm2);
    row.add(associateList[i-1].alamat);
    row.add(associateList[i-1].telp);
    row.add(associateList[i-1].kali);
    row.add(associateList[i-1].besar);
    row.add(associateList[i-1].tanggal);
    rows.add(row);
  }
//row refer to each column of a row in csv file and rows refer to each row in a file

  }

  if (await Permission.storage.request().isGranted) {

//store file in documents folder

    String dir = (await getExternalStorageDirectory()).absolute.path + "/documents";
    var file = "$dir";
    File f = new File(file+"filename.csv");

// convert rows to String and write as csv file

    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);

    print('Success Create a file at $file/filename.csv');
  }


}