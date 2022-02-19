import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quick_memo_list/model/reminder/reminder_model.dart';
//import 'package:flutter_native_timezone/flutter_native_timezone.dart';         //以下3行は定刻通知に必要
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../main.dart';

class ReminderListPage extends StatefulWidget {
  const ReminderListPage({Key? key}) : super(key: key);

  @override
  State<ReminderListPage> createState() => _ReminderListPage();
}

class _ReminderListPage extends State<ReminderListPage> {
  final TextEditingController _listController = TextEditingController();

  String? reminder;
  var _mydatetime = DateTime.now();
  var formatter = DateFormat('yyyy/MM/dd(E) HH:mm');

  @override
  FirebaseAuth auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReminderModel>(
      create: (_) => ReminderModel(),
      child: Consumer<ReminderModel>(builder: (context, model, child) {
        return Scaffold(
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(auth.currentUser?.uid)
                .collection('reminder')
                .orderBy('AtTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data?.docs.length == 0) {
                return const Center(
                  child: Text('リマインダーを追加してみよう！'),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: ValueKey(index),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            label: 'delete',
                            icon: Icons.delete,
                            backgroundColor: Colors.red,
                            onPressed: (ValueKey) {
                              String id =
                                  snapshot.data!.docs[index].id.toString();

                              AwesomeDialog(
                                      context: context,
                                      customHeader: const Icon(
                                        FeatherIcons.trash2,
                                        size: 60,
                                        color: Colors.black,
                                      ),
                                      animType: AnimType.SCALE,
                                      headerAnimationLoop: false,
                                      dialogType: DialogType.SUCCES,
                                      showCloseIcon: false,
                                      title: 'Delete',
                                      desc: '削除しました',
                                      autoHide: Duration(seconds: 2),
                                      onDissmissCallback: (type) {})
                                  .show();

                              //TODO:delete
                              model.DeleteReminder(id);
                            },
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black12),
                          ),
                        ),
                        child: ListTile(
                          title: (() {
                            if (snapshot.data?.docs[index]['Reminder'].length >=
                                15) {
                              return Text(
                                snapshot.data?.docs[index]['Reminder']
                                        .substring(0, 15) +
                                    ('......'),
                                style: const TextStyle(fontSize: 17),
                              );
                            } else {
                              return Text(
                                snapshot.data?.docs[index]['Reminder'],
                                style: const TextStyle(fontSize: 17),
                              );
                            }
                          })(),
                          subtitle: Text(
                            DateFormat('yyyy/MM/dd')
                                .format(snapshot.data?.docs[index]['AtTime']
                                    .toDate())
                                .toString(),
                            style: const TextStyle(
                                color: Colors.black26, fontSize: 12),
                          ),
                          onTap: () {
                            final TextEditingController _listEditController;
                            _listEditController = TextEditingController(
                                text: snapshot.data?.docs[index]['Reminder']);
                            reminder = snapshot.data?.docs[index]['Reminder'];
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.SCALE,
                              showCloseIcon: true,
                              customHeader: const Icon(
                                FeatherIcons.clock,
                                size: 60,
                                color: Colors.black,
                              ),
                              dialogType: DialogType.INFO,
                              keyboardAware: true,
                              body: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    const Text(
                                      'Text above',
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Material(
                                      elevation: 0,
                                      color: Colors.blueGrey.withAlpha(40),
                                      child: TextFormField(
                                        controller: _listEditController,
                                        onChanged: (text) {
                                          if (text != null) {
                                            reminder = text;
                                          }
                                        },
                                        autofocus: true,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: InputBorder.none,
                                        ),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AnimatedButton(
                                        isFixedHeight: false,
                                        text: 'OK',
                                        pressEvent: () {
                                          if (reminder == null ||
                                              reminder == '' ||
                                              reminder ==
                                                  snapshot.data?.docs[index]
                                                      ['Reminder']) {
                                          } else {
                                            model.EditReminder(
                                                snapshot.data!.docs[index].id
                                                    .toString(),
                                                reminder);
                                            _listEditController.clear();
                                            Navigator.pop(context);
                                          }
                                        })
                                  ],
                                ),
                              ),
                            ).show();
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            child: const Icon(FeatherIcons.plus),
            onPressed: () {
              _listController.clear();
              reminder = null;
              AwesomeDialog(
                context: context,
                animType: AnimType.SCALE,
                showCloseIcon: true,
                customHeader: const Icon(
                  FeatherIcons.clock,
                  size: 60,
                  color: Colors.black,
                ),
                dialogType: DialogType.INFO,
                keyboardAware: true,
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Text above',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        elevation: 0,
                        color: Colors.blueGrey.withAlpha(40),
                        child: TextFormField(
                          controller: _listController,
                          onChanged: (text) {
                            if (text != null) {
                              reminder = text;
                            }
                          },
                          autofocus: true,
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        child: Text(formatter.format(_mydatetime)),
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(), onChanged: (date) {
                            _mydatetime = date;
                          }, onConfirm: (date) {
                            setState(() {
                              _mydatetime = date;
                            });
                          },
                              // Datepickerのデフォルトで表示する日時
                              currentTime: DateTime.now(),
                              locale: LocaleType.jp);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AnimatedButton(
                          isFixedHeight: false,
                          text: 'OK',
                          pressEvent: () {
                            if (reminder == null) {
                            } else {
                              model.AddReminder(reminder);
                              Navigator.pop(context);
                            }
                          })
                    ],
                  ),
                ),
              ).show();
            },
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 50,
            color: Colors.white,
            notchMargin: 6.0,
            shape: const AutomaticNotchedShape(
              RoundedRectangleBorder(),
              StadiumBorder(
                side: BorderSide(),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      FeatherIcons.settings,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                  // IconButton(
                  //   icon: const Icon(
                  //     FeatherIcons.settings,
                  //     color: Colors.black,
                  //   ),
                  //   onPressed: () {},
                  // ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _zonedScheduleNotification(int i, String title, String body) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        i,
        title,
        body,
        tz.TZDateTime.from(DateTime.now(), tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> _cancelNotification(int i) async {
    //IDを指定して通知をキャンセル
    await flutterLocalNotificationsPlugin.cancel(i);
  }

  // const IOSNotificationDetails iOSPlatformChannelSpecifics =
  //     IOSNotificationDetails(
  //         // sound: 'example.mp3',
  //         presentAlert: true,
  //         presentBadge: true,
  //         presentSound: true);
  // NotificationDetails platformChannelSpecifics = const NotificationDetails(
  //   iOS: iOSPlatformChannelSpecifics,
  //   android: null,
  // );
  // await flutterLocalNotificationsPlugin.show(
  //     0, 'title', 'body', platformChannelSpecifics);

}
