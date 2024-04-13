part of 'interacts_video_bloc.dart';

abstract class InteractsVideoEvent {}

class LoadInteractData extends InteractsVideoEvent {
  int MaVD;
  LoadInteractData({required this.MaVD});
}

class AddLike extends InteractsVideoEvent {
  final InteractModel interact;

  AddLike({required this.interact});
}

class AddDisLike extends InteractsVideoEvent {
  final InteractModel interact;

  AddDisLike({required this.interact});
}

class AddSaveOrComment extends InteractsVideoEvent {
  final InteractModel interact;

  AddSaveOrComment({required this.interact});
}

class RefreshState extends InteractsVideoEvent {}