class HelpCenterRequestModel {
  final String userID;
  final DateTime dateTime;
  final String userName;


  HelpCenterRequestModel({
    required this.userID,
    required this.dateTime,
    required this.userName,
  });

  factory HelpCenterRequestModel.fromJson(Map<String, dynamic> json) {
    return HelpCenterRequestModel(
      userID: json['userID'],
      dateTime: DateTime.parse(json['dateTime']),
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'dateTime': dateTime.toIso8601String(),
      'userName': userName,
    };
  }
}
