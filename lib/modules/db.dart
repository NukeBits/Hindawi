import 'package:hindawi/modules/struct.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



const bookTableName = 'books';
const fetchLimit    = 10;


class BookDB {
  static final BookDB instance = BookDB._constructor();
  static Database? _db;


  BookDB._constructor();




  Future<Database> get database async{
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }


  Future<Database> getDatabase() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'books.db');
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE IF NOT EXISTS $bookTableName (
            id    INTEGER PRIMARY KEY NOT NULL,
            title TEXT NOT NULL,
            cover TEXT NOT NULL,
            url   TEXT NOT NULL,


            content   TEXT,
            authors   TEXT,
            tags      TEXT,

            pdf       TEXT,
            kfx       TEXT,
            epub      TEXT,

            words     INTEGER,
            
            sort      INTEGER

          )
        ''');
      },
    );

    return database;

  }


  void addBook(Book bk, int bookSort) async{
    final db = await database;
    await db.insert(
      bookTableName,
      {
        "id"     :  bk.id,
        "title"  :  bk.title,
        "url"    :  bk.url,
        "cover"  :  bk.coverUrl,
        "content":  bk.content,
        "authors":  bk.authors.join(":"),
        "tags"   :  bk.tags.join(":"),
        "words"  :  bk.words,

        "pdf"    :  bk.pdf,
        "kfx"    :  bk.kfx,
        "epub"   :  bk.epub,
        
        "sort"   :  bookSort
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<bool> bookExists(int bookID) async{
    final db = await database;
    final result = await db.query(
      bookTableName,
      where: 'id = ?',
      whereArgs: [bookID],
    );
    return result.isNotEmpty;
  }


  Future<int> smallestSortNum() async{
    final db = await database;
    int num = 0;
    while (true){
      final result = await db.query(
        bookTableName, 
        where: 'sort = ?',
        whereArgs: [num,]
      );
      if (result.isEmpty) return num;
      num--;
    }
  }


  Future<Iterable<Book>> getBooks() async{
    final db     = await  database;
    return (await db.query(bookTableName)).reversed.map(_map2Book);
  }


  Future<List<Book>> getOffSet(int page) async{
    final db = await database;
    return (await db.query(
      bookTableName,
      offset: page*fetchLimit,
      limit: fetchLimit,
      orderBy: 'sort DESC',
    )).map(_map2Book).toList();
  }


  Book _map2Book(Map<String,dynamic> bkMap){
    return Book(
			id      : bkMap['id']!,
			title   : bkMap['title']!,
			url     : bkMap['url']!,
			coverUrl: bkMap['cover']!,
			
			authors : (bkMap['authors']!.isEmpty)?[]:bkMap['authors']!.split(":"), 
			tags    : (bkMap['tags']!.isEmpty)?[]:bkMap['tags']!.split(":"),
			content : bkMap['content'],
			
			
			pdf : bkMap['pdf'],
			epub: bkMap['epub'],
			kfx : bkMap['kfx'], 

    );

  }


}


  

