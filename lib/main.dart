import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

//2.8(수) 각 타일 이동기능 완료, 시작 시 원본 리스트랑 서로 만들어서 비교기능 추가해야함 <- 2.17(금) 완료 여부 검사기 완료
//2.17(금) 이미지 잘라야되는데 내장 API 없어서 다른거 찾아야됨 아오 킹받음 <- 2.27(월) Image.assets 쓰려면 이미지 파일 별도로 나눠야해서 따로 조각냄
//2.27(월) 이미지 별도로 조각내서 assets에 추가함 각 셀별로 src 할당완료 이동시 cell 따라서 이미지 출력까지 확인함,
//        Cell 별 index 구분해서 완료되도록 하는 로직 구현해야함






//한칸용 클래스
class Cell {
  String src;
  bool isEmpty;
  int originIndex;
  Cell(this.src,this.isEmpty,this.originIndex);
}
// 4*4 퍼즐칸용 배열을 반환하는 만드는 함수
List makePuzzleList (int idx) {
  List<Cell> res = [];

  final int emptyIndex = idx;

  for(int i = 0 ; i < 16 ; i++){
    if(i == idx){
      res.add(Cell('empty', true,i));
    }else{
      res.add(Cell('assets/image/${i+1}.jpg', false,i));
    }
  }
  return res;
}

// 두 배열이 서로 동일한지 검사하는 함수
bool checkComplete(List origin, List current){
  bool res = true;
//지금 여기가 다르다가 나오면 안됨 ㅋㅋㅋㅋㅋㅋㅋㅋ
  List originIndexs = [3,3,3,3,3];
  List currentIndexs = [3,3,3,3,3];

  for(int i = 0; i < origin.length ; i++){
    if(origin[i] != current[i]){
      return res = false;
    }
  }

  return res;
}

//빈자리 const 값
const int emptyIndex = 3;

//뷰를 뿌리기위한 데이터를 저장하는 A
List A = makePuzzleList(emptyIndex);

//처음 데이터를 저장해놓을 B
final List B = A;
//테스트용
bool Complete = checkComplete([1,2,3,4,5],[1,2,3,4,5]);


//메인
void main() {
  runApp(const MyApp());
}
//메인에서 실행시킬 스테이트풀 위젯을 상속받는 MyApp
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}
//MyApp 에서 실행될 MyApp형태의 State를 상속받는 클래스
class _MyAppState extends State<MyApp> {


  void swapData (List data, int currentIndex, int nextIndex){
    //전체 데이터를 받고, 클릭된 인덱스와 이동 가능한 인덱스를 받아서 서로 바꿔주는 함수
    setState(() {
      Cell temp = data[currentIndex];
      data[currentIndex] = data[nextIndex];
      data[nextIndex] = temp;
    });
  }

  void swapCell (List data, int currentIndex){
    //클릭되었을 때 직접적으로 작동될 함수
    //전체 데이터와 클릭된 인덱스를 받아옴
    //이동 가능한 인덱스를 만들어서 swapData로 넘겨줌

    int nextIndex = 0;
    //각 셀이 상하좌우의 움직임에 대해서 계산하면됨
    //상하좌우에 대해서 비어있는지 검사하고 서로 교환
    // 사실 nextIndex는 여기 안에서 구해야함
    bool isUp = currentIndex < 4 ? false : true;
    bool isDown = currentIndex > 11 ? false : true;
    bool isRight = (currentIndex+1) % 4 == 0 ? false: true;
    bool isLeft = currentIndex % 4 == 0 ? false: true;
    // print("상${isUp},우${isRight},하${isDown},좌${isLeft}");
    // 현재 인덱스에 따라서 이동 가능한 범위 계산 완료
    // 이동할 빈 공간 데이터 찾아야함
    for(int i = 0 ; i < data.length ; i ++){
      if(data[i].isEmpty == true){
        nextIndex = i;
      }
    }

    if(data[currentIndex].isEmpty != true) {
      if (isUp && (data[currentIndex - 4].isEmpty == true) ||
          isRight && (data[currentIndex + 1].isEmpty == true) ||
          isDown && (data[currentIndex + 4].isEmpty == true) ||
          isLeft && (data[currentIndex - 1].isEmpty == true)) {
        swapData(data, currentIndex, nextIndex);
      }
    }
}

  // final originImg = Image.asset('assets/image/cat_1.jpg');

  @override
  Widget build(BuildContext context) {
    // print("width:${originImg.width}");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("MyCatPuzzle"),
          actions: [
            IconButton(onPressed: () { exit(0); }, icon: Icon(Icons.exit_to_app))
          ],
        ),
        body: Container(
          child: GridView.count(crossAxisCount: 4,
          padding: EdgeInsets.all(3.0),
          childAspectRatio: 1/1,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          children: List.generate(A.length, (index){
              return InkWell(
                onTap: (){
                  // print("$index _index");
                swapCell(A,index);
                print("B : ${B}");
                print("A : ${A}");
                print("같다${B == A}");
                print("------------------------------");
                },
                child: Container(
                color: index%2 == 1 ? Colors.blue : Colors.yellow,
                // child: Center(child:Text("${index}")),
                // child: Center(child: Text("${A[index].originIndex}\n ${A[index].isEmpty.toString()}"))
                // child: A[index].isEmpty ? Center(child: Text("${A[index].src}")):Image.asset('assets/image/${index+1}.jpg',fit: BoxFit.fill ),
                  child: A[index].isEmpty ? Center(child: Text("${A[index].src}")):Image.asset(A[index].src,fit: BoxFit.fill ),
          ));
          })
          ,),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
              height: 50.0,
              child: Center(
                child: Row(
                  children: [
                    // Text(Image.asset('assets/image/cat_1.jpg',fit: BoxFit.fill).toString()),
                    Center(child: Text(Complete ? "같다": "다르다", style: TextStyle(fontSize: 30),))
                  ],
                ),
              )
    ),
        ),
      ),
    );
  }
}


