import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/blocs/album_video/album_video_bloc.dart';
import 'package:youtube_fake/blocs/login_register/login_register_bloc.dart';
import 'package:youtube_fake/function_helper.dart/format_date.dart';
import 'package:youtube_fake/screens/play_video_screen.dart';
import 'package:youtube_fake/widgets/empty_data.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Album Screen',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                context.read<AlbumVideoBloc>().add(ClearData());
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OwnListPage()
                  ),
                );
              },
              child: Container(
                width: screenSize.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black12))),
                child: Row(
                  children: [
                    Icon(Icons.arrow_forward_ios),
                    Text(
                      ' Video của bạn',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                context.read<AlbumVideoBloc>().add(ClearData());
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SaveListPage()
                  ),
                );
              },
              child: Container(
                width: screenSize.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black12))),
                child: Row(
                  children: [
                    Icon(Icons.arrow_forward_ios),
                    Text(
                      ' Video đã lưu',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OwnListPage extends StatelessWidget {
  const OwnListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Video của bạn',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(child: BlocBuilder<LoginRegisterBloc, LoginRegisterState>(
        builder: (context, loginState) {
          return BlocBuilder<AlbumVideoBloc, AlbumVideoState>(
              builder: (context, albumState) {
            if (loginState.token != '' && albumState is AlbumVideoInitial) {
              context
                  .read<AlbumVideoBloc>()
                  .add(LoadOwnVideoData(username: loginState.token));
            }
            if (albumState is AlbumVideoLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (albumState.ownListVideo.isNotEmpty) {
              final data = albumState.ownListVideo;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PlayVideoScreen(
                              video: item,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: screenSize.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black12))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: CachedNetworkImage(
                                imageUrl: item.Hinh,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Container(
                                  color: Colors.black12,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.white,
                                  )),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.TenVD,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Đăng bởi: ${item.Username == loginState.token ? 'Bạn' : item.Username}',
                                        style: TextStyle(color: Colors.black26),
                                      ),
                                      Text(
                                          'Đăng lúc: ${formatTimestamp(item.PostTime)}',
                                          style:
                                              TextStyle(color: Colors.black26))
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Container(
                  height: screenSize.height,
                  child: EmptyDataWidget(Label: 'Không có dữ liệu'));
            }
          });
        },
      )),
    );
  }
}

class SaveListPage extends StatelessWidget {
  const SaveListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Video đã lưu',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(child: BlocBuilder<LoginRegisterBloc, LoginRegisterState>(
        builder: (context, loginState) {
          return BlocBuilder<AlbumVideoBloc, AlbumVideoState>(
              builder: (context, albumState) {
            if (loginState.token != '' && albumState is AlbumVideoInitial) {
              context
                  .read<AlbumVideoBloc>()
                  .add(LoadSaveVideoData(username: loginState.token));
            }
            if (albumState is AlbumVideoLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (albumState.saveListVideo.isNotEmpty) {
              final data = albumState.saveListVideo;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PlayVideoScreen(
                              video: item,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: screenSize.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black12))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: CachedNetworkImage(
                                imageUrl: item.Hinh,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Container(
                                  color: Colors.black12,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.white,
                                  )),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.TenVD,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Đăng bởi: ${item.Username == loginState.token ? 'Bạn' : item.Username}',
                                        style: TextStyle(color: Colors.black26),
                                      ),
                                      Text(
                                          'Đăng lúc: ${formatTimestamp(item.PostTime)}',
                                          style:
                                              TextStyle(color: Colors.black26))
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Container(
                  height: screenSize.height,
                  child: EmptyDataWidget(Label: 'Không có dữ liệu'));
            }
          });
        },
      )),
    );
  }
}
