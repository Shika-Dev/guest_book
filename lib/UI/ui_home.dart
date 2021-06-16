import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:guest_book_app/UI/ui_add.dart';
import 'package:guest_book_app/Utils/csv_convert.dart';
import 'package:guest_book_app/model/model.dart';
import 'package:guest_book_app/helper/database.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:async';

class Homepage extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Homepage> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
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

    return Scaffold(
      //key: scaffoldKey,
      appBar: AppBar(
        title: Text('Daftar Tamu'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: (){
            showSearch(context: context, delegate: DataSearch());
          })
        ],
      ),
      body: createListView(),
      floatingActionButton: _getFAB()
    );
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

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22, color: Colors.white),
      backgroundColor: Colors.red,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(Icons.add, color: Colors.white,),
            backgroundColor: Colors.red,
            onTap: () async {
              var guest = await navigateToEntryForm(context, null);
              if (guest != null) addguest(guest);
            },
            label: 'Add Data',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.red),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.ios_share, color: Colors.white),
            backgroundColor: Colors.red,
            onTap: () {
              getCsv(guestList);
            },
            label: 'Export Data',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.red)
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
}

class DataSearch extends SearchDelegate<String>
{
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Guest> guestList;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: (){
      query = "";
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {

    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    updateListView();
    final suggestionList = query.isEmpty
        ?guestList
        :guestList.where((p) => p.name.startsWith(query)).toList();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    /*return ListView.builder(
        itemBuilder: (context, index)=>ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.people),
            ),
          title: Text(this.guestList[index].name, style: textStyle),
      ),
      itemCount: suggestionList.length,
    );*/
    return ListView.builder(
      itemCount: suggestionList==null? count:suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.people),
            ),
            title: Text(suggestionList[index].name, style: textStyle,),
            subtitle: Text(suggestionList[index].telp),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                deleteguest(suggestionList[index]);
              },
            ),
            onTap: () async {
              var guest = await navigateToEntryForm(context, suggestionList[index]);
              if (guest != null) editguest(guest);
            },
          ),
        );
      },
    );
  }
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
          this.guestList = guestList;
          this.count = guestList.length;
      });
    });
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
}