import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oder_food/Dish/DishDetail.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Dish/Dish.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
   int activeIndex = 0;
   bool _isLoading=true;
  List<Dish> dishList=[];
  final controller = CarouselController();
  final DatabaseReference ref=FirebaseDatabase.instance.ref();
  @override
  void initState() {
    super.initState();
    getDataDishRealTimeDataBase();
    if(dishList.isEmpty)
    {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState((){
          _isLoading = false;
        });
      });
    }
  }
  Future<void> getDataDishRealTimeDataBase()
  async {
    List<Dish> dishes = [];
    ref.child('dishes').onValue.listen((event) {
        List<Object?> a=event.snapshot.value as List<Object?>;
        List<Object> nonNullableList = a.where((element) => element != null).toList().cast<Object>() ;
        for (var element in nonNullableList) {
          Map<String, dynamic> map = Map.from(element as dynamic);
          dishes.add(Dish.fromSnapshot(map));
          dishList=dishes;
          dishList.sort((a,b)=>b.amountBuyDish.compareTo(a.amountBuyDish));
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: _isLoading
              ?Skeleton(
            isLoading: true,
            skeleton: SkeletonListView(),
            child: Container(),
          ):
                  SingleChildScrollView(
                    child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            CarouselSlider.builder(carouselController:controller ,
                                itemCount:6, itemBuilder:(context, index, realIndex)
                                {
                                  String  urlImage;
                                  dishList.isEmpty ? urlImage ='':urlImage=dishList[index].urlImageDish;
                                  return buildImages(urlImage , index);
                                }, options: CarouselOptions(
                                    height: 200,
                                    autoPlay: true,
                                    enableInfiniteScroll: false,
                                    autoPlayAnimationDuration: const Duration(seconds: 3),
                                    enlargeCenterPage: true,
                                    onPageChanged:(index, reason) => setState(() => activeIndex = index)
                                )
                            ),
                            const SizedBox(height: 8),
                            buildIndicator(),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10)
                            ,child: const Text("Gợi ý món ăn ",style:TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                          ),),
                          )
                        ],
                      ),
                      SizedBox(
                          width: double.infinity,height: 500,
                          child: GridView(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2
                            ),
                            children:dishList.map((item)
                            {
                              return items(item);
                            }).toList(),
                          )
                      )

    ],
    ),
                  )
              )

       

    );
  }
  Widget buildIndicator() => AnimatedSmoothIndicator(
    onDotClicked: animateToSlide,
    effect: const ExpandingDotsEffect(dotWidth: 5,dotHeight:5, activeDotColor: Colors.orange),
    activeIndex: activeIndex,
    count: 6,
  );

  void animateToSlide(int index) => controller.animateToPage(index);
  Widget buildImages(String urlimage,int index)=>urlimage.isEmpty ?  const SkeletonAvatar(style: SkeletonAvatarStyle(width:double.infinity,height: 200),) : Image.network(urlimage,fit: BoxFit.cover,errorBuilder:(BuildContext context, Object exception, StackTrace? stackTrace)
  {
    return const SkeletonAvatar(style: SkeletonAvatarStyle(width:double.infinity,height: 200),);
  },);
  Widget items(Dish item)=>GestureDetector(
    onTap: ()
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const DishDetail(),settings: RouteSettings(
          arguments: item
      ) ));
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height:100,
              width: 250,
              child:item.urlImageDish.isEmpty ?const SkeletonAvatar(style: SkeletonAvatarStyle(width:double.infinity,height: 200),) :Image.network(item.urlImageDish,fit:BoxFit.fill,errorBuilder:(BuildContext context, Object exception, StackTrace? stackTrace)
              {
                return const SkeletonAvatar(style: SkeletonAvatarStyle(width:double.infinity,height: 200),);
              },),
            ),
            Text(item.nameDish,style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
            ),
            Text('${NumberFormat.decimalPattern().format(item.priceDish).replaceAll(',','.')}  VND',style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 2.85
            ),)
            ,
            Text('${NumberFormat.decimalPattern().format(item.priceDish-item.priceDish*item.sale).replaceAll(',','.')}  VND',style: const TextStyle(
                fontSize: 14,
                color: Colors.orange
            ),)
          ],
        ),
      ),
    ),
  );
}

