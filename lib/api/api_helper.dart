import 'package:http/http.dart' as http;
import 'package:youtube_fake/model/interact_video_model.dart';
import 'dart:convert';

import 'package:youtube_fake/model/ytb_video_model.dart';

class ApiHelper {
  final String apiURL = 'https://toanyoutubefake.000webhostapp.com/';

  Future<List<YTBModel>> getDatas() async {
    final response = await http.get(Uri.parse('${apiURL}category.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<YTBModel> videoList =
          data.map((item) => YTBModel.fromJson(item)).toList();
      return videoList;
    } else {
      throw Exception('Failed to load datas');
    }
  }

  Future<List<String>> getTypes() async {
    final response = await http.get(Uri.parse('${apiURL}videoType.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      List<String> typeList =
          data.map((item) => item['Theloai'] as String).toList();
      print(typeList);
      return typeList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<YTBModel>> getDatasByType(String Type) async {
    final response = await http.get(Uri.parse('${apiURL}category.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<YTBModel> videoList =
          data.map((item) => YTBModel.fromJson(item)).toList();
      final filterList =
          videoList.where((item) => item.Theloai == Type).toList();
      return filterList;
    } else {
      throw Exception('Failed to load datas');
    }
  }

  Future<List<YTBModel>> getAlbumDatas(String user, String screen) async {
    final response = await http.post(
      Uri.parse('${apiURL}albumVideo.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user': user,
        'screen': screen,
      }),
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      if (responseData is List) {
        final List<dynamic> data = json.decode(response.body);
        final List<YTBModel> videoList =
            data.map((item) => YTBModel.fromJson(item)).toList();
        return videoList;
      } else {
        final List<YTBModel> videoList = [];
        return videoList;
      }
    } else {
      throw Exception('Failed to load datas');
    }
  }

  Future<void> Test(String user, String screen) async {
    final response = await http.post(
      Uri.parse('${apiURL}albumVideo.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user': user,
        'screen': screen,
      }),
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      // if(json.decode(response.body).length > 2) {
      //   final List<dynamic> data = json.decode(response.body);
      //   final List<YTBModel> videoList =
      //   data.map((item) => YTBModel.fromJson(item)).toList();
      //   return videoList;
      // } else {
      //   final List<YTBModel> videoList = [];
      //   return videoList;
      // }
    } else {
      throw Exception('Failed to load datas');
    }
  }

  Future<List<InteractModel>> getInteractData(int MaVD) async {
    final response = await http.post(
      Uri.parse('${apiURL}videoInteracts.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'MaVD': MaVD,
      }),
    );

    if (response.statusCode == 200) {
      if (json.decode(response.body).length > 1) {
        final List<dynamic> data = json.decode(response.body);
        final List<InteractModel> interactList =
            data.map((item) => InteractModel.fromJson(item)).toList();
        return interactList;
      } else {
        final List<InteractModel> interactList = [];
        return interactList;
      }
    } else {
      throw Exception('Failed to load datas');
    }
  }

  Future<bool> sendInteract(InteractModel interact) async {
    final response = await http.post(
      Uri.parse('${apiURL}sendInteracts.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'mavd': interact.MaVD,
        'username': interact.Username,
        'type': interact.Type,
        'title': interact.Title,
        'posttime': interact.PostTime,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData[0]['Message'] == 'true') {
        return true;
      }
    }

    throw Exception('Failed to send data');
  }

  Future<bool> removeInteract(InteractModel interact) async {
    final response = await http.post(
      Uri.parse('${apiURL}removeInteracts.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'mavd': interact.MaVD,
        'username': interact.Username,
        'type': interact.Type,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData[0]['Message'] == 'true') {
        return true;
      }
    }

    throw Exception('Failed to send data');
  }

  Future<String> userLogin(String username, String password) async {
    final response = await http.post(
      Uri.parse('${apiURL}Login.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData[0]['Message'] == 'true') {
        return 'success';
      } else {
        return responseData[0]['Message'];
      }
    }

    throw Exception('Failed to send data');
  }

  Future<String> userRegister(String username, String password) async {
    final response = await http.post(
      Uri.parse('${apiURL}Register.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData[0]['Message'] == 'true') {
        return 'success';
      } else {
        return responseData[0]['Message'];
      }
    }

    throw Exception('Failed to send data');
  }

  Future<bool> postVideo(YTBModel video) async {
    final response = await http.post(
      Uri.parse('${apiURL}postVideo.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': video.TenVD,
        'hinh': video.Hinh,
        'theloai': video.Theloai,
        'username': video.Username,
        'video': video.URL,
        'posttime': video.PostTime,
        'luotxem': video.LuotXem,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData[0]['Message'] == 'true') {
        return true;
      } else {
        return false;
      }
    }

    throw Exception('Failed to send data');
  }

  Future<bool> addView(int mavd) async {
    final response = await http.post(
      Uri.parse('${apiURL}updateView.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'mavd': mavd,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData[0]['Message'] == 'true') {
        return true;
      } else {
        return false;
      }
    }

    throw Exception('Failed to send data');
  }
}
