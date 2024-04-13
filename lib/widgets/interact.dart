import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_fake/blocs/interacts_video/interacts_video_bloc.dart';
import 'package:youtube_fake/function_helper.dart/format_date.dart';
import 'package:youtube_fake/model/interact_video_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/model/ytb_video_model.dart';
import 'package:youtube_fake/widgets/dialog.dart';

class InteractWidget extends StatelessWidget {
  final YTBModel video;
  final String user;
  const InteractWidget({required this.video, required this.user});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return BlocBuilder<InteractsVideoBloc, InteractsVideoState>(
        builder: (context, state) {
      if (state is InteractsVideoInitial) {
        context
            .read<InteractsVideoBloc>()
            .add(LoadInteractData(MaVD: video.MaVD));
      }
      final data = state.interact;
      final likeList = data.isNotEmpty
          ? data.where((item) => item.Type == 'Like').toList()
          : [];
      final disLikeList = data.isNotEmpty
          ? data.where((item) => item.Type == 'DisLike').toList()
          : [];
      final commentList = data.isNotEmpty
          ? data.where((item) => item.Type == 'Comment').toList()
          : [];
      bool isHadSave = data.any((item) => item.Username == user && item.Type == 'Save');
      return Column(
        children: [
          Container(
            height: screenSize.height * 0.07,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                ),
                top: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Row(
                    children: [
                      interactButton(context, likeList,
                          'assets/images/like.png', 'Like', video.MaVD, user),
                      interactButton(
                          context,
                          disLikeList,
                          'assets/images/dislike.png',
                          'DisLike',
                          video.MaVD,
                          user)
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: user == video.Username
                  ? Container()
                  : Container(
                    margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, right: 20, left: 20),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (isHadSave) {
                          print(
                              'Không Thể Lưu Video Vì Video này đã được user lưu trước đó');
                        } else if(user == '') {
                          showMyDialogBuilder(context: context, alertTitle: 'Thông Báo', alertContent: 'Bạn cần đăng nhập để thực hiện chức năng này');
                        } else {
                          final interact = InteractModel(
                              MaTT: 0,
                              MaVD: video.MaVD,
                              Username: user,
                              Type: 'Save',
                              Title: 'Save',
                              PostTime: DateTime.now().millisecondsSinceEpoch);
                          context
                              .read<InteractsVideoBloc>()
                              .add(AddSaveOrComment(interact: interact));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/save.png'),
                          SizedBox(
                            width: 5,
                          ),
                          Text(isHadSave ? 'Video Đã Lưu' : 'Lưu Video'),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: screenSize.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                ),
              ),
            ),
            child: InkWell(
              onTap: () {
                BottomSheetShow(context: context);
              },
              child: Text(
                'Bình Luận: ${commentList.length.toString()}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      );
    });
  }

  Widget interactButton(BuildContext context, List<dynamic> interactList,
      String iconURL, String type, int MaVD, String user) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          if (type == 'Like') {
            if(user == '') {
              showMyDialogBuilder(context: context, alertTitle: 'Thông Báo', alertContent: 'Bạn cần đăng nhập để thực hiện chức năng này');
            } else {
              final interact = InteractModel(
                MaTT: 0,
                MaVD: MaVD,
                Username: user,
                Type: 'Like',
                Title: 'Like',
                PostTime: DateTime.now().millisecondsSinceEpoch);
            context
                .read<InteractsVideoBloc>()
                .add(AddLike(interact: interact));
            }
          } else if (type == 'DisLike') {
            if(user == '') {
              showMyDialogBuilder(context: context, alertTitle: 'Thông Báo', alertContent: 'Bạn cần đăng nhập để thực hiện chức năng này');
            } else {
              final interact = InteractModel(
                MaTT: 0,
                MaVD: MaVD,
                Username: user,
                Type: 'DisLike',
                Title: 'DisLike',
                PostTime: DateTime.now().millisecondsSinceEpoch);
            context
                .read<InteractsVideoBloc>()
                .add(AddDisLike(interact: interact));
            }
          }
        },
        child: Row(
          children: [
            Image.asset(iconURL),
            SizedBox(
              width: 5,
            ),
            Text(interactList.length.toString()),
          ],
        ),
      ),
    );
  }

  void BottomSheetShow({required BuildContext context}) {
    Size screenSize = MediaQuery.of(context).size;
    TextEditingController commentController = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              width: screenSize.width,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      height: screenSize.height * 0.6,
                      child:
                          BlocBuilder<InteractsVideoBloc, InteractsVideoState>(
                        builder: (context, state) {
                          if (state.interact.isNotEmpty) {
                            final List<InteractModel> data = state.interact;
                            final List<InteractModel> commentList =
                                data.isNotEmpty
                                    ? data
                                        .where((item) => item.Type == 'Comment')
                                        .toList()
                                    : [];
                            List<InteractModel> reversedList =
                                commentList.reversed.toList();
                            return ListView.builder(
                              itemCount: reversedList.length,
                              itemBuilder: (context, index) {
                                final item = reversedList[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black12,
                                        width: 1,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Text(
                                                '${item.Username}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text('vào lúc: ${formatTimestamp(item.PostTime)}', style: TextStyle(color: Colors.black26),))
                                        ],
                                      ),
                                      Text(item.Title)
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black26,
                              width: 1,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: TextField(
                                controller: commentController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Nhập bình luận...',
                                    hintStyle:
                                        TextStyle(color: Colors.black26)),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () {
                                    if(user == '') {
                                      showMyDialogBuilder(context: context, alertTitle: 'Thông Báo', alertContent: 'Bạn cần đăng nhập để thực hiện chức năng này');
                                    } else {
                                      final interact = InteractModel(
                                        MaTT: 0,
                                        MaVD: video.MaVD,
                                        Username: user,
                                        Type: 'Comment',
                                        Title: commentController.text,
                                        PostTime: DateTime.now()
                                            .millisecondsSinceEpoch);
                                    context.read<InteractsVideoBloc>().add(
                                        AddSaveOrComment(interact: interact));
                                    }
                                    commentController.text = '';
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  icon: Icon(
                                    Icons.send,
                                  ),
                                ))
                          ],
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // void BottomSheetShow({required BuildContext context}) {
  //   Size screenSize = MediaQuery.of(context).size;
  //   TextEditingController commentController = TextEditingController();
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (context) {
  //         return Container(
  //           width: screenSize.width,
  //           height: screenSize.height * 0.6,
  //           padding: EdgeInsets.all(10),
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 child: BlocBuilder<InteractsVideoBloc, InteractsVideoState>(
  //                   builder: (context, state) {
  //                     if (state.interact.isNotEmpty) {
  //                       final List<InteractModel> data = state.interact;
  //                       final List<InteractModel> commentList = data.isNotEmpty
  //                           ? data
  //                               .where((item) => item.Type == 'Comment')
  //                               .toList()
  //                           : [];
  //                       return ListView.builder(
  //                         itemCount: commentList.length,
  //                         itemBuilder: (context, index) {
  //                           final item = commentList[index];
  //                           return ListTile(
  //                             title: Text(item.Username),
  //                             subtitle: Text(item.Title),
  //                           );
  //                         },
  //                       );
  //                     } else {
  //                       return Container();
  //                     }
  //                   },
  //                 ),
  //               ),
  //               Container(
  //                   padding: EdgeInsets.all(5),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     border: Border(
  //                       bottom: BorderSide(
  //                         color: Colors.black26,
  //                         width: 1,
  //                       ),
  //                     ),
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       Expanded(
  //                         flex: 9,
  //                         child: TextField(
  //                           controller: commentController,
  //                           decoration: InputDecoration(
  //                               border: InputBorder.none,
  //                               hintText: 'Nhập bình luận...',
  //                               hintStyle: TextStyle(color: Colors.black26)),
  //                         ),
  //                       ),
  //                       Expanded(
  //                           flex: 1,
  //                           child: IconButton(
  //                             onPressed: () {
  //                               final interact = InteractModel(
  //                                   MaTT: 0,
  //                                   MaVD: video.MaVD,
  //                                   Username: user,
  //                                   Type: 'Comment',
  //                                   Title: commentController.text,
  //                                   PostTime:
  //                                       DateTime.now().millisecondsSinceEpoch);
  //                               context
  //                                   .read<InteractsVideoBloc>()
  //                                   .add(AddSaveOrComment(interact: interact));
  //                             },
  //                             icon: Icon(
  //                               Icons.send,
  //                             ),
  //                           ))
  //                     ],
  //                   ))
  //             ],
  //           ),
  //         );
  //       });
  // }
}
