import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_fake/blocs/button_press/button_press_bloc.dart';
import 'package:youtube_fake/blocs/search_video/search_video_bloc.dart';
import 'package:youtube_fake/blocs/video_manager/video_manager_bloc.dart';
import 'package:youtube_fake/widgets/drawer.dart';
import 'package:youtube_fake/widgets/header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/widgets/video_list_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerBuilder(),
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            Expanded(child: BlocBuilder<VideoManagerBloc, VideoManagerState>(
              builder: (context, videoState) {
                return BlocBuilder<SearchVideoBloc, SearchVideoState>(
                    builder: (context, searchState) {
                  if (videoState is VideoManagerInitial) {
                    context.read<VideoManagerBloc>().add(LoadData());
                  }
                  if (videoState is VideoManagerLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (videoState is VideoManagerUpdate &&
                      videoState.video.isNotEmpty) {
                    if (searchState is SearchVideoUpdate &&
                        searchState.video.isNotEmpty) {
                      final ListSearch = searchState.video;
                      return RefreshIndicator(
                          onRefresh: () async {
                            context.read<SearchVideoBloc>().add(SearchClear());
                            context
                                .read<ButtonPressBloc>()
                                .add(onPress(buttonTile: ''));
                            context.read<VideoManagerBloc>().add(LoadData());
                          },
                          child: VideoListHome(ListVideo: ListSearch));
                    }
                    final ListVideo = videoState.video;
                    return RefreshIndicator(
                        onRefresh: () async {
                          context.read<VideoManagerBloc>().add(LoadData());
                          context
                              .read<ButtonPressBloc>()
                              .add(onPress(buttonTile: ''));
                        },
                        child: VideoListHome(ListVideo: ListVideo));
                  } else {
                    return Center(
                      child: Text('No Data'),
                    );
                  }
                });
              },
            )),
          ],
        ),
      ),
    );
  }
}
