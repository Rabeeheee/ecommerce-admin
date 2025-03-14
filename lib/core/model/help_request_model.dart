class HelpRequestModel {
  final String userID;
  final String requestID;
  final String email;
  final String name;
  final DateTime dateTime;
  final String subject;
  final String body;
  final String? answer;
  HelpRequestModel({
    required this.userID,
    required this.email,
    required this.dateTime,
    required this.requestID,
    required this.name,
    required this.subject,
    required this.body,
  required  this.answer,
  });

  factory HelpRequestModel.fromJson(Map<String, dynamic> json) {
    return HelpRequestModel(
      userID: json['userID'],
      requestID: json['requestID'],
      email: json['email'],
      dateTime: DateTime.parse(json['dateTime']),
      name: json['name'],
      subject: json['subject'],
      body: json['body'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID':userID,
      'email': email,
      'name': name,
      'subject': subject,
      'body': body,
      'requestID': requestID,
      'dateTime': dateTime.toIso8601String(),
      'answer': answer,
    };
  }
}
