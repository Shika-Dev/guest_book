import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:guest_book_app/UI/ui_add.dart';
import 'package:guest_book_app/helper/database.dart';
import 'package:guest_book_app/model/model.dart';
import 'package:sqflite/sqflite.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  int count = 0;
  DbHelper dbHelper = DbHelper();
  DateTime firstDate;
  DateTime secondDate;
  List<Guest> guestList;
  @override
  void initState() {
    super.initState();
    updateListView();
  }
  @override
  Widget build(BuildContext context) {
    if (guestList == null) {
      guestList = List<Guest>();
    }
    TextStyle heading = TextStyle(
        fontFamily: 'Nunito',
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white);
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xffD34C59),
        appBar: AppBar(
          backgroundColor: Color(0xffD34C59),
          elevation: 0,
        ),
        body: Column(
          children: [
            Text('Filter', style: heading),
            SizedBox(height: size.height * .03),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: size.width*.5,
                    child: Column(
                      children: [
                        DateTimePicker(
                          initialValue: '',
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          dateLabelText: 'First Date',
                          onSaved: (val) {
                            setState(() {
                              firstDate= val as DateTime;
                            });
                          },
                          selectableDayPredicate: (date) {
                            // Disable weekend days to select from the calendar
                            if (date.isAfter(DateTime.now())) {
                              return false;
                            }
                            return true;
                          },
                        ),
                        DateTimePicker(
                          initialValue: '',
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          dateLabelText: 'Second Date',
                          onSaved: (val) {
                            setState(() {
                              secondDate= val as DateTime;
                            });
                          },
                          selectableDayPredicate: (date) {
                            // Disable weekend days to select from the calendar
                            if (date.isAfter(DateTime.now())) {
                              return false;
                            }
                            return true;
                          },
                        ),
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
                              'Filter', style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {

                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
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
                child: createListView()
              ),
            ),
          ],
        ));
  }
  Future<Guest> navigateToEntryForm(BuildContext context, Guest guest) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) {
              return EntryForm(guest);
            }
        )
    );
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.people),
            ),
            title: Text(this.guestList[index].name, style: textStyle,),
            subtitle: Text(this.guestList[index].telp),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                deleteguest(guestList[index]);
              },
            ),
            onTap: () async {
              var guest = await navigateToEntryForm(context, this.guestList[index]);
              if (guest != null) editguest(guest);
            },
          ),
        );
      },
    );
  }

  void filter(DateTime val1, DateTime val2, List<Guest> objectList){
    val2 = val2==""?DateTime.now():null;
    List<Guest> filtered;
    for(int i=0;i<objectList.length;i++){
      DateTime date =DateTime.parse(objectList[i].tanggal);
      if(date.isAfter(val1)&&date.isBefore(val2))
      filtered[i] = objectList[i];
    }
    setState(() {
      this.guestList = filtered;
    });
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
}
