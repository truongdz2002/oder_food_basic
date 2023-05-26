import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oder_food/page/detailDish/reponsitory/view/DishDetail.dart';
import 'package:oder_food/ManagerCache/ManagerCache.dart';
import 'package:oder_food/RequestPermission/RequestpermissionAddress.dart';
import 'package:oder_food/UseBloc/BlocWithDish.dart';
import 'package:oder_food/UseDataFromApi/ApiDataDish.dart';
import 'package:oder_food/UseDataWithFirebase/FirebaseDataDish.dart';
import 'package:oder_food/page/home/bloc/HomeBloc.dart';
import 'package:oder_food/page/home/bloc/HomeEvent.dart';
import 'package:oder_food/page/home/bloc/HomeState.dart';
import 'package:oder_food/page/home/presentation/view/HomeProvider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../entity/Dish.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin{
   int activeIndex = 0;
   List<Dish> dishList=[];
  late final FirebaseDataDish firebaseDataDish=FirebaseDataDish();
  late final ManagerCache managerCache=ManagerCache();
  late final ApiDataDish apiDataDish=ApiDataDish();
  late final RequestpermissionAdrress requestpermissionAdrress=RequestpermissionAdrress();
  late ScrollController _scrollController;
  String textAddress='';
  bool _visibity=false;
  late TabController _tabController;
  final controller = CarouselController();
  final DatabaseReference ref=FirebaseDatabase.instance.ref();
  final HomeBloc _homeBloc=HomeBloc();
  @override
  void initState() {
    super.initState();
    _tabController=TabController(length: 3, vsync:this);
    _scrollController=ScrollController();
    _homeBloc.add(HomeGetList());
    //getListDataDish();
    //addressLocal();
    _scrollController.addListener(_handleScroll);
  }
   @override
   void dispose() {
     _scrollController.removeListener(_handleScroll);
     _scrollController.dispose();
     _tabController.dispose();
   }
    @override
    Widget build(BuildContext context) {
      return BlocProvider(
          create:(_)=>_homeBloc,
          child: BlocListener<HomeBloc,HomeState>(listener:(context, state) {
            if (state is HomeLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Success'),
                ),
              );
            }
          } ,child:Scaffold(
          body:BlocBuilder<HomeBloc,HomeState>(
            builder:(context,state) {
              if(state is HomeInitial)
                {
                  return Skeleton(isLoading: true, skeleton: SkeletonListView(), child: Container());
                }
              else if(state is HomeLoading)
                {
                  return Skeleton(isLoading: true, skeleton: SkeletonListView(), child: Container());
                }
              else if(state is HomeLoaded)
                {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _customAddressOder(),
                        _customSliderImage(state.dish),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10)
                              , child: const Text("Gợi ý món ăn ", style: TextStyle(
                              fontSize: 16,
                              color: Colors.orange,
                            ),),
                            )
                          ],
                        ),
                        _customOptionDish(),
                        const SizedBox(
                          height:10,
                        ),
                        _customListDish(state.dish)
                      ],
                    ),
                  );
                }
              else{
                return Container();
              }
            } ,
          )

      )
      )
      );
    }
    Widget buildIndicator() =>
        AnimatedSmoothIndicator(
          onDotClicked: animateToSlide,
          effect: const ExpandingDotsEffect(
              dotWidth: 5, dotHeight: 5, activeDotColor: Colors.orange),
          activeIndex: activeIndex,
          count: 6,
        );

    void animateToSlide(int index) => controller.animateToPage(index);
    Widget buildImages(String urlimage, int index) =>
        urlimage.isEmpty
            ? const SkeletonAvatar(
          style: SkeletonAvatarStyle(width: double.infinity, height: 200),)
            : Image.network(urlimage, fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object exception,
              StackTrace? stackTrace) {
            return const SkeletonAvatar(
              style: SkeletonAvatarStyle(width: double.infinity, height: 200),);
          },);
    Widget items(Dish item) =>
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => const DishDetail(),
                settings: RouteSettings(
                    arguments: item
                )));
          },
          child: SizedBox(
            height: 100,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 250,
                      child: item.urlImageDish.isEmpty ? const SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                            width: double.infinity, height: 200),) : Image
                          .network(item.urlImageDish, fit: BoxFit.fill,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const SkeletonAvatar(style: SkeletonAvatarStyle(
                              width: double.infinity, height: 200),);
                        },),
                    ),
                    Text(item.nameDish, style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                    ),
                    Text('${NumberFormat.decimalPattern()
                        .format(item.priceDish)
                        .replaceAll(',', '.')}  VND', style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 2.85
                    ),)
                    ,
                    Text('${NumberFormat.decimalPattern().format(
                        item.priceDish - item.priceDish * item.sale).replaceAll(
                        ',', '.')}  VND', style: const TextStyle(
                        fontSize: 14,
                        color: Colors.orange
                    ),)
                  ],
                ),
              ),
            ),
          ),
        );

   void scrollToSelectedType() {
     final selectedType =
     _tabController.index == 0
         ? 'food'
         : _tabController.index == 1
         ? 'drink'
         : 'dessert';

     final selectedTypeIndex = dishList.indexWhere((dish) => dish.type == selectedType);
     if (selectedTypeIndex != -1) {
       const itemSize = 120.0; // Adjust the item size according to your item widget
       final offset = selectedTypeIndex * itemSize;

       _scrollController.animateTo(
         offset,
         duration: const Duration(milliseconds: 400),
         curve: Curves.easeInOut,
       );
     }
   }
   void _handleScroll() {
     double scrollPosition = _scrollController.position.pixels;

     int index = dishList.indexWhere((dish) {
       double itemPosition = dishList.indexOf(dish) * 100.0; // Điều chỉnh kích thước của mỗi phần tử trong danh sách
       return itemPosition <= scrollPosition && scrollPosition < itemPosition + 100.0;
     });

     if (index != -1) {
       String itemType = dishList[index].type;
       if(itemType=='food')
         {
           _tabController.animateTo(0);
         }
       else if(itemType=='drink')
         {
           _tabController.animateTo(1);
         }
       else
         {
           _tabController.animateTo(2);
         }
     }
   }

   Future<void> getListDataDish()
   async {
     //dishList= await firebaseDataDish.getDishes();
     dishList= await apiDataDish.getDataDishApi();
     //dishList=await managerCache.getDishListFromCache();
   }
   Future<void> addressLocal() async {
     String address=await  requestpermissionAdrress.requestPermissionLocal();
     setState(()  {
       // Gán giá trị địa chỉ cho biến textAddress
       textAddress =address;

       // Đặt cờ hiển thị (_visibity) thành true
       _visibity = true;
     });
   }
   Widget _customAddressOder()=>Visibility(visible: _visibity, child:Column(
     children: [
       Row(
         children: const [
           Padding(
             padding: EdgeInsets.only(left: 8.0),
             child: Text('Giao đến',textAlign: TextAlign.center,style: TextStyle(
                 fontSize:12,
                 color:Colors.grey
             ),),
           ),
         ],
       ),
       Row(
         children: [
           const Padding(
             padding: EdgeInsets.all(4.0),
             child: Icon(Icons.location_on,color: Colors.orange,),
           ),
           SizedBox(
             width:320,
             child: Padding(
               padding: const EdgeInsets.all(4.0),
               child: Text(textAddress,style:const TextStyle(
                   fontSize:13
               ),),
             ),
           ),
           Padding(
             padding: const EdgeInsets.all(4.0),
             child: IconButton(onPressed: (){
               setState(() {
                 _visibity=false;
               });
             }, icon:const Icon(Icons.clear,color: Colors.grey,)),
           )
         ],
       ),
     ],
   )
   );

   Widget _customSliderImage(List<Dish> dish)=> SizedBox(
     width: double.infinity,
     child: Column(
       children: [
         CarouselSlider.builder(carouselController: controller,
             itemCount: 6,
             itemBuilder: (context, index, realIndex) {
               String urlImage;
               dish.isEmpty ? urlImage = '' : urlImage =
                   dish[index].urlImageDish;
               return buildImages(urlImage, index);
             },
             options: CarouselOptions(
                 height: 200,
                 autoPlay: true,
                 enableInfiniteScroll: false,
                 autoPlayAnimationDuration: const Duration(
                     seconds: 3),
                 enlargeCenterPage: true,
                 onPageChanged: (index, reason) =>
                     setState(() => activeIndex = index)
             )
         ),
         const SizedBox(height: 8),
         buildIndicator(),
         const SizedBox(height: 15),
       ],
     ),
   );

   Widget _customOptionDish()=> TabBar(onTap:(_)=> scrollToSelectedType(),controller:_tabController,isScrollable: true,tabs: const [
     Tab(child: Text('Món ăn',style: TextStyle(
         color: Colors.orange,
         fontSize:16,
         fontWeight: FontWeight.bold
     ),),),
     Tab(child: Text('Đồ uống ',style: TextStyle(
         color: Colors.orange,
         fontSize:16,
         fontWeight: FontWeight.bold
     )),),
     Tab(child: Text('Tráng miệng',
         style: TextStyle(
             color: Colors.orange,
             fontSize:16,
             fontWeight: FontWeight.bold
         )),)
   ],);

   Widget _customListDish(List<Dish> dish)=> SizedBox(
       width: double.infinity, height: 500,
       child: GridView(
         controller: _scrollController,
         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 2
         ),
         children: dish.map((item) {
           return items(item);
         }).toList(),
       )
   );
}



