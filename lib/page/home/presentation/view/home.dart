import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oder_food/bloc/Generalterm/GetListDish/GetListDataEvent.dart';
import 'package:oder_food/bloc/Generalterm/GetListDish/GetListDishBloc.dart';
import 'package:oder_food/bloc/Generalterm/GetListDish/GetListDishState.dart';
import 'package:oder_food/bloc/ProcessingPageHome/ProcessingAdressLocal/AddressLocal/AddressLocalBloc.dart';
import 'package:oder_food/bloc/ProcessingPageHome/ProcessingAdressLocal/AddressLocal/AddressLocalEvent.dart';
import 'package:oder_food/page/detailDish/presentation/view/DishDetail.dart';
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
  late ScrollController _scrollController;
  String textAddress='';
  late TabController _tabController;
  final controller = CarouselController();
  final DatabaseReference ref=FirebaseDatabase.instance.ref();
  @override
  void initState() {
    super.initState();
    _tabController=TabController(length: 3, vsync:this);
    _scrollController=ScrollController();
    final  getListDishBloc= BlocProvider.of<GetListDishBloc>(context);
    final  addressLocal=BlocProvider.of<AddressLocalBloc>(context);
    addressLocal.add(IsGranted());
    getListDishBloc.add(GetDishList());
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
      return Scaffold(
          body:SingleChildScrollView(
            child: Column(
              children: [
                _customAddressOder(),
                SizedBox(
                  child: BlocBuilder<GetListDishBloc,GetListDishState>(
                  builder:(context,state) {
                    if (state is GetListDishInit) {
                      return SizedBox(width:double.infinity,height:650,child: SkeletonListView());
                    }
                    else if (state is GetListDishLoading) {
                      return SizedBox(width:double.infinity,height: 650,child: SkeletonListView());
                    }
                    else if (state is GetListDishListFood) {
                      dishList = state.foodList;
                      return Column(
                        children: [
                          _customSliderImage(state.foodList),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 10)
                                ,
                                child: const Text(
                                  "Gợi ý món ăn ", style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.orange,
                                ),),
                              )
                            ],
                          ),
                          _customOptionDish(),
                          const SizedBox(
                            height: 10,
                          ),
                          _customListDish(state.foodList)
                        ],
                      );
                    }
                    else {
                      return Container();
                    }
                  }
                    ),
                )
                  ]
            ),
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
    Widget buildImages(String urlimage, int index,double sale) => Stack(children:
    [
      Image.network(urlimage, fit: BoxFit.cover,width:double.infinity,height: double.infinity,errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Image.asset('assets/imgdefault.png',fit:BoxFit.cover,width:double.infinity,height: double.infinity);
      }),
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: FittedBox(
            child: AnimatedContainer(
              padding: const EdgeInsets.all(4),
              color: Colors.orangeAccent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              child: Text('Giảm giá ${(sale*100).toInt().toString()}% ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white
              ),),
            ),
          ),
        ),
      )
    ],);
    Widget items(Dish item) =>
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) =>  DishDetail(item)));
          },
          child: SizedBox(
            height: 500,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 250,
                      child:Stack(
                        children: [
                          ClipRRect(
                               borderRadius: BorderRadius.circular(10.0),
                               child: Image.network(item.urlImageDish, fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return Image.asset('assets/imgdefault.png',fit:BoxFit.cover,width:double.infinity,height: double.infinity);
                                  }
                              ),
                          ),
                       Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: FittedBox(
                              child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                color: Colors.orangeAccent,
                                child: Text(
                                  'Giảm giá ${(item.sale*100).toInt().toString()}% ',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                       )
                        ],
                      ),
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

   Widget _customAddressOder()=>BlocBuilder<AddressLocalBloc,String>(builder:(context,state)
     {
       if(state is IsGranted)
         {
           return Visibility(visible: true, child:Column(
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
                     }, icon:const Icon(Icons.clear,color: Colors.grey,)),
                   )
                 ],
               ),
             ],
           )
           );
         }
       else
         {
           return Visibility(visible:false,child:Container(),);
         }
     });

   Widget _customSliderImage(List<Dish> dish)=> SizedBox(
     width: double.infinity,
     child: Column(
       children: [
         CarouselSlider.builder(carouselController: controller,
             itemCount: 6,
             itemBuilder: (context, index, realIndex) {
               String urlImage;
               double sale=dish[index].sale;
               dish.isEmpty ? urlImage = '' : urlImage =
                   dish[index].urlImageDish;
               return buildImages(urlImage, index,sale);
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



