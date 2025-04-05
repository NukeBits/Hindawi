import 'db.dart';
import 'struct.dart';
import 'scraper.dart' as scrp;
import 'package:http/http.dart' as http;
import 'package:hindawi/utils/fetch_page.dart';







  

Future<bool> fetch() async{
  int   page     = await LastPageNumber.get();
  final db       = BookDB.instance;
  bool  foundNew = false; // new books.


  List<Book> remoteBooks = [];

  while (!foundNew){
    final url   = Uri.parse('https://www.hindawi.org/books/$page/');
    final html  = (await http.get(url)).body;
    remoteBooks = scrp.AllBooksPage(html).books();

    for(Book b in remoteBooks){
      if (!(await db.bookExists(b.id))){
        foundNew = true;
        break;
      }
    }
    if (!foundNew) page += 1;
  }

  int sortNum = await db.smallestSortNum();
  for (Book b in remoteBooks){
    db.addBook(b, sortNum--);
  }
  LastPageNumber.set(page+1);

  

  return true;
}





