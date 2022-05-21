// 데이터를 개별적으로 관리하기 위해 분리한다.
// 자바 controller 나누는 것과 비슷함

class Todo{
  String title;
  String memo;
  String category;
  // 데이터 베이스에 저장할 것이기 때문에 Color객체말고 color int값인 RGB값을 받아서 나중에 치환한다.
  int color;
  //완료 여부 int 저장
  int done;
  int date;
  int id;

  //생성자 초기화
  Todo({this.title, this.memo, this.category, this.color, this.done, this.date, this.id});

}