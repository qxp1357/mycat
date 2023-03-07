import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

//2.8(수) 각 타일 이동기능 완료, 시작 시 원본 리스트랑 서로 만들어서 비교기능 추가해야함 <- 2.17(금) 완료 여부 검사기 완료
//2.17(금) 이미지 잘라야되는데 내장 API 없어서 다른거 찾아야됨 아오 킹받음 <- 2.27(월) Image.assets 쓰려면 이미지 파일 별도로 나눠야해서 따로 조각냄
//2.27(월) 이미지 별도로 조각내서 assets에 추가함 각 셀별로 src 할당완료 이동시 cell 따라서 이미지 출력까지 확인함,
//        Cell 별 index 구분해서 완료되도록 하는 로직 구현해야함 <- 3.3(금) 로직 구현 완료
//3.3(금) 완료 로직 구성완료, 게임 진행 플로우 수정 중  시작 -> 완료 -> 재시작 혹은 종료
//        프로토타입 테스트 결과 => 조작감이 너무 어렵다. 직관적이지 못한 듯
//        GestureDetector 알아보는 중 -> inkWell 대체해야 될 수 있음
//3.6(월) 슬라이딩 구현은 했고 조건도 기초는 만들어 놨는데 이미지가 안들어간다. 수정 필요함
//3.7(화) 슬라이딩 구현 바꿈 -> 말랑말랑 애니메이션으로 변경 중
//        슬슬 각 기능 컴포넌트화 중
//한칸용 클래스
class Cell {
  String src;
  bool isEmpty;
  int originIndex;
  double xOffset;
  double yOffset;

  Cell(this.src, this.isEmpty, this.originIndex, this.xOffset, this.yOffset);
}

// 4*4 퍼즐칸용 배열을 반환하는 만드는 함수
List makePuzzleList(int idx) {
  List<Cell> res = [];

  final int emptyIndex = idx;

  for (int i = 0; i < 16; i++) {
    if (i == idx) {
      res.add(Cell('empty', true, i, 0.0, 0.0));
    } else {
      res.add(Cell('assets/image/${i + 1}.jpg', false, i, 0.0, 0.0));
    }
  }
  return res;
}

void swapData(List data, int currentIndex, int nextIndex) {
  //전체 데이터를 받고, 클릭된 인덱스와 이동 가능한 인덱스를 받아서 서로 바꿔주는 함수
  Cell temp = data[currentIndex];
  data[currentIndex] = data[nextIndex];
  data[nextIndex] = temp;
}

// 두 배열이 서로 동일한지 검사하는 함수
bool checkComplete(List origin, List current) {
  bool res = true;
  for (int i = 0; i < origin.length; i++) {
    if (origin[i].originIndex != current[i].originIndex) {
      return res = false;
    }
  }
  return res;
}

void shuffleList(List current) {
  Random random = Random();

  for (int i = current.length - 1; i > 0; i--) {
    print("shuflling");
    int j = random.nextInt(i + 1);
    Cell temp = current[i];
    current[i] = current[j];
    current[j] = temp;
  }
}

//빈자리 const 값
const int emptyIndex = 15;

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
  List A = makePuzzleList(emptyIndex);

