import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_fake/blocs/interacts_video/interacts_video_bloc.dart';
import 'package:youtube_fake/blocs/login_register/login_register_bloc.dart';
import 'package:youtube_fake/blocs/video_manager/video_manager_bloc.dart';
import 'package:youtube_fake/model/ytb_video_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/widgets/video_list_play_video.dart';

class PlayVideoScreen extends StatefulWidget {
  final YTBModel video;
  const PlayVideoScreen({super.key, required this.video});

  @override
  State<PlayVideoScreen> createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  late FlickManager flickManager;

  void addView() {
      final currentVideo = widget.video;
      final updateVideo = YTBModel(MaVD: currentVideo.MaVD, TenVD: currentVideo.TenVD, Hinh: currentVideo.Hinh, Theloai: currentVideo.Theloai, Username: currentVideo.Username, URL: currentVideo.URL, PostTime: currentVideo.PostTime, LuotXem: currentVideo.LuotXem + 1);
      context.read<VideoManagerBloc>().add(UpdateVideo(video: updateVideo));
  }

  @override
  void initState() {
    super.initState();
    addView();
    context.read<InteractsVideoBloc>().add(RefreshState());
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
      Uri.parse(widget.video.URL),
    ));
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    String user = context.read<LoginRegisterBloc>().state.token;
    return Scaffold(
        body: Column(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: FlickVideoPlayer(flickManager: flickManager),
        ),
        Expanded(
          child: BlocBuilder<VideoManagerBloc, VideoManagerState>(
              builder: (context, state) {
            if (state is VideoManagerUpdate && state.video.isNotEmpty) {
              final ListVideo = state.video;
              final filterList =
                  ListVideo.where((item) => item.MaVD != video.MaVD).toList();
              return VideoListPlayVideo(ListVideo: filterList, video: video, user: user,);
            } else {
              return Center(
                child: Text('No Data'),
              );
            }
          }),
        )
      ],
    ));
  }
}
