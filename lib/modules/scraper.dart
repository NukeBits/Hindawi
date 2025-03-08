import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'struct.dart' show Book;



// target: https://www.hindawi.org/books/\d{4,}/?
class BookPage{
  late Document tree;

  BookPage(String html): this.tree = parse(html);


  List<String> _extractTxtList(String query) => tree.querySelectorAll(query).map((e) => e.text.trim()).toList();


  String? _findID(String elementID){
    Element? elmnt = tree.querySelector('#$elementID');
    return (elmnt==null)?null:elmnt.attributes['href']!.trim();
  }


  Book book(Book bk){
    return Book(
      id      : bk.id,
      url     : bk.url,
      title   : bk.title,
      coverUrl: bk.coverUrl,
      authors : _extractTxtList(".author > a"),
      tags    : _extractTxtList(".tags > li > a"),
      pdf     : _findID("pdf"),
      epub    : _findID("epub"),
      kfx     : _findID("kfx"), 
    );
  }

}



// target: https://www.hindawi.org/books/(\d{1,3}/?)?
class AllBooksPage{
  late Document tree;

  AllBooksPage(String html): this.tree = parse(html);


  Book _elmnt2book(Element e){
    String href = e.querySelector("a")!.attributes['href']!;
    final  imgAttr = e.querySelector('img')!.attributes;


    return Book(
      id       :  int.parse(RegExp(r'/books/(\d{4,})').firstMatch(href)!.group(1)!),
      url      : "https://www.hindawi.org$href",
      title    : imgAttr['alt']!.replaceAll("كتاب بعنوان", "").trim(),
      coverUrl: imgAttr['src']!,
    );
  }


  List<Book> books(){
    return tree.querySelectorAll(".books_covers ul > li").map(
      (e) => _elmnt2book(e)
    ).toList();
        
  }
}