//초기 데이터를 저장해놓을 B
  List B = makePuzzleList(emptyIndex);

  bool startFlag = false;
  Offset position = Offset.zero;

  double _xOffset = 0.0;
  double _yOffset = 0.0;

  void startGame() {
    setState(() {
      startFlag = true;
    });
    shuffleA();
  }

  void swapDataState(List data, int currentIndex, int nextIndex) {
    //전체 데이터를 받고, 클릭된 인덱스와 이동 가능한 인덱스를 받아서 서로 바꿔주는 함수
    setState(() {
      swapData(data, currentIndex, nextIndex);
    });
  }

  void swapCell(List data, int currentIndex) {
    //클릭되었을 때 직접적으로 작동될 함수
    //전체 데이터와 클릭된 인덱스를 받아옴
    //이동 가능한 인덱스를 만들어서 swapData로 넘겨줌

    int nextIndex = 0;
    //각 셀이 상하좌우의 움직임에 대해서 계산하면됨
    //상하좌우에 대해서 비어있는지 검사하고 서로 교환
    // 사실 nextIndex는 여기 안에서 구해야함
    bool isUp = currentIndex < 4 ? false : true;
    bool isDown = currentIndex > 11 ? false : true;
    bool isRight = (currentIndex + 1) % 4 == 0 ? false : true;
    bool isLeft = currentIndex % 4 == 0 ? false : true;
    // print("상${isUp},우${isRight},하${isDown},좌${isLeft}");
    // 현재 인덱스에 따라서 이동 가능한 범위 계산 완료
    // 이동할 빈 공간 데이터 찾아야함
    for (int i = 0; i < data.length; i++) {
      if (data[i].isEmpty == true) {
        nextIndex = i;
      }
    }

    if (data[currentIndex].isEmpty != true) {
      if (isUp && (data[currentIndex - 4].isEmpty == true) ||
          isRight && (data[currentIndex + 1].isEmpty == true) ||
          isDown && (data[currentIndex + 4].isEmpty == true) ||
          isLeft && (data[currentIndex - 1].isEmpty == true)) {
        swapDataState(data, currentIndex, nextIndex);
      }
    }
  }

  void shuffleA() {
    setState(() {
      shuffleList(A);
    });
  }

  void reGame() {
    setState(() {
      startFlag = false;
      A = B;
    });
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
            IconButton(
                onPressed: () {
                  exit(0);
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        // body: GestureDetector(
        //     onHorizontalDragUpdate: (DragUpdateDetails details) {
        //       setState(() {
        //         _xOffset += details.delta.dx;
        //       });
        //     },
        //     onVerticalDragUpdate: (DragUpdateDetails details) {
        //       setState(() {
        //         _yOffset += details.delta.dy;
        //       });
        //     },
        //     child: Container(
        //       alignment: Alignment.topLeft,
        //       child: Stack(
        //         children: [
        //           Positioned(
        //               left: _xOffset,
        //               top: _yOffset,
        //               child: Container(
        //                 width: 300,
        //                 height: 300,
        //                 color: Colors.blue,
        //               ))
        //         ],
        //       ),
        //     )),
        body: Container(
          child: GridView.count(
            crossAxisCount: 4,
            // padding: EdgeInsets.all(3.0),
            childAspectRatio: 1 / 1,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            children: List.generate(A.length, (index) {
              return GestureDetector(
                // onTapDown: (details){
                //   setState(() {
                //     position = details.localPosition;
                //   });
                // },

                onPanUpdate: (details) {
                  bool isUp = index < 4 ? false : true;
                  bool isDown = index > 11 ? false : true;
                  bool isRight = (index + 1) % 4 == 0 ? false : true;
                  bool isLeft = index % 4 == 0 ? false : true;

                  setState(() {
                    final dx = details.delta.dx;
                    final dy = details.delta.dy;
                    // print("detail${details.localPosition}");
                    print("detailA[index].yOffset${A[index].yOffset}");
                    if (isDown && A[index].yOffset >= 0) {
                      A[index].yOffset += dy;
                    } else {
                      A[index].yOffset = 0;
                    }

                    // if (dx.abs() > dy.abs()) {
                    //   A[index].xOffset += dx;
                    // } else {
                    //   A[index].yOffset += dy;
                    // }
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    A[index].xOffset = 0;
                    A[index].yOffset = 0;
                    swapCell(A, index);
                    // position = Offset.zero;
                  });
                },
                child: Stack(
                  // fit: StackFit.expand,
                  // clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                        left: A[index].xOffset,
                        top: A[index].yOffset,
                        // width: 150,
                        // height: 150,
                        child: A[index].isEmpty
                            ? Center(child: Text("${A[index].src}"))
                            : ClipRRect(
                              borderRadius:
                              BorderRadius.only(
                                  topLeft:Radius.circular(A[index].yOffset),
                                  topRight:Radius.circular(A[index].yOffset),
                                  bottomLeft: Radius.circular(A[index].yOffset/2),
                                  bottomRight: Radius.circular(A[index].yOffset/2),
                              ),
                                child: ShaderMask(
                                  shaderCallback:(Rect bound){
                                    return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Colors.transparent,Colors.white],
                                        stops: [0,A[index].yOffset/800]
                                    ).createShader(bound);
                                  },
                                  blendMode:BlendMode.dstIn,
                                  child: Image.asset(
                                    A[index].src,
                                    fit: BoxFit.fill,
                                  ),
                              ),
                            )),
                  ],
                ),
              );
              // return InkWell(
              //     onTap: () {
              //       swapCell(A, index);
              //     },
              //     child: Container(
              //       color: index % 2 == 1 ? Colors.blue : Colors.yellow,
              //       child: A[index].isEmpty
              //           ? Center(child: Text("${A[index].src}"))
              //           : Image.asset(A[index].src, fit: BoxFit.fill),
              //     ));
            }),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
              height: 200.0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!startFlag)
                      ElevatedButton(
                          onPressed: () => startGame(), child: Text("시작"))
                    else
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side:
                                BorderSide(width: 1.0, color: Colors.blueGrey),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent,
                          ),
                          onPressed: shuffleA,
                          child: Text("다시 섞기")),
                    checkComplete(B, A) && startFlag
                        ? AlertDialog(
                            title: Text("퍼즐을 모두 맞췄습니다."),
                            content: Text("퍼즐을 다시 시작하시겠습니까?"),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      {Navigator.of(context).pop()},
                                  child: Text("그만하기")),
                              TextButton(
                                  onPressed: () => {reGame()},
                                  child: Text("또 하기")),
                            ],
                          )
                        : Text("맞추는 중.."),
                    // Text(
                    //   checkComplete(B, A) && startFlag ? "같다" : "다르다",
                    //   style: TextStyle(fontSize: 30),
                    // ),

                    // IconButton(onPressed: ()=> shuffleList(A), icon: Icon(Icons.refresh)),

                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.blue,
                        width: 3.0,
                      )),
                      child: Image.asset('assets/image/cat_1.jpg',
                          fit: BoxFit.cover, width: 200, height: 200),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
