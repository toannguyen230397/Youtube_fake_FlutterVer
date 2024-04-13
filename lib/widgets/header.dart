import 'package:flutter/material.dart';
import 'package:youtube_fake/blocs/search_video/search_video_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/blocs/video_manager/video_manager_bloc.dart';
import 'package:youtube_fake/widgets/type_list.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Image.asset('assets/images/logo.PNG'))),
              Expanded(
                  flex: 7,
                  child: buildTextField())
            ],
          ),
          TypeList()
        ],
      ),
    );
  }

  static Widget buildTextField() {
    return BlocBuilder<VideoManagerBloc, VideoManagerState>(
      builder: (context, videoState) {
        if (videoState is VideoManagerUpdate && videoState.video.isNotEmpty) {
            final ListVideo = videoState.video;
            return Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: 'Tìm kiếm...',
                    hintStyle: TextStyle(
                        color: Colors.black26, fontWeight: FontWeight.bold)),
                onChanged: (value) {
                  context.read<SearchVideoBloc>().add(SearchVideo(
                      search: value.toString(), videoList: ListVideo));
                },
              ),
            );
          } else {
            return Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tìm kiếm...',
                    hintStyle: TextStyle(
                        color: Colors.black26, fontWeight: FontWeight.bold)),
              ),
            );
          }
      },
    );
  }
}
