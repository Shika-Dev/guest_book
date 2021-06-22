import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'import_csv.dart';

class AllCsvFilesScreen extends StatefulWidget {
  @override
  _AllCsvFilesScreenState createState() => _AllCsvFilesScreenState();
}

class _AllCsvFilesScreenState extends State<AllCsvFilesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Select CSV"), backgroundColor: Color(0xff2C977D)),
      body: FutureBuilder(
        future: _getAllCsvFiles(),
        builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset('assets/Images/Group_16.png',
                      width: MediaQuery.of(context).size.width * .6,
                      fit: BoxFit.fitWidth),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                Center(
                    child: Text(
                  'Backup data kosong',
                  style: TextStyle(
                      color: Color(0xff828282),
                      fontFamily: 'Nunito',
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                )),
                SizedBox(height: MediaQuery.of(context).size.height * .02),
              ],
            );
          }
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('No Csv File found.'),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            LoadCsvDataScreen(path: snapshot.data[index].path),
                      ),
                    );
                  },
                  title: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      snapshot.data[index].path.substring(44),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      File _file = File(snapshot.data[index].path.toString());
                      try {
                        final file = await _file;
                        await file.delete();
                        setState(() {
                          _getAllCsvFiles();
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
              ),
            ),
            itemCount: snapshot.data.length,
          );
        },
      ),
    );
  }

  Future<List<FileSystemEntity>> _getAllCsvFiles() async {
    final String directory =
        (await getExternalStorageDirectory()).absolute.path;
    final path = "$directory";
    final myDir = Directory(path);
    List<FileSystemEntity> _csvFiles;
    _csvFiles = myDir.listSync(recursive: true, followLinks: false);
    _csvFiles.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    return _csvFiles;
  }
}
