import 'package:hindawi/modules/db.dart';
import 'package:hindawi/modules/struct.dart';
import 'package:http/http.dart' as http;
import 'package:hindawi/modules/scraper.dart' as scrp;
import 'package:hindawi/glob.dart' show DM;







class UpdateManager{
  static const pageLimit = 2; 
  final Function? trigger;

  
  List<Book>      _books = [];
  Map<String,int> _info  = {
    "pages"       :0,
    "books"       :0,
    "loaded-books":0,
    "new-books"   :0,
  };

  

  UpdateManager({
    this.trigger
  }){
    _report();
  }



  void resources() async{
    final db       = BookDB.instance;
    bool  foundNew = false;

    for (int page=1; page<=pageLimit; page++){

      final url   = Uri.parse('https://www.hindawi.org/books/$page/');
      final html  = (await http.get(url)).body;
      final scrapedBooks = scrp.AllBooksPage(html).books();

      _info['pages'] = _info['pages']! + 1;
      _report();

      
      for(Book b in scrapedBooks){
        if (!(await db.bookExists(b.id))){
          foundNew = true;
          break;
        }
      }
      _books += scrapedBooks;
      
      if (!foundNew){
        break;
      }
    }
    _insertBooks();
    _info['done'] = pageLimit;
    _report();

  }


  void _insertBooks() async{
    final db       = BookDB.instance;
    _info['books'] = _books.length;
    for (Book bk in _books.reversed){
      _info['loaded-books'] = _info['loaded-books']! + 1;
      if(!(await db.bookExists(bk.id))){
        final html   = (await http.get(Uri.parse(bk.url))).body;
        _info['new-books'] = _info['new-books']! + 1;
        final fullBk = scrp.BookPage(html).book(bk);
        db.addBook(fullBk);
        await DM!.downloadCover(fullBk.id, fullBk.coverUrl);
        
      }
      _report();
    }
  }

  void _report() async{
    if(trigger!=null) trigger!(_info);
  }
}



