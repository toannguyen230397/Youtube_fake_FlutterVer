class YTBModel {
  final int MaVD;
  final String TenVD;
  final String Hinh;
  final String Theloai;
  final String Username;
  final String URL;
  final int PostTime;
  final int LuotXem;

  YTBModel({required this.MaVD, required this.TenVD, required this.Hinh, required this.Theloai, required this.Username, required this.URL, required this.PostTime, required this.LuotXem});

  factory YTBModel.fromJson(Map<String, dynamic> json) {
    return YTBModel(
      MaVD: json['MaVD'],
      TenVD: json['TenVD'],
      Hinh: json['Hinh'],
      Theloai: json['Theloai'],
      Username: json['Username'],
      URL: json['URL'],
      PostTime: json['PostTime'],
      LuotXem: json['LuotXem']
    );
  }
}