import 'package:flutter/material.dart';
import 'package:hindawi/modules/db.dart';
import 'package:hindawi/modules/struct.dart';
import 'package:hindawi/widgets/book2row.dart';
import 'package:hindawi/modules/update_manager.dart';

import 'widgets.dart' show EmptyDataBaseMessage, UpdateReportWidget;



const waitingWidget = Padding(
  padding: const EdgeInsets.symmetric(vertical: 15),
  child  : Center(child: const CircularProgressIndicator(),),
);


const endWidget = Padding(
  padding: const EdgeInsets.symmetric(vertical: 15),
  child  : Center(
    child: const Text("No More Books", style: TextStyle(
      color: Colors.grey,
    ))
  ),
);






final db = BookDB.instance;



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  final controller = ScrollController();
  int   page       = 1;
  bool  noMore     = false;
  bool  _fetched   = false;

  List<Book> books = [];


  bool _updating  = false;
  Map<String,int>? _updateReport;
  






  @override
  Widget build(BuildContext context) {
    if (page==1) {
      fetchBooksDB();
    }
    return Scaffold(
      appBar: AppBar(
        title:Text("${page}"),
        centerTitle: true,
      ),


      body:(_updating)?UpdateReportWidget(updateReport: _updateReport):
      RefreshIndicator(
        onRefresh: () async{_startUpdate();},
        // check if there is no books in db.  
        child: (books.isEmpty && _fetched)?EmptyDataBaseMessage(action:_startUpdate):ListView.builder(
          controller: controller,
          itemBuilder:(context, index){
            if(index<books.length) return book2row(books[index]);
            else return (noMore)?endWidget:waitingWidget;
          },
          itemCount: books.length+1,
        ),
      ),
    );
  }


  void fetchBooksDB() async{
    List<Book> bks = (await db.getOffSet(page++));
    if (bks.length == 0) noMore = true;
    setState(() {
      books += bks;
    });
    _fetched = true;
          
  }


  void _startUpdate() async{
    if (_updating) return;
    books.clear();
    _fetched = false;
    noMore   = false;

    UpdateManager(trigger:_trackUpdate).resources();
    setState(() {
      _updating = true;
    });
  }


  void _trackUpdate(Map<String,int> updateReport) async{
    setState(() {
      _updateReport = updateReport;
    });
    if (updateReport['done']!=null && updateReport['books']==updateReport['loaded-books']){
      await Future.delayed(Duration(milliseconds:1650)); 
      setState(() {
        _updateReport = null;
        _updating     = false;
        page          = 1;
        
      });
      return ;
    }
    
  }


  @override
  void initState(){
    super.initState();
    controller.addListener((){
      if(!noMore && controller.position.maxScrollExtent==controller.offset) fetchBooksDB();
    });
  }


  @override
  void dispose(){
    controller.dispose();
    super.dispose(); 
  }
}




