part of 'album_video_bloc.dart';

abstract class AlbumVideoState {
  List<YTBModel> ownListVideo;
  List<YTBModel> saveListVideo;
  AlbumVideoState({required this.ownListVideo, required this.saveListVideo});
}

class AlbumVideoInitial extends AlbumVideoState {
  AlbumVideoInitial({required List<YTBModel> ownListVideo, required List<YTBModel> saveListVideo}) : super(ownListVideo: ownListVideo, saveListVideo: saveListVideo);
}

class OwnVideoUpdate extends AlbumVideoState {
  OwnVideoUpdate({required List<YTBModel> ownListVideo}) : super(ownListVideo: ownListVideo, saveListVideo: []);
}

class SaveVideoUpdate extends AlbumVideoState {
  SaveVideoUpdate({required List<YTBModel> saveListVideo}) : super(ownListVideo: [], saveListVideo: saveListVideo);
}

class AlbumVideoLoading extends AlbumVideoState {
  AlbumVideoLoading() : super(ownListVideo: [], saveListVideo: []);
}