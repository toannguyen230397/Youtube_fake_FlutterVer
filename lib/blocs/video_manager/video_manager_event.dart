part of 'video_manager_bloc.dart';

abstract class VideoManagerEvent {}

class PostVideo extends VideoManagerEvent {
  final File videoFile;
  final File thumbnailFile;
  final String type;
  final String title;
  final String user;

  PostVideo({required this.videoFile, required this.thumbnailFile, required this.type, required this.title, required this.user});
}

class UpdateVideo extends VideoManagerEvent {
  final YTBModel video;

  UpdateVideo({required this.video});
}

class LoadData extends VideoManagerEvent {}

class LoadDataByType extends VideoManagerEvent {
  final String type;

  LoadDataByType({required this.type});
}