// target: https://www.hindawi.org/books/(\d{1,3}/?)?

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'struct.dart' show Book;




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
      cover_url: imgAttr['src']!,
    );
  }



  List<Book> books(){
    return tree.querySelectorAll(".books_covers ul > li").map(
      (e) => _elmnt2book(e)
    ).toList();
        
  }
}



