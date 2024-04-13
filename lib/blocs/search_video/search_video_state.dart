part of 'search_video_bloc.dart';

abstract class SearchVideoState {
  List<YTBModel> video;
  String search;
  SearchVideoState({required this.video, this.search = ''});
}

class SearchVideoInitial extends SearchVideoState {
  SearchVideoInitial({required List<YTBModel> video}) : super(video: video);
}

class SearchVideoUpdate extends SearchVideoState {
  SearchVideoUpdate({required List<YTBModel> video}) : super(video: video);
}