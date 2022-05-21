// int 값의 Color등을 RGB로 치환하기 위해서 어떤 기능들을 특정한 파일에 모아놓는데 그 이름을 util.dart로 지정
class Util{
  static int getFormatTime(DateTime date){
    return int.parse("${date.year}${makeTwoDigits(date.month)}${makeTwoDigits(date.day)}");
  }

  //10보다 작은 수를 0을 붙여줘서 date를 20220101같은 형식으로 치환
  static String makeTwoDigits(int num){
    //padLeft left즉 왼쪽에 2자 미만은 0을 붙임 = 3 ==> 03
    return num.toString().padLeft(0, "2");
  }

  static DateTime numToDateTime(int date){
    //받아온 DateTime 객체를 String화 시킴 //20220101
    String _d = date.toString();
    int year = int.parse(_d.substring(0,4));
    int month = int.parse(_d.substring(4, 6));
    int day = int.parse(_d.substring(6, 8));

    return DateTime(year, month, day);
  }
}
