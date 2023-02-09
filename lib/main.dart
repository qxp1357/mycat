import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

//2.8(수) 각 타일 이동기능 완료, 시작 시 원본 리스트랑 서로 만들어서 비교기능 추가해야함


class Cell {
  String src;
  bool isEmpty;
  int originIndex;
  Cell(this.src,this.isEmpty,this.originIndex);
}

List makePuzzleList (int idx) {
  List<Cell> res = [];

  final int emptyIndex = idx;

  for(int i = 0 ; i < 16 ; i++){
    if(i == idx){
      res.add(Cell('empty', true,i));
    }else{
      res.add(Cell('assets/image/cat_1.jpg', false,i));
    }
  }
  return res;
}

bool checkComplete(List origin, List current){
  bool res;

  List originIndexs = [3,3,3,3,3];
  List currentIndexs = [3,3,3,3,3];

  return res = originIndexs == currentIndexs;
}

int emptyIndex = 3;

List A = makePuzzleList(emptyIndex);
final List B = A;

bool Complete = checkComplete([3],[2]);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  void swapData (List data, int currentIndex, int nextIndex){

    setState(() {
      Cell temp = data[currentIndex];
      data[currentIndex] = data[nextIndex];
      data[nextIndex] = temp;
    });
  }

  void swapCell (List data, int currentIndex){
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

//     setState(() {
//       Cell temp = data[currentIndex];
//       data[currentIndex] = data[nextIndex];
//   data[nextIndex] = temp;
// });
}
  @override
  Widget build(BuildContext context) {



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
                child: A[index].isEmpty ? Center(child: Text("${A[index].src}")):Image.asset('assets/image/cat_1.jpg',fit: BoxFit.fill),
          ));
          })
          ,),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
              height: 50.0,
              child: Center(child: Text(Complete ? "같다": "다르다", style: TextStyle(fontSize: 30),))),
        ),
      ),
    );
  }
}


