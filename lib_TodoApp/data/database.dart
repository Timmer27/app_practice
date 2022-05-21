//아래는 데이터베이스 연동을 위한 보일러 코드. 그냥 가져다 쓰자
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:untitled/data/todo.dart';

class DataBaseHelper{
  static final _databaseName = "todo.db";
  //처음 version이 1이라는 의미
  static final _databaseVersion = 1;
  static final todoTable = "todo";

  DataBaseHelper._privateConstructor();

  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    //기존의 데이터베이스가 이미 만들어져있으면
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }
  //없다면 아래 init으로 초기화
  _initDatabase() async{
    var databasePath = await  getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate,
      onUpgrade: _onUpgrade);
  }

  //앱을 처음 깔고 실행이 됬을 때 이 기능이 실행되서 테이블이 추가됨
  Future _onCreate(Database db, int version) async{
    //DB table 실행 명령어 - id는 필드에 접근하기 위한 고유 primary key, AI로 생성
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $todoTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date INTEGER DEFAULT 0,
        done INTEGER DEFAULT 0,
        title String,
        memo String,
        color INTEGER,
        category String
      )
    ''');
  }

  //업그레이드에 필요한 초기화. 현재 버전이 없기때문에 빈칸
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async{}

//  t.odo 입력, 수정, 불러오기 sql문장 만들어보기
  Future<int> insertTodo(Todo todo) async{
    Database db = await instance.database;

    //todo의 id가 없다, 즉 추가할때
    if(todo.id == null) {
      Map<String, dynamic> row = {
        "title": todo.title,
        "date": todo.date,
        "done" : todo.done,
        "memo": todo.memo,
        "color": todo.color,
        "category": todo.category
      };

      //insert를 사용해  todotable삽입
      //이름은 위에 지정했던 final 상수인 todotTable, 값 values는 위에 지정했던 row
      return await db.insert(todoTable, row);
    }
    else{
      Map<String, dynamic> row = {
        "title": todo.title,
        "date": todo.date,
        "done" : todo.done,
        "memo": todo.memo,
        "color": todo.color,
        "category": todo.category
      };
      //where, 즉 id가 ?인 사람을 업데이트 = args로 인자를 업데이트 한다
      return await db.update(todoTable, row, where: "id = ?", whereArgs: [todo.id]);
    }
  }
  //있는 모든 tod.o데이터를 받는 메서드
  Future<List<Todo>> getAllTodo() async{
    Database db = await instance.database;
    //받아온 t/.odo 객체를 넣을 리스트
    List<Todo> todos = [];

    //
    var queries = await db.query(todoTable);

    for(var q in queries){
      todos.add(Todo(
        id: q["id"],
        title : q["title"],
        date : q["date"],
        done: q["done"],
        memo : q["memo"],
        category : q["category"],
        color : q["color"],
      ));
    }
    return todos;
  }

  //있는 모든 tod.o데이터 + date만 가져오는 쿼리문 date를 파라미터로 받는다
  Future<List<Todo>> getTodoByDate(int date) async{
    Database db = await instance.database;
    //받아온 t/.odo 객체를 넣을 리스트
    List<Todo> todos = [];
    //
    var queries = await db.query(todoTable, where: "date = ?", whereArgs: [date]);

    for(var q in queries){
      todos.add(Todo(
        id: q["id"],
        title : q["title"],
        date : q["date"],
        done: q["done"],
        memo : q["memo"],
        category : q["category"],
        color : q["color"],
      ));
    }
    return todos;
  }


}