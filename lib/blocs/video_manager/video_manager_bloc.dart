import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/api/api_helper.dart';
import 'package:youtube_fake/model/ytb_video_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
part 'video_manager_state.dart';
part 'video_manager_event.dart';

class VideoManagerBloc extends Bloc<VideoManagerEvent, VideoManagerState> {
  VideoManagerBloc() : super(VideoManagerInitial(video: [])) {
    on<PostVideo>(_PostVideo);
    on<UpdateVideo>(_UpdateVideo);
    on<LoadData>(_LoadData);
    on<LoadDataByType>(_LoadDataByType);
  }

  void _PostVideo(PostVideo event, Emitter<VideoManagerState> emit) async {
    emit(VideoManagerLoading(video: state.video));
    final storageRef = FirebaseStorage.instance.ref();
    try {
      String thumbnailFileName =
          'Image-${DateTime.now().millisecondsSinceEpoch}';
      String videolFileName = 'Video-${DateTime.now().millisecondsSinceEpoch}';
      String imageURL = '';
      String videoURL = '';

      final thumbnailReference =
          storageRef.child('Thumbnails/$thumbnailFileName');
      final videoReference = storageRef.child('Videos/$videolFileName');

      final UploadTask uploadThumbnail = thumbnailReference.putFile(
          event.thumbnailFile,
          SettableMetadata(
            contentType: "image/jpeg",
          ));
      await uploadThumbnail.whenComplete(() async {
        print('Tải tệp $thumbnailFileName lên Firebase Storage thành công.');
        final String downloadImageURL =
            await thumbnailReference.getDownloadURL();
        imageURL = downloadImageURL;
      });

      final UploadTask uploadVideo = videoReference.putFile(
          event.videoFile,
          SettableMetadata(
            contentType: "video/mp4",
          ));
      await uploadVideo.whenComplete(() async {
        print('Tải tệp $videolFileName lên Firebase Storage thành công.');
        final String downloadVideoURL = await videoReference.getDownloadURL();
        videoURL = downloadVideoURL;
      });
      
      final newVideo = YTBModel(MaVD: 0, TenVD: event.title, Hinh: imageURL, Theloai: event.type, Username: event.user, URL: videoURL, PostTime: DateTime.now().millisecondsSinceEpoch, LuotXem: 0);
      final respone = ApiHelper().postVideo(newVideo);
      if(respone == true) {
        state.video.add(newVideo);
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      emit(VideoManagerUpdate(video: state.video));
    }
    
  }

  void _UpdateVideo(UpdateVideo event, Emitter<VideoManagerState> emit) async {
    for (int i = 0; i < state.video.length; i++) {
      if (event.video.MaVD == state.video[i].MaVD) {
        state.video[i] = event.video;
        final response = await ApiHelper().addView(event.video.MaVD);
        if(response) {
          emit(VideoManagerUpdate(video: state.video));
        }        
        break;
      }
    }
  }

  void _LoadData(LoadData event, Emitter<VideoManagerState> emit) async {
    emit(VideoManagerLoading(video: state.video));
    final videoList = await ApiHelper().getDatas();
    if (videoList.isNotEmpty) {
      emit(VideoManagerUpdate(video: videoList));
    } else {
      emit(VideoManagerUpdate(video: []));
    }
  }

  void _LoadDataByType(
      LoadDataByType event, Emitter<VideoManagerState> emit) async {
    emit(VideoManagerLoading(video: state.video));
    final videoList = await ApiHelper().getDatasByType(event.type);
    if (videoList.isNotEmpty) {
      emit(VideoManagerUpdate(video: videoList));
    } else {
      emit(VideoManagerUpdate(video: []));
    }
  }
}
