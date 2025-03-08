import 'package:hindawi/modules/db.dart';
import 'package:hindawi/modules/struct.dart';
import 'package:http/http.dart' as http;
import 'package:hindawi/modules/scraper.dart' as scrp;
import 'package:hindawi/glob.dart' show DM;










void updateResources(Function? trigger) async{
  final db = BookDB.instance;
  List<Book> books = [];
  bool foundNew = false;
  for (int page=1; page<=10; page++){
    foundNew = false;

    final  url  = Uri.parse('https://www.hindawi.org/books/$page/');
    final  html = (await http.get(url)).body;

    books += scrp.AllBooksPage(html).books();
    
    for (Book b in books){
      if (!(await db.bookExists(b.id))){
        foundNew = true;
        break;
      }
    }
    if (!foundNew) break;

  } 


  for (Book bk in books.reversed){
    if(!(await db.bookExists(bk.id))){
      final html   = (await http.get(Uri.parse(bk.url))).body;
      final fullBk = scrp.BookPage(html).book(bk);
      db.addBook(fullBk);
      DM!.downloadCover(fullBk.id, fullBk.coverUrl);
      if(trigger!=null)trigger();
    }
  }
  
}
