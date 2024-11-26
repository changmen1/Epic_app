class AlarmHistory {
  String? id;
  String? deptIdent;
  String? bedNumber;
  String? patientIdent;
  String? patientName;
  String? createdTime;
  String? devCode;
  String? devName;
  String? devTypeName;
  String? paramCode;
  double? paramValue;
  String? content;
  String? ip;
  String? level;

  AlarmHistory({
    this.id,
    this.deptIdent,
    required this.bedNumber,
    required this.patientIdent,
    this.patientName,
    required this.createdTime,
    required this.devCode,
    required this.devName,
    required this.devTypeName,
    required this.paramCode,
    required this.paramValue,
    required this.content,
    required this.ip,
    required this.level,
  });

  factory AlarmHistory.fromJson(Map<String, dynamic> json) {
    return AlarmHistory(
      id: json['id'],
      deptIdent: json['deptIdent'],
      bedNumber: json['bedNumber'],
      patientIdent: json['patientIdent'],
      patientName: json['patientName'], // nullable field
      createdTime: json['createdTime'],
      devCode: json['devCode'],
      devName: json['devName'],
      devTypeName: json['devTypeName'],
      paramCode: json['paramCode'],
      paramValue: json['paramValue'],
      content: json['content'],
      ip: json['ip'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deptIdent': deptIdent,
      'bedNumber': bedNumber,
      'patientIdent': patientIdent,
      'patientName': patientName,
      'createdTime': createdTime,
      'devCode': devCode,
      'devName': devName,
      'devTypeName': devTypeName,
      'paramCode': paramCode,
      'paramValue': paramValue,
      'content': content,
      'ip': ip,
      'level': level,
    };
  }
}

