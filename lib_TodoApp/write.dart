import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/data/database.dart';

import 'data/todo.dart';

// TodoWritePage라는 고정된 클래스를 만들고
class TodoWritePage extends StatefulWidget{
  final Todo todo;

  //생성자를 생성한다음
  //아래의 this.todo의 의미는 Navigator.of(ctx).push(MaterialPageRoute)로 넘겨올 때 꼭 todo가 있어야한다는 의미
  //이유는 수정이나 새로 글 쓸때 같은 UI가 사용되기 때문에 수정 시 받아올 데이터로 todo 사용
  TodoWritePage({Key key, this.todo}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    //아래의 위젯 state클래스를 반환하면 아래의 위젯 클래스가 화면에 출력된다
    return _TodoWritePageState();
  }
}

//실제로 작성해야하는 state를 가지고 있는 위젯 페이지
class _TodoWritePageState extends State<TodoWritePage>{
  int colorIndex = 0;
  int ctIndex = 0;

  //저장할 때 데이터베이스에 저장하기위해서 아래 dbhelper생성
  //걍 db작업할 때 다 들어간다고 보면됨
  final dbHelper = DataBaseHelper.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  @override
  //initState란 이 페이지가 처음에 생성될 때 해야하는 일들을 먼저 처리함
  //약간 스프링 get방식으로 페이지 들어갔을 때 미리 데이터 넘겨주고 작업 하는 개념
  void initState() {
    super.initState();
    //페이지에 들어온 순간 받아온 t의 title과 memo를 text에 넘겨받고
    //그 글을 수정한 후 다시 t를 메인페이지에 넘겨주면 그 text가 overwrite되어서
    //글이 수정되는 개념
    nameController.text = widget.todo.title;
    memoController.text = widget.todo.memo;
  }

  @override
  Widget build(BuildContext context) {
    //가장 기본이되는 Scaffold를 생성하고
    return Scaffold(
    //   필요시 Appbar까지 생성
      appBar: AppBar(
        //위젯들을 리스트로 가져가는 actions
        actions: [
          //텍스트 버튼이기 때문에 onPress까지 지정한다.
          TextButton(
            child: Text("저장", style: TextStyle(color: Colors.white),),
            onPressed: () async{
            //  onPress = 페이지 저장 시 사용할 press
            //  저장 시 들어가있는 텍스트를 controller를 통해서 객체에 넣은 후 저장한다.
              widget.todo.title = nameController.text;
              widget.todo.memo = memoController.text;

              // 이때 await과 async를 쓰는 이유는 데이터베이스 저장하고 완료될때까지 기다려야되기 때문
              //안기다리면 db업뎃이 안될수도
              await dbHelper.insertTodo(widget.todo);

            // 저장 후에 받은 정보들을 뒤에 있는 페이지에 넘겨주면서 뒤로 가진다
              Navigator.of(context).pop(widget.todo);
            },
          )
        ],
      ),
      //위젯 추가 시 body 필드안에 집어넣고 column이든 ListView든 사용
      //하지만 모든 핸드폰 크기가 다르기때문에 거의 대부분 ListView를 먼저 사용해서 뼈대를 잡음
      body: ListView.builder(
          itemBuilder: (ctx, idx){
            if(idx == 0){
              //항상 Container로 감싸서 위젯 생성하자
              return Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text("제목",style: TextStyle(fontSize: 20),),
              );
            }
            else if(idx == 1){
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                //TextField를 추가할 때 항상 상위에 TextEditingController 선언 필수
                child: TextField(
                //  TextField에 수정 시 임의의 값을 넣어주어야 하기 때문에 TextEditing을 선언한다.
                  controller: nameController,
                  ),
              );
            }
            else if(idx ==  2){
              return InkWell(child:Container(
                margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("색상", style: TextStyle(fontSize: 20),),
                    Container(
                      width: 20,
                      height: 20,
                      // 상위의 클래스에 접근이 가능한데 위젯 클래스 안에 있어서 바로 todo로 접근은 불가능하다.
                      // 따라서 widget이라는 기호?를 붙여줘야 위의 클래스 내에 변수에 접근이 가능하다.
                      color: Color(widget.todo.color),
                    )
                  ],
                ),
              ),
                  onTap: (){
                List<Color> colors = [
                  Color(0xFF80d3f4),
                  Color(0xFFa794fa),
                  Color(0xFFfb91d1),
                  Color(0xFFfb8a94),
                  Color(0xFFfebd9a),
                  Color(0xFF51e29d),
                  Color(0xFFFFFFFF)
                ];

                widget.todo.color = colors[colorIndex].value;
                colorIndex++;
                setState(() {
                  colorIndex %= colors.length;
                });

              },
              );
            }
            else if(idx == 3){
              return InkWell(child:Container(
                margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("카테고리", style: TextStyle(fontSize: 20),),
                    Text(widget.todo.category)
                  ],
                ),
              ),
              onTap: (){
                List<String> categories = ["공부","운동","게임"];
                setState(() {
                  widget.todo.category = categories[ctIndex];
                  ctIndex++;
                  ctIndex %= categories.length;
                });
              },
              );
            }
            else if(idx == 4){
              return Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text("메모", style: TextStyle(fontSize: 20),),
              );
            }
            else if(idx == 5){
              return Container(
                margin: EdgeInsets.symmetric(vertical: 1, horizontal: 16),
                child: TextField(
                  controller: memoController,
                //여러줄로 변경할 수 있는 maxline, minline 옵션 추가
                  maxLines: 10,
                  minLines: 10,
                  //메모 칸의 데코레이션, border 추가
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                    )
                  ),
                ),
              );
            }
            return Container();

          },
        itemCount: 6,
      ),
    );
  }

}