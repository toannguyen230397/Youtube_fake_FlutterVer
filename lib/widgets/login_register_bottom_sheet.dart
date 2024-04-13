import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/blocs/login_register/login_register_bloc.dart';
import 'package:youtube_fake/widgets/dialog.dart';

Widget buildTextField(
    {required BuildContext context,
    required TextEditingController controller,
    required String hint,
    String? type,
    int? length}) {
  return BlocListener<LoginRegisterBloc, LoginRegisterState>(
    listener: (context, state) {
      if (state is LoginRegisterAlertMessege) {
        String alertMessege = state.alertMessege;
        showMyDialogBuilder(
          context: context,
          alertTitle: 'Thông Báo',
          alertContent: alertMessege,
        );
      }
      if (state.token != '') {
        Navigator.pop(context);
        showMyDialogBuilder(
          context: context,
          alertTitle: 'Thông Báo',
          alertContent: 'Chào mừng ${state.token}',
        );
      }
    },
    child: Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLength: length,
        obscureText: type == 'password' ? true : false,
        style: TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            hintText: hint,
            hintStyle:
                TextStyle(color: Colors.black26, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}

void BottomSheetShow({required BuildContext context}) {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Size screenSize = MediaQuery.of(context).size;

  final pageController = PageController();

  void goNextPage() {
    FocusManager.instance.primaryFocus?.unfocus();
    pageController.animateToPage(1,
        duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  void goPreviousPage() {
    pageController.animateToPage(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: screenSize.height * 0.5,
              child: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 30, bottom: 30, right: 50, left: 50),
                    color: Colors.black,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildTextField(
                            context: context,
                            controller: usernameController,
                            hint: 'Tên Đăng Nhập',
                            length: 15),
                        buildTextField(
                            context: context,
                            controller: passwordController,
                            hint: 'Mật Khẩu',
                            length: 15,
                            type: 'password'),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'chưa có tài khoản?  ',
                              style: TextStyle(color: Colors.white),
                            ),
                            InkWell(
                                onTap: () {
                                  goNextPage();
                                },
                                child: Text(
                                  'Đăng Ký',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            if (usernameController.text.trim() == '' ||
                                passwordController.text.trim() == '') {
                              showMyDialogBuilder(
                                  context: context,
                                  alertTitle: 'Thông Báo',
                                  alertContent: 'Vui lòng nhập đủ thông tin');
                            } else {
                              context.read<LoginRegisterBloc>().add(Login(
                                  username: usernameController.text,
                                  password: passwordController.text));
                            }
                          },
                          child: Container(
                            width: screenSize.width,
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[Colors.red, Colors.black]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: BlocBuilder<LoginRegisterBloc,
                                LoginRegisterState>(
                              builder: (context, state) {
                                if (state is LoadingState) {
                                  return Container(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ));
                                } else {
                                  return Text('Đăng Nhập',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.white));
                                }
                              },
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                  //////////////////////////////////////////////////////////////////////////////
                  Container(
                    padding: EdgeInsets.only(
                        top: 30, bottom: 30, right: 50, left: 50),
                    color: Colors.black,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildTextField(
                            context: context,
                            controller: usernameController,
                            hint: 'Tên Đăng Nhập',
                            length: 15),
                        buildTextField(
                            context: context,
                            controller: passwordController,
                            hint: 'Mật Khẩu',
                            length: 15,
                            type: 'password'),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'bạn muốn quay lại?  ',
                              style: TextStyle(color: Colors.white),
                            ),
                            InkWell(
                                onTap: () {
                                  goPreviousPage();
                                },
                                child: Text(
                                  'Quay Lại',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            if (usernameController.text.trim() == '' ||
                                passwordController.text.trim() == '') {
                              showMyDialogBuilder(
                                  context: context,
                                  alertTitle: 'Thông Báo',
                                  alertContent: 'Vui lòng nhập đủ thông tin');
                            } else {
                              context.read<LoginRegisterBloc>().add(Register(
                                  username: usernameController.text,
                                  password: passwordController.text));
                            }
                          },
                          child: Container(
                            width: screenSize.width,
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[Colors.red, Colors.black]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: BlocBuilder<LoginRegisterBloc,
                                LoginRegisterState>(
                              builder: (context, state) {
                                if (state is LoadingState) {
                                  return Container(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: Colors.white,));
                                } else {
                                  return Text('Đăng Ký',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.white));
                                }
                              },
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
      });
}
