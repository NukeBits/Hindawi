import 'package:flutter/material.dart';
import 'package:hindawi/modules/db.dart';
import 'package:hindawi/modules/struct.dart';
import 'package:hindawi/widgets/book2row.dart';
import 'package:hindawi/modules/remote.dart' as Remote;


import 'widgets.dart' show EmptyDataBaseMessage;



const waitingWidget = Padding(
  padding: const EdgeInsets.symmetric(vertical: 15),
  child  : Center(child: const CircularProgressIndicator(),),
);

// is not reachable yet. 
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
  bool  fetchLock  = false;
  int   page       = 0;
  bool  noMore     = false;
  bool  _fetched   = false;

  List<Book> books = [];

 


  @override
  Widget build(BuildContext context) {
    if (page==0) {
      localFetch();
    }
    return Scaffold(
      appBar: AppBar(
        title:Text("$page"),
        centerTitle: true,
      ),


      body:RefreshIndicator(
        onRefresh: () async{},
        // check if there is no books in db.  
        child: (books.isEmpty && _fetched)?EmptyDataBaseMessage(action:emptyDBAction):ListView.builder(
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
  

  // this function called the first time ever launching the app.
  void emptyDBAction() async{
    await Remote.fetch();
    setState(() {
      page = 0;
      _fetched = noMore = false;
    });
  }


  void remoteFetch() async{
    await Remote.fetch();
    final bks = await db.getOffSet(page-1);

    setState(() {
      books += bks;
    });

    fetchLock = false;
  }


  void localFetch() async{
    List<Book> bks = (await db.getOffSet(page++));
    if (bks.length == 0){ 
      remoteFetch();
      return;
    }
    setState(() {
      books += bks;
    });
    _fetched = true;
    fetchLock = false;

          
  }
  

  @override
  void initState(){
    super.initState();
    controller.addListener((){
      if(!noMore && controller.position.maxScrollExtent==controller.offset){
        if(!fetchLock){
          fetchLock = true;
          localFetch();
        }
      }
    });
  }


  @override
  void dispose(){
    controller.dispose();
    super.dispose(); 
  }
}




