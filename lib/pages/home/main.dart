import 'package:flutter/material.dart';
import 'package:hindawi/modules/db.dart';
import 'package:hindawi/modules/struct.dart';
import 'package:hindawi/widgets/book2row.dart';
import 'package:hindawi/modules/update_manager.dart';



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
  Map<String,int>? _updateInfo;
  






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


      body:(!_updating)?RefreshIndicator(
      onRefresh: () async{_startUpdate();},
        child: (page==2 && books.isEmpty && _fetched)?Center(
			    child: Column(
			      mainAxisSize: MainAxisSize.min,
			      children: [
			        const Text(
			          "try to fetch new books", 
			          style: TextStyle(
			            color: Colors.grey,
			          ),
			        ),
			        ElevatedButton(
			          onPressed: (){_startUpdate();},
			          child    : Text("fetch"),
			        ),
			      ],
			    )
			  ):ListView.builder(
          controller: controller,
          itemBuilder:(context, index){
            if(index<books.length) return book2row(books[index]);
            else return (noMore)?endWidget:waitingWidget;
          },
          itemCount: books.length+1,
        ),
      ):genUpdateWidget(_updateInfo),
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


  void _trackUpdate(Map<String,int> updateInfo) async{
    setState(() {
      _updateInfo = updateInfo;
    });
    if (updateInfo['done']!=null && updateInfo['books']==updateInfo['loaded-books']){
      await Future.delayed(Duration(milliseconds:1650)); 
      setState(() {
        _updateInfo = null;
        _updating   = false;
        page        = 1;
        
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



Widget genUpdateWidget(Map<String,int>? updateInfo){
  if (updateInfo==null)return Container();
  const col2 = Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children:[
      Text('كتب جديدة'), // New Books
      Text('إجمالي الطلبات'), // Total Req
      Text('الصفحات'), // Pages    
    ]
  );
  
  final total = updateInfo["pages"]! + updateInfo["new-books"]!*2;
  final col1  = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('${updateInfo["new-books"]}'),
      Text('${total}'),
      Text('${updateInfo["pages"]}')
    ]
  );


  return Center(
    child: Column(
      mainAxisSize:MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          child:LinearProgressIndicator(
            value:(updateInfo['books']==0)?0:updateInfo['loaded-books']!/updateInfo['books']!,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            backgroundColor: Colors.grey,
          )
        ),
        Row(
          mainAxisSize:MainAxisSize.min,
          children: [
            col1,
            Column(
              children: List.generate(
                3, (int) => Padding(
                  padding: EdgeInsets.symmetric(horizontal:4),
                  child:Text(":")
                )
              ),
            ),
            col2,
          ],
        )
      ],
    ),
  );
}
