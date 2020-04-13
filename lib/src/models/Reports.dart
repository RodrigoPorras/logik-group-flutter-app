

import 'Report.dart';

class Reports{

  List<Report> allReports = List<Report>();

  Reports({this.allReports});

  factory Reports.fromJson(List<dynamic> json){
    return Reports(
      allReports : json.map( (i) => Report.fromJson(i)).toList(),
    );
  }

  List<dynamic> toJson() => allReports;

}