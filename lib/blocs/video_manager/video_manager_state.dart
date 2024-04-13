part of 'video_manager_bloc.dart';

abstract class VideoManagerState {
  List<YTBModel> video;
  VideoManagerState({required this.video});
}

class VideoManagerInitial extends VideoManagerState {
  VideoManagerInitial({required List<YTBModel> video}) : super(video: video);
}

class VideoManagerUpdate extends VideoManagerState {
  VideoManagerUpdate({required List<YTBModel> video}) : super(video: video);
}

class VideoManagerLoading extends VideoManagerState {
  VideoManagerLoading({required List<YTBModel> video}) : super(video: video);
}