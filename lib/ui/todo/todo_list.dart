import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quick_memo_list/model/todo/todo_model.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPage();
}

class _TodoListPage extends State<TodoListPage> {
  final TextEditingController _listController = TextEditingController();

  String? list;
  bool? isChecked = false;

  @override
  FirebaseAuth auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoModel>(
      create: (_) => TodoModel(),
      child: Consumer<TodoModel>(builder: (context, model, child) {
        return Scaffold(
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(auth.currentUser?.uid)
                .collection('list')
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
                  child: Text('ToDoを追加してみよう！'),
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
                              model.DeleteList(id);
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
                            if (snapshot.data?.docs[index]['List'].length >=
                                15) {
                              return Text(
                                snapshot.data?.docs[index]['List']
                                        .substring(0, 15) +
                                    ('......'),
                                style: const TextStyle(fontSize: 17),
                              );
                            } else {
                              return Text(
                                snapshot.data?.docs[index]['List'],
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
                          trailing: Transform.scale(
                            scale: 1.3,
                            child: Checkbox(
                              checkColor: Colors.white,
                              shape: const CircleBorder(),
                              value: snapshot.data?.docs[index]['isChecked'],
                              onChanged: (bool? val) {
                                if (val != null) {
                                  setState(() {
                                    model.CheckList(
                                        snapshot.data!.docs[index].id
                                            .toString(),
                                        val);
                                  });
                                }
                              },
                            ),
                          ),
                          onTap: () {
                            final TextEditingController _listEditController;
                            _listEditController = TextEditingController(
                                text: snapshot.data?.docs[index]['List']);
                            list = snapshot.data?.docs[index]['List'];
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.SCALE,
                              showCloseIcon: true,
                              customHeader: const Icon(
                                FeatherIcons.feather,
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
                                            list = text;
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
                                          if (list == null ||
                                              list == '' ||
                                              list ==
                                                  snapshot.data?.docs[index]
                                                      ['List']) {
                                          } else {
                                            model.EditList(
                                                snapshot.data!.docs[index].id
                                                    .toString(),
                                                list);
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
              list = null;
              AwesomeDialog(
                context: context,
                animType: AnimType.SCALE,
                showCloseIcon: true,
                customHeader: const Icon(
                  FeatherIcons.feather,
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
                              list = text;
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
                            if (list == null) {
                            } else {
                              model.AddList(list);
                              Navigator.pop(context);
                            }
                          })
                    ],
                  ),
                ),
              ).show();
            },
          ),
          bottomNavigationBar: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser?.uid)
                  .collection('list')
                  .where("isChecked", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return BottomAppBar(
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
                        IconButton(
                          icon: const Icon(
                            FeatherIcons.trash2,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            if (snapshot.data?.docs.length == 0) {
                              await AwesomeDialog(
                                      context: context,
                                      customHeader: const Icon(
                                        FeatherIcons.info,
                                        size: 60,
                                        color: Colors.black,
                                      ),
                                      animType: AnimType.SCALE,
                                      headerAnimationLoop: false,
                                      dialogType: DialogType.SUCCES,
                                      showCloseIcon: false,
                                      title: 'Fault',
                                      desc: 'チェックを入れてください',
                                      autoHide: const Duration(seconds: 2),
                                      onDissmissCallback: (type) {})
                                  .show();
                            } else {
                              await model.DeleteCheckedList();
                              await AwesomeDialog(
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
                                      autoHide: const Duration(seconds: 2),
                                      onDissmissCallback: (type) {})
                                  .show();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
        );
      }),
    );
  }
}
