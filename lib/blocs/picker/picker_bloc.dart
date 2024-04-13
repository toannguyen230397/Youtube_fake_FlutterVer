import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
part 'picker_state.dart';
part 'picker_event.dart';

class PickerBloc extends Bloc<PickerEvent, PickerState> {
  PickerBloc() : super(PickerInitial(thumpnailFilePath: '', videoFilePath: '', type: '', title: '')) {
    on<PickThumpnail>(_PickThumpnail);
    on<PickVideo>(_PickVideo);
    on<PickType>(_PickType);
    on<PickTitle>(_PickTitle);
    on<PickDefaultThumpnail>(_PickDefaultThumpnail);
  }

  void _PickThumpnail(PickThumpnail event, Emitter<PickerState> emit) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String thumpnailFilePath = image.path;
      emit(PickerStateUpdate(thumpnailFilePath: thumpnailFilePath, videoFilePath: state.videoFilePath, type: state.type, title: state.title));
    }
  }

  void _PickVideo(PickVideo event, Emitter<PickerState> emit) async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      String videoFilePath = video.path;
      File videoFile = File(video.path);
      int fileSizeInBytes = await videoFile.length();
      double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
      if (fileSizeInMb <= 100) {
        emit(PickerStateUpdate(thumpnailFilePath: state.thumpnailFilePath, videoFilePath: videoFilePath, type: state.type, title: state.title));
      } else {
        print('Video is too large! It must be under 100MB.');
      }
    }
  }

  void _PickType(PickType event, Emitter<PickerState> emit) async {
    String type = event.type;
    emit(PickerStateUpdate(thumpnailFilePath: state.thumpnailFilePath, videoFilePath: state.videoFilePath, type: type, title: state.title));
  }

  void _PickTitle(PickTitle event, Emitter<PickerState> emit) async {
    String title = event.title;
    emit(PickerStateUpdate(thumpnailFilePath: state.thumpnailFilePath, videoFilePath: state.videoFilePath, type: state.type, title: title));
  }

   void _PickDefaultThumpnail(PickDefaultThumpnail event, Emitter<PickerState> emit) async {
    File videofile = event.video;
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videofile.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 500,
      quality: 25,
    );
    emit(PickerStateUpdate(thumpnailFilePath: thumbnailPath.toString(), videoFilePath: state.videoFilePath, type: state.type, title: state.title));
  }
}
