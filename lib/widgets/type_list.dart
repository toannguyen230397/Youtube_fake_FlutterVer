import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/blocs/button_press/button_press_bloc.dart';
import 'package:youtube_fake/blocs/video_manager/video_manager_bloc.dart';

class TypeList extends StatefulWidget {
  const TypeList({super.key});

  @override
  State<TypeList> createState() => _TypeListState();
}

class _TypeListState extends State<TypeList> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<String> titleList = [
      'Âm Nhạc',
      'Giải Trí',
      'Thể Thao',
      'Trò Chơi',
    ];
    return Container(
        height: screenSize.height * 0.07,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black12,
              width: 1.0,
            ),
            top: BorderSide(
              color: Colors.black12,
              width: 1.0,
            ),
          ),
        ),
        child: BlocBuilder<ButtonPressBloc, ButtonPressState>(
            builder: (context, buttonSate) {
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: titleList.length,
                  itemBuilder: (context, index) {
                    final title = titleList[index];
                    return Container(
                      margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: OutlinedButton(
                        onPressed: () {
                          final videoManagerState = context.read<VideoManagerBloc>().state;
                          if(videoManagerState.video.isNotEmpty) {
                            context
                              .read<ButtonPressBloc>()
                              .add(onPress(buttonTile: title));

                            context
                              .read<VideoManagerBloc>()
                              .add(LoadDataByType(type: title));
                          }
                        },
                        child: Text(title, style: TextStyle(color: buttonSate.buttonTile == title ? Colors.white : Colors.black),),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: buttonSate.buttonTile == title ? Colors.red : Colors.black12,
                          side: BorderSide.none,
                        ),
                      ),
                    );
                  });
            },
          ));
  }
}
