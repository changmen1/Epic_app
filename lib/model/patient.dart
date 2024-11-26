class Patient {
  String? myPatientIdent;
  String? myHospitalNumber;
  String? myPatientName;
  String? mySex;
  int? myAge;
  String? myBirthDay;
  String? myBedNumber;
  String? myDeptIndent;
  List<String>? patientBindOutputVO;

  Patient({
    this.myPatientIdent,
    this.myHospitalNumber,
    this.myPatientName,
    this.mySex,
    this.myAge,
    this.myBirthDay,
    this.myBedNumber,
    this.myDeptIndent,
    this.patientBindOutputVO,
  });

  Patient.fromJson(Map<String, dynamic> json) {
    myPatientIdent = json['patientIdent'];
    myHospitalNumber = json['hospitalNumber'];
    myPatientName = json['patientName'];
    mySex = json['sex'];
    myAge = json['age'];
    myBirthDay = json['birthDay'];
    myBedNumber = json['bedNumber'];
    myDeptIndent = json['deptIndent'];
    patientBindOutputVO = List<String>.from(json['patientBindOutputVO'] ?? []);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['patientIdent'] = myPatientIdent;
    data['hospitalNumber'] = myHospitalNumber;
    data['patientName'] = myPatientName;
    data['sex'] = mySex;
    data['age'] = myAge;
    data['birthDay'] = myBirthDay;
    data['bedNumber'] = myBedNumber;
    data['deptIndent'] = myDeptIndent;
    data['patientBindOutputVO'] = patientBindOutputVO;
    return data;
  }
}
