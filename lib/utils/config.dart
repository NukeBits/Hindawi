import 'package:hindawi/modules/download_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hindawi/glob.dart' show documPath, DM;
import 'package:path/path.dart';
import 'dart:io';






Future<void> config() async{
  documPath = (await getApplicationDocumentsDirectory()).path;
  Directory coverDir = Directory(join(documPath, 'covers'));
  if (!await coverDir.exists()) await coverDir.create(recursive:true);
  DM = DownloadManager(path: documPath);
}
