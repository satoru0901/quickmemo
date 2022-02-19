import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:quick_memo_list/model/registor_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
//import 'package:cool_alert/cool_alert.dart';
import 'package:quick_memo_list/ui/home_page.dart';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? email;
  late TextEditingController _emailController;
  late TextEditingController _confirmController;
  @override
  void initState() {
    _emailController = TextEditingController();
    _confirmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegistorModel>(
      create: (_) => RegistorModel(),
      child: Consumer<RegistorModel>(builder: (context, model, child) {
        return Scaffold(
            body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //TODO:テキスト

              const Text(
                'メールアドレスを入力してはじめる',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 30),

              //TODO:入力フォーム

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter E-mail',
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  onChanged: (text) {
                    email = text;
                  },
                ),
              ),

              //TODO:ボタン

              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 40.0,
                  horizontal: 30.0,
                ),
                //padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15)),
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      overlayColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColorDark),
                      foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    child: const Text("Sign up"),
                    onPressed: () async {
                      if (_emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('メールアドレスを入力してください'),
                            action: SnackBarAction(
                              label: '',
                              onPressed: () {},
                            ),
                          ),
                        );
                        return;
                      }
                      try {
                        await model.Registor(email!);
                        //TODO:AwesomeDialog
                        AwesomeDialog(
                            context: context,
                            customHeader: const Icon(
                              FeatherIcons.check,
                              size: 60,
                              color: Colors.black,
                            ),
                            animType: AnimType.LEFTSLIDE,
                            headerAnimationLoop: false,
                            dialogType: DialogType.SUCCES,
                            showCloseIcon: false,
                            title: 'Succes',
                            desc: '登録完了です',
                            autoHide: Duration(seconds: 2),
                            dismissOnTouchOutside: false,
                            onDissmissCallback: (type) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()),
                              );
                            }).show();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            action: SnackBarAction(
                              label: '',
                              onPressed: () {},
                            ),
                          ),
                        );
                        return;
                      }
                    },
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('ログインページはこちら'),
              ),
            ],
          ),
        ));
      }),
    );
  }
}
