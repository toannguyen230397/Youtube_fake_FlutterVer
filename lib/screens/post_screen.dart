import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/blocs/album_video/album_video_bloc.dart';
import 'package:youtube_fake/blocs/login_register/login_register_bloc.dart';
import 'package:youtube_fake/blocs/picker/picker_bloc.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:youtube_fake/blocs/video_manager/video_manager_bloc.dart';
import 'package:youtube_fake/model/ytb_video_model.dart';
import 'package:youtube_fake/screens/home_screen.dart';
import 'package:youtube_fake/widgets/dialog.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageOne();
  }
}

class PageOne extends StatefulWidget {
  const PageOne({super.key});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    String user = context.read<LoginRegisterBloc>().state.token;
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
          'Post Screen',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: BlocListener<PickerBloc, PickerState>(
        listener: (context, state) async {
          final route = ModalRoute.of(context);
          final isCurrentRoute = route?.isCurrent ?? false;
          if (isCurrentRoute) {
            if (state.videoFilePath != '') {
              File video = File(state.videoFilePath);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PageTwo(
                    videoFile: video,
                  ),
                ),
              );
            }
          }
        },
        child: Container(
          width: screenSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset('assets/images/upload.png')),
              SizedBox(
                height: 20,
              ),
              Text(
                'Chọn video trong thiết bị để\ntải lên',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Lưu ý kích thước file không được vượt mức 100mb',
                style: TextStyle(color: Colors.black26),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  if (user != '') {
                    context.read<PickerBloc>().add(PickVideo());
                  } else {
                    showMyDialogBuilder(
                        context: context,
                        alertTitle: 'Thông Báo',
                        alertContent:
                            'Bạn cần đăng nhập để thực hiện chức năng này');
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[Colors.red, Colors.black]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Chọn Video',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

class PageTwo extends StatefulWidget {
  final File videoFile;
  const PageTwo({required this.videoFile});

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    context
        .read<PickerBloc>()
        .add(PickDefaultThumpnail(video: widget.videoFile));
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.file(widget.videoFile));
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onPressed: () {
              flickManager.flickControlManager?.pause();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PageThree(),
                ),
              );
            },
          )
        ],
        title: Text(
          'Xem Thử',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: FlickVideoPlayer(flickManager: flickManager),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<String> titleList = [
      'Âm Nhạc',
      'Giải Trí',
      'Thể Thao',
      'Trò Chơi',
    ];

    void _uploadFileToFirebase(
        {required File thumbnail, required File video}) async {
      final storageRef = FirebaseStorage.instance.ref();
      try {
        String thumbnailFileName =
            'Image-${DateTime.now().millisecondsSinceEpoch}';
        String videolFileName =
            'Video-${DateTime.now().millisecondsSinceEpoch}';
        String imageURL = '';
        String videoURL = '';

        final thumbnailReference =
            storageRef.child('Thumbnails/$thumbnailFileName');
        final videoReference = storageRef.child('Videos/$videolFileName');

        final UploadTask uploadThumbnail = thumbnailReference.putFile(
            thumbnail,
            SettableMetadata(
              contentType: "image/jpeg",
            ));
        await uploadThumbnail.whenComplete(() async {
          print('Tải tệp $thumbnailFileName lên Firebase Storage thành công.');
          final String downloadImageURL =
              await thumbnailReference.getDownloadURL();
          imageURL = downloadImageURL;
        });

        final UploadTask uploadVideo = videoReference.putFile(
            video,
            SettableMetadata(
              contentType: "video/mp4",
            ));
        await uploadVideo.whenComplete(() async {
          print('Tải tệp $videolFileName lên Firebase Storage thành công.');
          final String downloadVideoURL = await videoReference.getDownloadURL();
          videoURL = downloadVideoURL;
        });
      } catch (e) {
        print('Error: $e');
      }
    }

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
          'Nhập thông tin',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: BlocListener<VideoManagerBloc, VideoManagerState>(
          listener: (context, videoState) async {
            if (videoState is VideoManagerUpdate) {
              await showMyDialogBuilder(context: context, alertTitle: 'Thông Báo', alertContent: 'Tải video lên thành công');
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            }
          },
          child: BlocBuilder<PickerBloc, PickerState>(
            builder: (context, state) {
              if (state.thumpnailFilePath != '' && state.videoFilePath != '') {
                File thumbnail = File(state.thumpnailFilePath);
                File video = File(state.videoFilePath);
                String selectedItem =
                    state.type != '' ? state.type : titleList[0];
                String user = context.read<LoginRegisterBloc>().state.token;
                return Column(
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                            aspectRatio: 16 / 9, child: Image.file(thumbnail)),
                        Positioned(
                          top: 50,
                          bottom: 50,
                          right: 50,
                          left: 50,
                          child: InkWell(
                            onTap: () {
                              context.read<PickerBloc>().add(PickThumpnail());
                            },
                            child: Icon(
                              Icons.add_circle,
                              size: 50,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/avatar.jpg'),
                                backgroundColor: Colors.black12,
                              ),
                            ),
                            Text(
                              user,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ]),
                    ),
                    Container(
                      width: screenSize.width,
                      height: screenSize.height * 0.2,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 1, color: Colors.black12),
                              bottom:
                                  BorderSide(width: 1, color: Colors.black12))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tiêu đề:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextField(
                            maxLength: 50,
                            maxLines: 3,
                            decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              hintText: 'Tạo tiêu đề video của bạn...',
                              hintStyle: TextStyle(
                                  color: Colors.black26,
                                  fontWeight: FontWeight.bold),
                            ),
                            onChanged: (value) {
                              context
                                  .read<PickerBloc>()
                                  .add(PickTitle(title: value));
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenSize.width,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.black12))),
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chọn thể loại:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: screenSize.width,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedItem,
                                icon: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black26,
                                  ),
                                ),
                                items: titleList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.black26),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (item) {
                                  context
                                      .read<PickerBloc>()
                                      .add(PickType(type: item.toString()));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (state.title == '' && state.type == '') {
                          showMyDialogBuilder(
                              context: context,
                              alertTitle: 'Thông Báo',
                              alertContent: 'Vui lòng nhập đủ thông tin');
                        } else {
                          String title = state.title;
                          context.read<VideoManagerBloc>().add(PostVideo(
                              videoFile: video,
                              thumbnailFile: thumbnail,
                              type: selectedItem,
                              title: title,
                              user: user));
                        }
                      },
                      child: Container(
                        width: screenSize.width,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[Colors.red, Colors.black]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child:
                            BlocBuilder<VideoManagerBloc, VideoManagerState>(
                          builder: (context, videoState) {
                            if (videoState is VideoManagerLoading) {
                              return Container(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ));
                            } else {
                              return Text(
                                'Đăng Video',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              );
                            }
                          },
                        )),
                      ),
                    )
                  ],
                );
              } else {
                return Center(child: Text('empty data'));
              }
            },
          ),
        ),
      )),
    );
  }
}
