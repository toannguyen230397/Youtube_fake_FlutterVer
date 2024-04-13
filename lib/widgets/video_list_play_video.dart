import 'package:flutter/material.dart';
import 'package:youtube_fake/function_helper.dart/format_date.dart';
import 'package:youtube_fake/model/ytb_video_model.dart';
import 'package:youtube_fake/screens/play_video_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_fake/widgets/interact.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';


class VideoListPlayVideo extends StatelessWidget {
  final List<YTBModel> ListVideo;
  final YTBModel video;
  final String user;
  const VideoListPlayVideo(
      {required this.ListVideo, required this.video, required this.user});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final videoList = ListVideo;
    return CustomScrollView(
      slivers: <Widget>[
        SliverStickyHeader(
          header: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    video.TenVD,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: Text(
                      '${video.LuotXem} ${video.LuotXem > 1 ? 'Views' : 'View'} - Đăng lúc: ${formatTimestamp(video.PostTime)}'),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
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
                        Container(
                          child: Text(
                            video.Username,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        )
                      ]),
                ),
                InteractWidget(
                  video: video,
                  user: user,
                ),
              ],
            ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final item = videoList[index];
              return Container(
                width: screenSize.width,
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
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
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageBuilder: (context, imageProvider) {
                          return Material(
                            color: Colors.blueAccent,
                            child: Ink.image(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              child: InkWell(onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => PlayVideoScreen(
                                      video: item,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/avatar.jpg'),
                              backgroundColor: Colors.black12,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.TenVD,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                    '${item.Username} - ${item.LuotXem} ${item.LuotXem > 1 ? 'Views' : 'View'} - ${formatTimestamp(item.PostTime)}')
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            childCount: videoList.length,
          ),
        ),
      ],
    );
  }
}
