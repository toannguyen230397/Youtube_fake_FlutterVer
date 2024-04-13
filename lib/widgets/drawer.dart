import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_fake/blocs/album_video/album_video_bloc.dart';
import 'package:youtube_fake/blocs/login_register/login_register_bloc.dart';
import 'package:youtube_fake/screens/album_screen.dart';
import 'package:youtube_fake/screens/post_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/widgets/login_register_bottom_sheet.dart';

class DrawerBuilder extends StatelessWidget {
  const DrawerBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      width: screenSize.width * 0.65,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: screenSize.width,
            padding: EdgeInsets.all(50),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black12))),
            child: Image.asset(
              'assets/images/logo2.png',
            ),
          ),
          BlocBuilder<LoginRegisterBloc, LoginRegisterState>(
              builder: (context, state) {
            if (state.token == '') {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  BottomSheetShow(context: context);
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black12))),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Đăng Nhập',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PostScreen(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black12))),
              child: Row(
                children: [
                  Icon(Icons.add_circle),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Đăng Video',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AlbumScreen(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black12))),
              child: Row(
                children: [
                  Icon(Icons.album),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Album',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: BlocBuilder<LoginRegisterBloc, LoginRegisterState>(
                builder: (context, state) {
                  if (state.token != '') {
                    return InkWell(
                      onTap: () {
                        context.read<LoginRegisterBloc>().add(Logout());
                        context.read<AlbumVideoBloc>().add(ClearData());
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 1, color: Colors.black12))),
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Logout',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
