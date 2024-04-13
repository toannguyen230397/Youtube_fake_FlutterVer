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
                  scrollDirection: Axis.horizontal,
                  itemCount: titleList.length,
                  itemBuilder: (context, index) {
                    final title = titleList[index];
                    return Container(
                      margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, right: 20, left: 20),
                      decoration: BoxDecoration(
                        color: buttonSate.buttonTile == title
                            ? Colors.red
                            : Colors.black12,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
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
                        child: Text(title,
                            style: buttonSate.buttonTile == title
                                ? TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)
                                : null),
                      ),
                    );
                  });
            },
          ));
  }
}
