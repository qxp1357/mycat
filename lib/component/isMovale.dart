bool isMovale(List _data,int _index){
// 현재 리스트 상황과 선택된 셀의 인덱스 값을 받음
// 목적은 이동가능한지 여부를 판단하고 어느방향인지 아는 것
// 방향은 쉬운데.. 빈자리의 인덱스를 구하고
// -1 이면 왼쪽 +1 이면 오른쪽 -1 보다 더 작으면 위 +1 보다 더 크면 아래
// 문제는 그 빈자리 구하긴..가?
  List data = _data;
  int currentIndex = _index;
  int nextIndex = 0;
  String dir = "";

  //이동 불가능 여부 체크
  bool canT = currentIndex < 4 ? false : true;
  bool canB = currentIndex > 11 ? false : true;
  bool canR = (currentIndex + 1) % 4 == 0 ? false : true;
  bool canL = currentIndex % 4 == 0 ? false : true;


  //비어있는 곳의 인덱스 값을 구함
  for (int i = 0; i < data.length; i++) {
    if (data[i].isEmpty == true) {
      nextIndex = i;
    }
  }

  //어느방향인지 어림짐작으로 구함
  if(currentIndex +1 == nextIndex){
    dir="R";
  }else if(currentIndex -1 == nextIndex){
    dir="L";
  }else if(currentIndex +1 > nextIndex){
    dir="B";
  }else if(currentIndex -1 < nextIndex){
    dir="T";
  }




  //결국 반환해야하는 값은
  //어느방향으로 애니메이션을 줄지임
  //애니메이션이 작동해야하는 방향이 어디인가?

  return true;
}