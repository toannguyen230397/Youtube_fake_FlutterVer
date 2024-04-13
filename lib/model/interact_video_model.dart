class InteractModel {
  final int MaTT;
  final int MaVD;
  final String Username;
  final String Type;
  final String Title;
  final int PostTime;

  InteractModel({required this.MaTT, required this.MaVD, required this.Username, required this.Type, required this.Title, required this.PostTime});

  factory InteractModel.fromJson(Map<String, dynamic> json) {
    return InteractModel(
      MaTT: json['MaTT'],
      MaVD: json['MaVD'],
      Username: json['Username'],
      Type: json['Type'],
      Title: json['Title'],
      PostTime: json['PostTime'],
    );
  }
}