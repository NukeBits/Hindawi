







class Book{
  int    id;
  String title;
  String url;
  String coverUrl;



  List<String> authors;
  List<String> tags;

  String? content;
  String? pdf;      
  String? kfx; 
  String? epub;
  int     words;





  Book({
    required this.id,
    required this.title,
    required this.url, 
    required this.coverUrl,


    this.content,
    this.pdf,
    this.kfx,
    this.epub,
    this.words=0,
    this.authors = const <String>[],
    this.tags    = const <String>[],
  });



  @override
  String toString() => title;

}
