part of 'interacts_video_bloc.dart';

abstract class InteractsVideoState {
  List<InteractModel> interact;
  InteractsVideoState({required this.interact});
}

class InteractsVideoInitial extends InteractsVideoState {
  InteractsVideoInitial({required List<InteractModel> interact}) : super(interact: interact);
}

class InteractsVideoUpdate extends InteractsVideoState {
  InteractsVideoUpdate({required List<InteractModel> interact}) : super(interact: interact);
}