import 'package:flutter/material.dart';
import 'package:youtube_fake/function_helper.dart/format_date.dart';
import 'package:youtube_fake/model/ytb_video_model.dart';
import 'package:youtube_fake/screens/play_video_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoListHome extends StatelessWidget {
  final List<YTBModel> ListVideo;
  const VideoListHome({required this.ListVideo});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final videoList = ListVideo;
    return ListView.builder(
        itemCount: videoList.length,
        itemBuilder: (context, index) {
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
                            Navigator.of(context).push(
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
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
        });
  }
}
