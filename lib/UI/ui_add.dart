import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guest_book_app/model/model.dart';
import 'package:intl/intl.dart';

class EntryForm extends StatefulWidget {
  final Guest guest;

  EntryForm(this.guest);

  @override
  EntryFormState createState() => EntryFormState(this.guest);
}

class EntryFormState extends State<EntryForm> {
  Guest guest;

  EntryFormState(this.guest);

  TextEditingController nameController = TextEditingController();
  TextEditingController binController = TextEditingController();
  TextEditingController alm1Controller = TextEditingController();
  TextEditingController alm2Controller = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController kaliController = TextEditingController();
  TextEditingController besarController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yMd').format(now);
    if (guest != null) {
      nameController.text = guest.name;
      binController.text = guest.bin;
      alm1Controller.text = guest.alm1;
      alm2Controller.text = guest.alm2;
      alamatController.text = guest.alamat;
      kaliController.text = guest.kali;
      besarController.text = guest.besar;
      phoneController.text = guest.telp;
    }

    TextStyle heading = TextStyle(
        fontFamily: 'Nunito',
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white);

    TextStyle subHeading = TextStyle(
        fontFamily: 'Nunito',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white);
    var size = MediaQuery.of(context).size;

    //rubah
    return Scaffold(
        backgroundColor: Color(0xffD34C59),
        appBar: AppBar(
          backgroundColor: Color(0xffD34C59),
          elevation: 0,
        ),
        body: Column(
          children: [
            guest == null
                ? Text(
                    'Tambah Data',
                    style: heading,
                  )
                : Text('Ubah Data', style: heading),
            SizedBox(height: size.height * .03),
            guest == null
                ? Text(
                    'Isi formulir berikut untuk menambah data kedalam database tekan simpan untuk menyimmpan',
                    style: subHeading,
                    textAlign: TextAlign.center,
                  )
                : Text(
                    'Isi formulir berikut untuk mengubah data di dalam database tekan simpan untuk menyimmpan',
                    style: subHeading,
                    textAlign: TextAlign.center),
            SizedBox(height: size.height * .1),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: ListView(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  children: <Widget>[
                    Center(child: Text(guest==null?'Tambahkan Data':'Ubah Data', style: subHeading.copyWith(fontSize: 20, color: Color(0xff40284A)))),
                    // nama
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap',
                          labelStyle: TextStyle(color: Color(0xff40284A)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff40284A)),
                            borderRadius: BorderRadius.circular(27),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        onChanged: (value) {
                          //
                        },
                      ),
                    ),

                    //bin/bnt
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: TextField(
                        controller: binController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Bin/Bnt',
                          labelStyle: TextStyle(color: Color(0xff40284A)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff40284A)),
                            borderRadius: BorderRadius.circular(27),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        onChanged: (value) {
                          //
                        },
                      ),
                    ),

                    //alm1
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: TextField(
                        controller: alm1Controller,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Almarhum',
                          labelStyle: TextStyle(color: Color(0xff40284A)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff40284A)),
                            borderRadius: BorderRadius.circular(27),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        onChanged: (value) {
                          //
                        },
                      ),
                    ),

                    //alm2
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: TextField(
                        controller: alm2Controller,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Almarhum',
                          labelStyle: TextStyle(color: Color(0xff40284A)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff40284A)),
                            borderRadius: BorderRadius.circular(27),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        onChanged: (value) {
                          //
                        },
                      ),
                    ),

                    //alamat
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: TextField(
                        controller: alamatController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Alamat',
                          labelStyle: TextStyle(color: Color(0xff40284A)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff40284A)),
                            borderRadius: BorderRadius.circular(27),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        onChanged: (value) {
                          //
                        },
                      ),
                    ),

                    // telepon
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Telepon',
                          labelStyle: TextStyle(color: Color(0xff40284A)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff40284A)),
                            borderRadius: BorderRadius.circular(27),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        onChanged: (value) {
                          //
                        },
                      ),
                    ),

                    //kali
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: TextField(
                        controller: kaliController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Kali',
                          labelStyle: TextStyle(color: Color(0xff40284A)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff40284A)),
                            borderRadius: BorderRadius.circular(27),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        onChanged: (value) {
                          //
                        },
                      ),
                    ),

                    //besar
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: TextField(
                        controller: besarController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Besar',
                          labelStyle: TextStyle(color: Color(0xff40284A)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff40284A)),
                            borderRadius: BorderRadius.circular(27),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        onChanged: (value) {
                          //
                        },
                      ),
                    ),
                    SizedBox(height: size.height*.05),
                    // tombol button
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(height: 53, width: size.width),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27),
                                    side:
                                        BorderSide(color: Color(0xff707070))
                                )
                            ),
                          backgroundColor: MaterialStateProperty.all(Color(0xff40284A))
                        ),
                        child: Text(
                          'Simpan', style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (guest == null) {
                            guest = Guest(
                                nameController.text,
                                binController.text,
                                alm1Controller.text,
                                alm2Controller.text,
                                alamatController.text,
                                phoneController.text,
                                kaliController.text,
                                besarController.text,
                                formattedDate);
                            print('Success add data');
                          } else {
                            // ubah data
                            guest.name = nameController.text;
                            guest.bin = binController.text;
                            guest.alm1 = alm1Controller.text;
                            guest.alm2 = alm2Controller.text;
                            guest.alamat = alamatController.text;
                            guest.telp = phoneController.text;
                            guest.kali = kaliController.text;
                            guest.besar = besarController.text;
                            guest.tanggal = formattedDate;
                          }
                          // kembali ke layar sebelumnya dengan membawa objek guest
                          Navigator.pop(context, guest);
                        },
                      ),
                    ),
                    SizedBox(height: size.height*.03),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(height: 53, width: size.width),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27),
                                    side:
                                    BorderSide(color: Color(0xff707070))
                                )
                            ),
                            backgroundColor: MaterialStateProperty.all(Colors.white)
                        ),
                        child: Text(
                          'Cancel', style: TextStyle(color: Color(0xff40284A)),
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context, guest);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
