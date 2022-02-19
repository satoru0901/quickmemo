import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quick_memo_list/model/memo/memo_delete_model.dart';
import 'package:quick_memo_list/ui/memo/memo_add.dart';

import 'memo_edit.dart';

class MemoList extends StatelessWidget {
  MemoList({Key? key}) : super(key: key);

  @override
  FirebaseAuth auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MemoListMdel>(
      create: (_) => MemoListMdel(),
      child: Consumer<MemoListMdel>(builder: (context, model, child) {
        return Scaffold(
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(auth.currentUser?.uid)
                .collection('memo')
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
                  child: Text('メモを追加してみよう！'),
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
                              model.DeleteMemo(id);
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
                            if (snapshot.data?.docs[index]['Title'] == null) {
                              return const Text(' ');
                            }
                            if (snapshot.data?.docs[index]['Title'].length >=
                                20) {
                              return Text(
                                snapshot.data?.docs[index]['Title']
                                        .substring(0, 20) +
                                    ('....'),
                              );
                            } else {
                              return Text(
                                snapshot.data?.docs[index]['Title'],
                              );
                            }
                          })(),
                          subtitle: (() {
                            if (snapshot.data?.docs[index]['Contents'] ==
                                null) {
                              return Text(
                                DateFormat('yyyy/MM/dd')
                                    .format(snapshot.data?.docs[index]['AtTime']
                                        .toDate())
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.black26, fontSize: 12),
                              );
                            }
                            if (snapshot.data?.docs[index]['Contents'].length >=
                                20) {
                              return Text(
                                DateFormat('yyyy/MM/dd')
                                        .format(snapshot
                                            .data?.docs[index]['AtTime']
                                            .toDate())
                                        .toString() +
                                    ('      ') +
                                    snapshot.data?.docs[index]['Contents']
                                        .replaceAll('\n', ' ')
                                        .substring(0, 20) +
                                    ('......'),
                                style: const TextStyle(
                                    color: Colors.black26, fontSize: 12),
                              );
                            } else {
                              return Text(
                                DateFormat('yyyy/MM/dd')
                                        .format(snapshot
                                            .data?.docs[index]['AtTime']
                                            .toDate())
                                        .toString() +
                                    ('      ') +
                                    snapshot.data?.docs[index]['Contents']
                                        .replaceAll('\n', ' '),
                                style: const TextStyle(
                                    color: Colors.black26, fontSize: 12),
                              );
                            }
                          })(),

                          //selected: true,
                          onTap: () {
                            //TODO:編集画面
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MemoEditPage(
                                  id: snapshot.data!.docs[index].id.toString(),
                                  title_www: snapshot.data?.docs[index]
                                      ['Title'],
                                  contents_www: snapshot.data?.docs[index]
                                      ['Contents'],
                                ),
                                fullscreenDialog: true,
                              ),
                            );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemoAddPage(),
                  fullscreenDialog: true,
                ),
              );
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
}
