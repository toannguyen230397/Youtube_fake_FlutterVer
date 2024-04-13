import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/api/api_helper.dart';
import 'package:youtube_fake/model/ytb_video_model.dart';
part 'album_video_state.dart';
part 'album_video_event.dart';

class AlbumVideoBloc extends Bloc<AlbumVideoEvent, AlbumVideoState> {
  AlbumVideoBloc() : super(AlbumVideoInitial(ownListVideo: [], saveListVideo: [])) {
    on<LoadOwnVideoData>(_LoadOwnVideoData);
    on<LoadSaveVideoData>(_LoadSaveVideoData);
    on<ClearData>(_ClearData);
  }

  void _LoadOwnVideoData(LoadOwnVideoData event, Emitter<AlbumVideoState> emit) async {
    emit(AlbumVideoLoading());
    final videoList = await ApiHelper().getAlbumDatas(event.username, 'own');
    if (videoList.isNotEmpty) {
      emit(OwnVideoUpdate(ownListVideo: videoList));
      print('Has Data');
    } else {
      print('No Data');
      emit(OwnVideoUpdate(ownListVideo: []));
    }
  }

  void _LoadSaveVideoData(LoadSaveVideoData event, Emitter<AlbumVideoState> emit) async {
    emit(AlbumVideoLoading());
    final videoList = await ApiHelper().getAlbumDatas(event.username, 'save');
    if (videoList.isNotEmpty) {
      emit(SaveVideoUpdate(saveListVideo: videoList));
      print('Has Data');
    } else {
      print('No Data');
      emit(SaveVideoUpdate(saveListVideo: []));
    }
  }

  void _ClearData(ClearData event, Emitter<AlbumVideoState> emit) async {
    emit(AlbumVideoInitial(ownListVideo: [], saveListVideo: []));
  }

}
