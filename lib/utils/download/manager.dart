import 'dart:io';
import 'dart:collection' show Queue;
import 'package:hindawi/modules/struct.dart';
import 'package:hindawi/utils/download/process.dart';
import 'package:http/http.dart' as http;






class DownloadManager{
  Map<String,DownloadProcess> processMap   = {};
  Queue<DownloadProcess>      processQueue = Queue<DownloadProcess>();

  DownloadProcess? _currentProcess;



  Future<void> queCover(Book bk, File file, Function? callBackFunc) async{
    final id   = 'cover${bk.id}';

    if (processMap.containsKey(id)){
      DownloadProcess prs = processMap[id]!;

      if (callBackFunc!=null) prs.addCallBack(callBackFunc);

      processQueue.add(prs);
    }
    else{

	
	
	    var prs = DownloadProcess(
	      id    : id,
	      action: () async{
          if (await file.exists()) return;
	        final r = await http.get(Uri.parse(bk.coverUrl));
	        await file.writeAsBytes(r.bodyBytes);
          
	      }
	    );
	
	
	    processMap[id] = prs;
	    if (callBackFunc!=null) prs.addCallBack(callBackFunc);
	    processQueue.add(prs);
    }
    // need clean up solution for memory.

    if (_currentProcess==null || !(_currentProcess!.isRunning()) ) starter();
  }




  void starter() async{
    if (_currentProcess != null){
      if (_currentProcess!.isRunning()) return;
    }
    if (processQueue.isEmpty) return;



    _currentProcess = processQueue.removeFirst();
    // conditions require exit.
    if(_currentProcess!.isRunning() || _currentProcess!.doneWithoutErr()) return;
    // conditions to start or restart.
    if(_currentProcess!.doneWithErr() || _currentProcess!.isSleep()){
        if (_currentProcess!.isSleep()) _currentProcess!.addCallBack(starter);
        _currentProcess!.start();
    }
    

  }


  bool processExists(String id){
    return processMap.containsKey(id);
  }


  DownloadProcess? getProcess(String id){
    return processMap[id]; 
  }




}
