import 'dart:collection';





class DownloadProcess{
  final String   id;
  final Function action;

  Queue<Function> _onCompleteCallbacks = Queue<Function>(); // this will know the widgets that the process is done executing.

  // 0: didn't start yet.
  // 1: runing.
  // 2: done.
  // 3: done with error.
  int _state = 0;



  DownloadProcess({
    required this.id,
    required this.action,
  });


  


  Future<void> start() async{
    _state = 1;
    try{
      await action();
      _state = 2;
    } catch (e){
      _state = 3;
    }

    while (_onCompleteCallbacks.isNotEmpty){
      _onCompleteCallbacks.removeFirst()();
    }
    
  }


  void addCallBack(Function endAction){
    _onCompleteCallbacks.add(endAction);
  }


  
  bool isRunning() => _state==1;
  bool isSleep()   => _state==0;
  bool isDone()    => _state==2 || _state==3;


  bool doneWithErr()    => _state==3;
  bool doneWithoutErr() => _state==2;
}

