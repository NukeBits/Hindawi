import 'package:http/http.dart' as http;
import 'dart:io';


class DownloadManager{
  final String path;
  
  DownloadManager({required this.path});


  Future<bool> downloadCover(int bookID, String imgUrl) async{
    final file    = File("$path/covers/$bookID.svg");
    if(await file.exists()) return true;

    final imgData = (await http.get(Uri.parse(imgUrl))).bodyBytes;
    await file.writeAsBytes(imgData);
    
    return true;
  }
}


