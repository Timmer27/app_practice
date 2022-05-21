// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:untitled/data/database.dart';
import 'package:untitled/data/todo.dart';
import 'package:untitled/data/util.dart';
import 'package:untitled/write.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'note'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //database클래스에서 instance  = _privateConstructor를 실행시켜서 기존 데이터베이스가 존재하면 그걸로 쓰고 아니면 새로 생성한다
  final dbHelper = DataBaseHelper.instance;

  //현재 페이지 인덱스 반환용 변수
  int selectIndex = 0;

  // 미완성된 task를 담기위해 list에 제너릭은 tod.o 클래스로 지정해서 담는다
  List<Todo> todos = [
    // Todo(
    // title: "국비지원 웹개발 강의1",
    // memo: "강의 듣기 [빅데이터]",
    // //Color의 value를 사용하면 컬러코드를 int로 변경한다
    // color: Colors.indigoAccent.value,
    // // 0 = 미완료, 1 = 완료
    // done: 0,
    // category: "공부",
    // date: 20210709
    // ),
    //
    // Todo(
    // title: "개인강의 앱강의2",
    // memo: "강의 듣기 [앱개발 플러터]",
    // //Color의 value를 사용하면 컬러코드를 int로 변경한다
    // color: Colors.deepOrangeAccent.value,
    // // 0 = 미완료, 1 = 완료
    // done: 1,
    // category: "공부",
    // date: 20210709
    // )
  ];


  void getTodayTodo() async{
    //오늘 날짜 기준으로 데이터를 불러와서 todos라는 빈 리스트 객체에 담은 후에 setState로 return 한다
    todos = await dbHelper.getTodoByDate(Util.getFormatTime(DateTime.now()));
    //화면 변경하는거니까 무조건 setState쓰고
    setState(() {});
  // 이 void메서드는 initState즉 앱이 처음으로 실행될 때 사용해서 데이터를 뿌린다.
  }

  void getAllTodo() async{
    //오늘 날짜 기준으로 데이터를 불러와서 todos라는 빈 리스트 객체에 담은 후에 setState로 return 한다
    allTodo = await dbHelper.getAllTodo();
    //화면 변경하는거니까 무조건 setState쓰고
    setState(() {});
    // 이 void메서드는 initState즉 앱이 처음으로 실행될 때 사용해서 데이터를 뿌린다.
  }


  @override
  void initState() {
    getTodayTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //PreferredSize로 감싸주고 Size.formHeight로 상단 배너 없애기
      appBar: PreferredSize(child:AppBar(),
        preferredSize: Size.fromHeight(0),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        //눌렀을 때 화면이동 필요
        onPressed: () async {
          //값을 넘겨받을때까지 기다려야하기 때문에 await이라는 비동기 함수를 써주고
          //비동기라는 것을 알려주기위해 위에 async를 선언해준다.
          //이 받은 값을 새로운 객체에 저장하고 전에 선언되어있던 todos 리스트에 받은 값을 add해준다.
          Todo todo = await Navigator.of(context).push(
              //새로 메모 생성하는 것이기 때문에 모든 넘겨주는 값은 빈칸 or 초기값
              MaterialPageRoute(builder: (ctx) => TodoWritePage(todo: Todo(
                title: "",
                color: 0,
                memo: "",
                done: 0,
                category: "",
                // 만들어놨던 메서드 사용하여 현재 시간 반환
                date: Util.getFormatTime(DateTime.now()),

              ),)));
          //전 페이지에서 넘겨받은 todo값을 새롭게 리스트에 넣음으로써 리스트 출력이 완료된다.
          // 화면이 변경되는 작업이므로 setState()를 사용해서 실시간 변경한다.
          // setState(() {
            getTodayTodo();
            //   todos.add(todo);
          // });
        //  원래라면 리스트에 넣어서 출력했지만 이제 db에 저장했기 때문에 위의 작성작업이 끝나고 db정보를 불러온다.
        //   getTodayTodo();

        },
      ),
      body: getPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.today_outlined),
              label:"오늘"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind_outlined),
              label:"기록"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label:"더보기"
          ),
        ],
        //현재 currentIndex를 위의 지역변수 selectIndex로 지정하고
        currentIndex: selectIndex,
        //tap이 눌릴때마다 selectIndex를 선택된 idx로 변경함
        onTap: (idx){
          //만약 history기록 탭을 눌렀으면 기존에 있던 데이터를 가지고 출력
          if(idx == 1){
            getAllTodo();
          }

          //값이 실시간 변경되는거니까 setState를 선언
          setState(() {
            selectIndex = idx;
          });
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //페이지 이동을 위한 메서드들
  Widget getPage(){
    if(selectIndex == 0){
      return getMain();
    }
    else{
      return getHistory();
    }
  }

  //1번이면 getMain페이지가 나오도록 캡슐화
  Widget getMain(){
    return ListView.builder(
      //itemBuilder를 사용하면 리스트를 위젯에 넣을때 어떤 리스트를 몇번째 위젯에 넣을건지 물어봄
      //따라서 idx는 = index이고
      itemBuilder: (ctx, idx){

        //미완료된 리스트만 위에 넣어야하므로 다른 리스트를 생성해서 구별한다.
        //where = 일종의 반복문 ()안에 개별로 나올 객체의 이름을 선언하고 t.done[예시]가 0인것만 골라서 toList로 리스트형태로 반환한다
        List<Todo> undone = todos.where((t){
          return t.done == 0;
        }).toList();

        //위와 동일하게 완료된 리스트만 where을 통해 리스트를 추출한다.
        List<Todo> done_list = todos.where((t){
          return t.done == 1;
        }).toList();

        if(idx == 0){
          return Container(
            child: Text("오늘하루", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          );
        }
        else if(idx == 1){
          return Container(
            //미완성 task가 들어가기 때문에 여러줄 즉 Column으로 감싸야한다.
              child: Column(
                  children:
                  //List에 여러가지가 들었기 때문에 generate을 사용
                  // todos.length 만큼, 지정된 _idx를 통해서 나옴
                  List.generate(undone.length, (index){
                    //리스트를 인덱싱해서 인덱스에 맞게 표출
                    Todo t = undone[index];
                    // return Text("$index");
                    return InkWell(child: TodoCardWidget(t: t),
                      onTap: () async{
                        setState(() {
                          if(t.done == 0){
                            t.done = 1;
                          }
                          else{
                            t.done = 0;
                          }
                        });
                        await dbHelper.insertTodo(t);
                      },
                      // 화면을 한번 클릭하는 것이 아닌 longpress, 즉 길게 클릭하는 것
                      //  수정을 하기 위한 것이므로 await과 async를 사용하여 값을 다시 넘겨받을 때까지 기다림
                      onLongPress: () async {
                        Todo todo = await Navigator.of(context).push(
                          //새로운 값이 아니기 때문에 기존에 관리하던 t를 가지고 넘어간다.
                          //이대로 실행하면 제목과 메모가 안들어가있는데 그 이유는 controller에 지정을 안했기 떄문
                          //write.dart파일 상단의 initState()메서드에서 controller에다가 title, memo를 지정해준다.
                            MaterialPageRoute(builder: (ctx) => TodoWritePage(todo: t)));
                        //뭐 안에 안 넣어도 그냥 이 메서드만 실행해주면 값이 실시간 변경됨
                        setState(() {});
                      },
                    );
                  })
              )
          );
        }
        else if(idx == 2){
          return Container(
            child: Text("완료된 하루", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          );
        }
        else if(idx == 3){
          return Container(
            //미완성 task가 들어가기 때문에 여러줄 즉 Column으로 감싸야한다.
              child: Column(
                  children:
                  //List에 여러가지가 들었기 때문에 generate을 사용
                  // todos.length 만큼, 지정된 _idx를 통해서 나옴
                  List.generate(done_list.length, (index){
                    //리스트를 인덱싱해서 인덱스에 맞게 표출
                    Todo t = done_list[index];
                    // return Text("$index");
                    return InkWell(child: TodoCardWidget(t: t),
                      onTap: () async{
                        setState(() {
                          if(t.done == 1){
                            t.done = 0;
                          }
                          else{
                            t.done = 1;
                          }

                        });
                        //완료된 항목도 done으로 업뎃해줘야 다음에 실행할때도 업뎃된걸로 나온다.
                        // 업뎃까지 기다려야함
                        await dbHelper.insertTodo(t);
                      },
                      onLongPress: () async {
                        // Todo todo = await Navigator.of(context).push(
                        //새로운 값이 아니기 때문에 기존에 관리하던 t를 가지고 넘어간다.
                        //이대로 실행하면 제목과 메모가 안들어가있는데 그 이유는 controller에 지정을 안했기 떄문
                        //write.dart파일 상단의 initState()메서드에서 controller에다가 title, memo를 지정해준다.
                        //   MaterialPageRoute(builder: (ctx) => TodoWritePage(todo: t)));
                        //뭐 안에 안 넣어도 그냥 이 메서드만 실행해주면 값이 실시간 변경됨
                        // setState(() {});
                        getTodayTodo();
                      },
                    );
                  })
              )
          );
        }

        return Container();
      },
      //총 화면에 표시할 숫자
      itemCount: 4,
    );
  }

  //모든 History를 확인해야하기 때문에 새로운 리스트로 데이터를 받는다.
  List<Todo> allTodo = [];

  Widget getHistory(){
    return ListView.builder(
      itemBuilder: (ctx, idx){
        return TodoCardWidget(t : allTodo[idx]);
      },
      //총 allTodo의 길이만큼 위의 t 인덱스에 대입하여 카드를 만든다.
      itemCount: allTodo.length,
    );

  }
}


// 조건을 클래스화, 즉 캡슐화시켜서 재사용이 편리하도록 만듦
// statelessWidget으로 설정한 이유는 어차피 done의 값에 따라 리스트 출력이 변경되는 것이기 때문에
// 위젯 자체가 바뀌는 것이 아니므로 statelessWidget으로 설정함
class TodoCardWidget extends StatelessWidget{
  final Todo t;

  //TodoCardWidget을 생성할때 매개변수로 받는다
  TodoCardWidget({Key key, this.t}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // int now = Util.getFormatTime(DateTime.now());
    // DateTime time = Util.numToDateTime(t.date);
    return Container(
      //Container는 꾸밀 수가 있음 = decoration
      decoration: BoxDecoration(
        // 사용자 지정 색깔로 지정
          color: Color(t.color),
          // 박스 둥글게
          borderRadius: BorderRadius.circular(16)
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      //symmetric : 상하 좌우 로 나눠서 지정
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        //Column 행의 열을 바꾸는 것이기 때문에 crossAxisAlignment 사용
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
              Text(t.done == 0 ? "미완료" : "완료", style: TextStyle(color: Colors.white),)
            ],
          ),
          Container(height: 8,),
          Text(t.memo, style: TextStyle(color: Colors.white)),
          // Text(now == t.date ? "" : "${time.month}월 ${time.day}일", style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}
