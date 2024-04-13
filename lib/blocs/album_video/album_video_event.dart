part of 'album_video_bloc.dart';

abstract class AlbumVideoEvent {}

class AddVideo extends AlbumVideoEvent {
  final YTBModel video;

  AddVideo({required this.video});
}

class LoadOwnVideoData extends AlbumVideoEvent {
  final String username;

  LoadOwnVideoData({required this.username});
}

class LoadSaveVideoData extends AlbumVideoEvent {
  final String username;

  LoadSaveVideoData({required this.username});
}


class ClearData extends AlbumVideoEvent {}