part of 'search_video_bloc.dart';

abstract class SearchVideoEvent {}

class SearchVideo extends SearchVideoEvent {
  final String search;
  final List<YTBModel> videoList;

  SearchVideo({required this.search, required this.videoList});
}

class SearchClear extends SearchVideoEvent {}