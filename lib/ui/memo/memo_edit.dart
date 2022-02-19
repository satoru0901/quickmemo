import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quick_memo_list/model/memo/memo_add_edit_model.dart';

class MemoEditPage extends StatefulWidget {
  const MemoEditPage(
      {Key? key,
      required this.id,
      required this.title_www,
      required this.contents_www})
      : super(key: key);
  final String id;
  final String title_www;
  final String contents_www;

  @override
  State<MemoEditPage> createState() => _MemoEditPage();
}

class _MemoEditPage extends State<MemoEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentsController;

  String? title;
  String? contents;

  void initState() {
    title = widget.title_www.replaceAll('(空白)', '');
    contents = widget.contents_www.replaceAll('(空白)', '');
    _titleController = TextEditingController(text: title);
    _contentsController = TextEditingController(text: contents);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentsController.dispose();
    super.dispose();
  }

  @override
  FirebaseAuth auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MemoAddEditModel>(
        create: (_) => MemoAddEditModel(),
        child: Consumer<MemoAddEditModel>(builder: (context, model, child) {
          return WillPopScope(
            onWillPop: () {
              if (widget.contents_www == contents &&
                  widget.title_www == title) {
                Navigator.of(context).pop();
              } else {
                _choicedialog();
              }

              return Future.value(false);
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  contents!.replaceAll('\n', '').length.toString() +
                      '  ' +
                      'letters',
                  style: const TextStyle(color: Colors.black38, fontSize: 15),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.black38),
                actions: [
                  Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: TextButton(
                        child: const Text(
                          '保存',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (title != '' && contents == '') {
                            contents = '(空白)';
                            await model.EditMemo(widget.id, title!, contents!);
                            await _awesomedialog();
                          } else if (title == '' && contents != '') {
                            title = '(空白)';
                            await model.EditMemo(widget.id, title!, contents!);
                            await _awesomedialog();
                          } else if (title != '' && contents != '') {
                            await model.EditMemo(widget.id, title!, contents!);
                            await _awesomedialog();
                          } else {
                            _errordialog();
                          }
                        },
                      )),
                ],
              ),
              body: Column(children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: TextField(
                    controller: _titleController,
                    onChanged: (text) {
                      if (text != null) {
                        title = text;
                      }
                    },
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'title',
                    ),
                    maxLines: 1,
                    autofocus: false,
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    child: TextField(
                      controller: _contentsController,
                      onChanged: (text) {
                        if (text != null) {
                          setState(() {
                            contents = text;
                          });
                        }
                      },
                      style: const TextStyle(
                          fontSize: 15.0,
                          height: 1.6 //You can set your custom height here
                          ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter the text',
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                ),
              ]),
            ),
          );
        }));
  }

  Future _awesomedialog() {
    return AwesomeDialog(
        context: context,
        customHeader: const Icon(
          FeatherIcons.check,
          size: 60,
          color: Colors.black,
        ),
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        showCloseIcon: false,
        title: 'Save',
        desc: '保存しました',
        autoHide: Duration(seconds: 2),
        onDissmissCallback: (type) {
          Navigator.pop(context);
        }).show();
  }

  Future _errordialog() {
    return AwesomeDialog(
            context: context,
            customHeader: const Icon(
              FeatherIcons.alertCircle,
              size: 60,
              color: Colors.black,
            ),
            headerAnimationLoop: false,
            dialogType: DialogType.WARNING,
            showCloseIcon: false,
            autoHide: Duration(seconds: 2),
            title: 'Caution',
            desc: '空白です',
            onDissmissCallback: (type) {})
        .show();
  }

  Future _choicedialog() {
    return AwesomeDialog(
            context: context,
            customHeader: const Icon(
              FeatherIcons.alertCircle,
              size: 60,
              color: Colors.black,
            ),
            headerAnimationLoop: false,
            dialogType: DialogType.WARNING,
            showCloseIcon: false,
            title: 'Caution',
            desc: '変更が保存されません',
            btnOkText: 'はい',
            btnCancelText: '戻る',
            btnOkColor: Colors.blue,
            btnCancelColor: Colors.black12,
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              Navigator.of(context).pop();
            },
            onDissmissCallback: (type) {})
        .show();
  }
}
