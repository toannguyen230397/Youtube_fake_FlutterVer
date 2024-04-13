import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/api/api_helper.dart';
import 'package:youtube_fake/model/interact_video_model.dart';
part 'interacts_video_state.dart';
part 'interacts_video_event.dart';

class InteractsVideoBloc
    extends Bloc<InteractsVideoEvent, InteractsVideoState> {
  InteractsVideoBloc() : super(InteractsVideoInitial(interact: [])) {
    on<LoadInteractData>(_LoadInteractData);
    on<AddLike>(_AddLike);
    on<AddDisLike>(_AddDisLike);
    on<AddSaveOrComment>(_AddSaveOrComment);
    on<RefreshState>(_RefreshState);
  }

  void _LoadInteractData(
      LoadInteractData event, Emitter<InteractsVideoState> emit) async {
    int MaVD = event.MaVD;
    final interactsList = await ApiHelper().getInteractData(MaVD);
    if (interactsList.isNotEmpty) {
      emit(InteractsVideoUpdate(interact: interactsList));
    } else {
      emit(InteractsVideoUpdate(interact: []));
    }
  }

  void _AddLike(
      AddLike event, Emitter<InteractsVideoState> emit) async {
    if (event.interact.Type == 'Like') {
      bool greenFlag = true;
      for (int i = 0; i < state.interact.length; i++) {
        if (event.interact.MaVD == state.interact[i].MaVD &&
            event.interact.Username == state.interact[i].Username) {
          if (state.interact[i].Type == 'Like') {
            greenFlag = false;
            final isRemove = await ApiHelper().removeInteract(state.interact[i]);
            if(isRemove) {
              state.interact.removeAt(i);
              break;
            }
          } else if (state.interact[i].Type == 'DisLike') {
            greenFlag = false;
            final isRemove = await ApiHelper().removeInteract(state.interact[i]);
            if(isRemove) {
              state.interact.removeAt(i);
              final isAdd = await ApiHelper().sendInteract(event.interact);
              if(isAdd) {
                state.interact.add(event.interact);
                break;
              } 
            }
          }
        }
      }
      if (greenFlag) {
        final isAdd = await ApiHelper().sendInteract(event.interact);
        if(isAdd) {
          state.interact.add(event.interact);
        }
      }
    }
    emit(InteractsVideoUpdate(interact: state.interact));
  }

  void _AddDisLike(
      AddDisLike event, Emitter<InteractsVideoState> emit) async {
    if (event.interact.Type == 'DisLike') {
      bool greenFlag = true;
      for (int i = 0; i < state.interact.length; i++) {
        if (event.interact.MaVD == state.interact[i].MaVD &&
            event.interact.Username == state.interact[i].Username) {
          if (state.interact[i].Type == 'DisLike') {
            greenFlag = false;
            final isRemove = await ApiHelper().removeInteract(state.interact[i]);
            if(isRemove) {
              state.interact.removeAt(i);
              break;
            }
          } else if (state.interact[i].Type == 'Like') {
            greenFlag = false;
            final isRemove = await ApiHelper().removeInteract(state.interact[i]);
            if(isRemove) {
              state.interact.removeAt(i);
              final isAdd = await ApiHelper().sendInteract(event.interact);
              if(isAdd) {
                state.interact.add(event.interact);
                break;
              } 
            }
          }
        }
      }
      if (greenFlag) {
        final isAdd = await ApiHelper().sendInteract(event.interact);
        if(isAdd) {
          state.interact.add(event.interact);
        }
      }
    }
    emit(InteractsVideoUpdate(interact: state.interact));
  }

  void _AddSaveOrComment(
      AddSaveOrComment event, Emitter<InteractsVideoState> emit) async {
    final isDone = await ApiHelper().sendInteract(event.interact);
    if (isDone) {
      state.interact.add(event.interact);
      emit(InteractsVideoUpdate(interact: state.interact));
    }
  }

  void _RefreshState(
      RefreshState event, Emitter<InteractsVideoState> emit) async {
    emit(InteractsVideoInitial(interact: []));
  }
}
