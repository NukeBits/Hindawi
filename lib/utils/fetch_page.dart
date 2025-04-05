import 'package:hindawi/glob.dart' show documPath;
import 'dart:io';










class LastPageNumber{
  static final file = File(documPath+'/page.txt');

  static void set(int pageNumber) async{
    await file.writeAsString(pageNumber.toString());
  }


  static Future<int> get() async{
    return int.parse(await _read());
  }


  static Future<String> _read() async{
    return (await file.exists())?(await file.readAsString()):'1';
  }



}
