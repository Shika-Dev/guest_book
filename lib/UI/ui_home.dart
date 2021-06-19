import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:another_flushbar/flushbar.dart';

import 'package:guest_book_app/UI/ui_add.dart';
import 'package:guest_book_app/Utils/csv_convert.dart';
import 'package:guest_book_app/model/model.dart';
import 'package:guest_book_app/helper/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';

class Homepage extends StatefulWidget {
  final bool notif;
  final String message;

  Homepage({Key key, this.notif = false, this.message = ''}) : super(key: key);
  @override
  HomeState createState() => HomeState(notif, message);
}

class HomeState extends State<Homepage> {
  bool notif;
  String message;
  HomeState(this.notif, this.message);

  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Guest> guestList;
  final TextEditingController _search = new TextEditingController();
  String _searchText = "";
  bool noResult = false;
  DateTime firstDate;
  DateTime secondDate;
  bool _filterStatus = false;

  @override
  void initState() {
    super.initState();
    updateListView();

    if (notif == true) {
      Future.delayed(
        Duration(microseconds: 100),
        () {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: BorderRadius.circular(8),
            margin: EdgeInsets.all(16),
            backgroundColor: Color(0xff0EB37E),
            message: message,
            duration: Duration(seconds: 3),
          ).show(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var headlineStyle = TextStyle(
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: Colors.white,
    );

    var textStyle = TextStyle(
      fontFamily: 'Nunito',
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: Colors.white,
    );
    if (guestList == null) {
      guestList = List<Guest>();
      //this.noResult = true;
    }

    return Stack(
      children: [
        Container(color: Colors.white),
        Container(
          height: size.height * .15,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff1B9376).withOpacity(1),
                  Color(0xff0E6B55).withOpacity(0)
                ]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 16,
                left: 16,
                child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Form Asnaf',
                      style: headlineStyle,
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Image.asset('assets/Images/Group_2.png',
              height: size.height * .15, fit: BoxFit.fitHeight),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            //key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: ListView(
              children: [
                guestList.length == 0
                    ? Container(height: size.height * 0.8, child: _noResult())
                    : Container(
                        height: size.height * 0.87,
                        child: Column(
                          children: [
                            SizedBox(height: size.height * .07),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: size.width * .6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextFormField(
                                      controller: _search,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xffe5e5e5),
                                          suffixIcon: Icon(Icons.search,
                                              color: Colors.black),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide.none),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 16)),
                                      onChanged: (p) {
                                        Search(p, guestList);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: size.width * .03),
                                  CircleAvatar(
                                    child: _filterStatus
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.highlight_remove_outlined,
                                              color: Colors.black,
                                            ),
                                            color: Color(0xffe5e5e5),
                                            onPressed: () {
                                              setState(() {
                                                this._filterStatus = false;
                                              });
                                              updateListView();
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.filter_list_outlined,
                                              color: Colors.black,
                                            ),
                                            color: Color(0xffe5e5e5),
                                            onPressed: () {
                                              showModalBottomSheet<void>(
                                                backgroundColor:
                                                    Color(0xff2C977D),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(24.0),
                                                          topRight: const Radius
                                                              .circular(24.0)),
                                                ),
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Filter',
                                                                style:
                                                                    headlineStyle,
                                                              ),
                                                              IconButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .highlight_remove_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  })
                                                            ],
                                                          ),
                                                          SizedBox(height: 20),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  minimumSize: Size(
                                                                      size.width *
                                                                          .40,
                                                                      44),
                                                                  primary: Colors
                                                                      .white,
                                                                  onPrimary:
                                                                      Colors
                                                                          .white,
                                                                  side:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0xff2C977D),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Filter(1,
                                                                      guestList);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  '1 Minggu Terakhir',
                                                                  style: textStyle.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Color(
                                                                          0xff2C977D)),
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  minimumSize: Size(
                                                                      size.width *
                                                                          .40,
                                                                      44),
                                                                  primary: Colors
                                                                      .white,
                                                                  side:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0xff2C977D),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Filter(2,
                                                                      guestList);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  '1 Bulan Terakhir',
                                                                  style: textStyle.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Color(
                                                                          0xff2C977D)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  size.height *
                                                                      .03),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    size.width *
                                                                        .4,
                                                                child:
                                                                    DateTimePicker(
                                                                  decoration:
                                                                      InputDecoration(
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    contentPadding:
                                                                        EdgeInsets.symmetric(
                                                                            vertical:
                                                                                0),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8),
                                                                        borderSide:
                                                                            BorderSide.none),
                                                                  ),
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff2C977D)),
                                                                  initialValue:
                                                                      '',
                                                                  firstDate:
                                                                      DateTime(
                                                                          2000),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2100),
                                                                  onSaved:
                                                                      (val) {
                                                                    setState(
                                                                        () {
                                                                      firstDate =
                                                                          val as DateTime;
                                                                    });
                                                                  },
                                                                  selectableDayPredicate:
                                                                      (date) {
                                                                    // Disable weekend days to select from the calendar
                                                                    if (date.isAfter(
                                                                        DateTime
                                                                            .now())) {
                                                                      return false;
                                                                    }
                                                                    return true;
                                                                  },
                                                                ),
                                                              ),
                                                              Text('S/D',
                                                                  style: headlineStyle
                                                                      .copyWith(
                                                                          fontSize:
                                                                              16)),
                                                              Container(
                                                                width:
                                                                    size.width *
                                                                        .4,
                                                                child:
                                                                    DateTimePicker(
                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.symmetric(
                                                                            vertical:
                                                                                0),
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8),
                                                                        borderSide:
                                                                            BorderSide.none),
                                                                  ),
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff2C977D)),
                                                                  initialValue:
                                                                      '',
                                                                  firstDate:
                                                                      DateTime(
                                                                          2000),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2100),
                                                                  onSaved:
                                                                      (val) {
                                                                    setState(
                                                                        () {
                                                                      secondDate =
                                                                          val as DateTime;
                                                                    });
                                                                  },
                                                                  selectableDayPredicate:
                                                                      (date) {
                                                                    // Disable weekend days to select from the calendar
                                                                    if (date.isAfter(
                                                                        DateTime
                                                                            .now())) {
                                                                      return false;
                                                                    }
                                                                    return true;
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Center(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                minimumSize: Size(
                                                                    size.width *
                                                                        .44,
                                                                    44),
                                                                primary: Colors
                                                                    .white,
                                                                side:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0xff2C977D),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Filter(3,
                                                                    guestList);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                'TERPKAN',
                                                                style: textStyle.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Color(
                                                                        0xff2C977D)),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                    backgroundColor: Color(0xffE5E5E5),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * .02),
                            Expanded(
                                child:
                                    noResult ? _noResult() : createListView()),
                          ],
                        ),
                      ),
              ],
            ),
            floatingActionButton: _getFAB()),
      ],
    );
  }

  Future<Guest> navigateToEntryForm(BuildContext context, Guest guest) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(guest);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Color(0xffE5E5E5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), side: BorderSide.none),
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xffC4C4C4),
              child: Icon(Icons.person, color: Color(0xff464B4A)),
            ),
            title: Text(
              this.guestList[index].name,
              style: textStyle,
            ),
            subtitle: Text(this.guestList[index].kali),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Color(0xffD87777),
              ),
              onTap: () {
                deleteguest(guestList[index]);
              },
            ),
            onTap: () async {
              var guest =
                  await navigateToEntryForm(context, this.guestList[index]);
              if (guest != null) editguest(guest);
            },
          ),
        );
      },
    );
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22, color: Colors.white),
      backgroundColor: Color(0xff50AC96),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color(0xff50AC96),
          label: 'Add Data',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.0),
          labelBackgroundColor: Color(0xff50AC96),
          onTap: () async {
            var guest = await navigateToEntryForm(context, null);
            if (guest != null) addguest(guest);
          },
        ),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.ios_share, color: Colors.white),
            backgroundColor: Color(0xff50AC96),
            onTap: () {
              getCsv(guestList);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Homepage(
                          notif: true,
                          message:
                              "Berhasil Disimpan di Android/data/com.example.guest_book_app/")));
            },
            label: 'Export Data',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xff50AC96))
      ],
    );
  }

  //buat guest
  void addguest(Guest object) async {
    int result = await dbHelper.insert(object);
    if (result > 0) {
      updateListView();
    }
  }

  //edit guest
  void editguest(Guest object) async {
    int result = await dbHelper.update(object);
    if (result > 0) {
      updateListView();
    }
  }

  //delete guest
  void deleteguest(Guest object) async {
    int result = await dbHelper.delete(object.id);
    if (result > 0) {
      updateListView();
    }
  }

  //update guest
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Guest>> guestListFuture = dbHelper.getGuestList();
      guestListFuture.then((guestList) {
        setState(() {
          this.guestList = guestList;
          this.count = guestList.length;
        });
      });
    });
  }

  void Search(String query, List<Guest> object) {
    if (query == "") {
      updateListView();
      this.noResult = false;
    } else {
      if (object == null) {
        setState(() {
          this.noResult = true;
        });
      } else {
        List<Guest> result = object
            .where((element) => element.name.contains(query.toLowerCase()))
            .toList();
        if (result.isNotEmpty) {
          setState(() {
            this.guestList = result;
            this.count = result.length;
            this.noResult = false;
          });
        } else {
          setState(() {
            this.noResult = true;
          });
        }
      }
    }
  }

  Widget _noResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * .05),
        Center(
          child: Image.asset('assets/Images/Group_11.png',
              width: MediaQuery.of(context).size.width * .5,
              fit: BoxFit.fitWidth),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .02),
        Center(
            child: Text(
          'Tidak Ada Data',
          style: TextStyle(
              color: Color(0xff828282),
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w400),
        )),
        SizedBox(height: MediaQuery.of(context).size.height * .02),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(
              height: 53, width: MediaQuery.of(context).size.width * .4),
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide.none)),
                backgroundColor: MaterialStateProperty.all(Color(0xff50AC96))),
            child: Text(
              'Tambahkan Data',
              style: TextStyle(color: Colors.white),
              textScaleFactor: 1,
            ),
            onPressed: () async {
              var guest = await navigateToEntryForm(context, null);
              if (guest != null) addguest(guest);
            },
          ),
        ),
      ],
    );
  }

  void Filter(int code, List<Guest> object) {
    var now = new DateTime.now();
    var now_1w = now.subtract(Duration(days: 7));
    var now_1m = new DateTime(now.year, now.month - 1, now.day);
    final formatDate = DateFormat('yMd');
    if (code == 1) {
      List<Guest> filtered = object.where((element) {
        DateTime date = formatDate.parse(element.tanggal);
        return now_1w.isBefore(date);
      }).toList();
      setState(() {
        this.guestList = filtered;
        this.count = filtered.length;
        this._filterStatus = true;
      });
      if (filtered == null) {
        setState(() {
          this.noResult = true;
        });
      }
    } else if (code == 2) {
      List<Guest> filtered = object.where((element) {
        DateTime date = formatDate.parse(element.tanggal);
        return now_1m.isBefore(date);
      }).toList();
      setState(() {
        this.guestList = filtered;
        this.count = filtered.length;
        this._filterStatus = true;
      });
      if (filtered == null) {
        setState(() {
          this.noResult = true;
        });
      }
    } else if (code == 3) {
      List<Guest> filtered = object.where((element) {
        DateTime date = formatDate.parse(element.tanggal);
        return firstDate.isBefore(date) && secondDate.isAfter((date));
      }).toList();
      setState(() {
        this.guestList = filtered;
        this.count = filtered.length;
        this._filterStatus = true;
      });
      if (filtered == null) {
        setState(() {
          this.noResult = true;
        });
      }
    }
  }
}
