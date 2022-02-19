import 'package:flutter/material.dart';
import 'package:quick_memo_list/ui/memo/memo_list.dart';
import 'package:google_fonts/google_fonts.dart';

import 'reminder/reminder_list.dart';
import 'todo/todo_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        title: Text(
          'Quick Memo',
          style: GoogleFonts.dongle(
              textStyle: const TextStyle(
                  color: Colors.black, letterSpacing: .8, fontSize: 30)),
        ),
        bottom: TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: <Widget>[
            Tab(
                child: Text(
              'Memo',
              style: GoogleFonts.dongle(
                  textStyle: const TextStyle(letterSpacing: .8, fontSize: 30)),
            )),
            Tab(
                child: Text(
              'ToDo',
              style: GoogleFonts.dongle(
                  textStyle: const TextStyle(letterSpacing: .8, fontSize: 30)),
            )),
            Tab(
                child: Text(
              'Reminder',
              style: GoogleFonts.dongle(
                  textStyle: const TextStyle(letterSpacing: .8, fontSize: 25)),
            )),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          MemoList(),
          const TodoListPage(),
          const ReminderListPage(),
        ],
      ),
    );
  }
}
