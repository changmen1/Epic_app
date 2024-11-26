class MqttData {
  String? myDevCode;
  String? myDevStatus;
  String? myDevName;
  String? myIp;
  String? myMpHR;
  String? myMpPluseRate;
  String? myMpSpO2;
  String? myMpRespRate;
  String? myMpPerf;
  String? myMpNBPsys;
  String? myMpNBPdia;
  String? myMpNBPmean;

  MqttData({
    this.myDevCode,
    this.myDevStatus,
    this.myDevName,
    this.myIp,
    this.myMpHR,
    this.myMpPluseRate,
    this.myMpSpO2,
    this.myMpRespRate,
    this.myMpPerf,
    this.myMpNBPsys,
    this.myMpNBPdia,
    this.myMpNBPmean,
  });

  MqttData.fromJson(Map<String, dynamic> json) {
    myDevCode = json['devCode'];
    myDevStatus = json['devStatus'];
    myDevName = json['devName'];
    myIp = json['ip'];
    myMpHR = json['mpHR'];
    myMpPluseRate = json['mpPluseRate'];
    myMpSpO2 = json['mpSpO2'];
    myMpRespRate = json['mpRespRate'];
    myMpPerf = json['mpPerf'];
    myMpNBPsys = json['mpNBPsys'];
    myMpNBPdia = json['mpNBPdia'];
    myMpNBPmean = json['mpNBPmean'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['devCode'] = myDevCode;
    data['devStatus'] = myDevStatus;
    data['devName'] = myDevName;
    data['ip'] = myIp;
    data['mpPluseRate'] = myMpHR;
    data['mpSpO2'] = myMpSpO2;
    data['mpRespRate'] = myMpRespRate;
    data['mpPerf'] = myMpPerf;
    data['mpNBPsys'] = myMpNBPsys;
    data['mpNBPdia'] = myMpNBPdia;
    data['mpNBPmean'] = myMpNBPmean;
    return data;
  }
}
