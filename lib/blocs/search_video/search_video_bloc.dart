import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/model/ytb_video_model.dart';
part 'search_video_state.dart';
part 'search_video_event.dart';

class SearchVideoBloc extends Bloc<SearchVideoEvent, SearchVideoState> {
  SearchVideoBloc() : super(SearchVideoInitial(video: [])) {
    on<SearchVideo>(_SearchVideo);
    on<SearchClear>(_SearchClear);
  }

  void _SearchVideo(SearchVideo event, Emitter<SearchVideoState> emit) async {
    if(event.search == '') {
      emit(SearchVideoUpdate(video: event.videoList));
    } else {
      List<YTBModel> filteredData = event.videoList.where((item) => item.TenVD.toLowerCase().contains(event.search.toLowerCase())).toList();
      if(filteredData.isNotEmpty) {
        emit(SearchVideoUpdate(video: filteredData));
      }
    }
  }

  void _SearchClear(SearchClear event, Emitter<SearchVideoState> emit) async {
    emit(SearchVideoUpdate(video: []));
  }
}