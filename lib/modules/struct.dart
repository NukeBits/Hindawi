







class Book{
  int    id;
  String title;
  String url;
  String cover_url;



  List<String> authors;
  List<String> tags;

  String? content;
  String? pdf;      
  String? kfx; 
  String? epub;
  String? words;





  Book({
    required this.id,
    required this.title,
    required this.url, 
    required this.cover_url,


    this.content,
    this.pdf,
    this.kfx,
    this.epub,
    this.words,
    this.authors = const <String>[],
    this.tags    = const <String>[],
  });



  @override
  String toString() => title;

}
