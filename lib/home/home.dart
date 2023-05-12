import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:oder_food/Dish/DishDetail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Dish/Dish.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin{
   int activeIndex = 0;
   bool _isLoading=true;
  List<Dish> dishList=[];
  late ScrollController _scrollController;
  String textAddress='';
  bool _visibity=false;
  late TabController _tabController;
  final controller = CarouselController();
  final DatabaseReference ref=FirebaseDatabase.instance.ref();
   List<String> priorityList = ['food', 'drink', 'dessert'];
  @override
  void initState() {
    super.initState();
    _tabController=TabController(length: 3, vsync:this);
    _scrollController=ScrollController();
    getDataDishRealTimeDataBase();
    requestPermissionLocal();
    //getDataDishApi();
    _scrollController.addListener(_handleScroll);
    if (dishList.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _isLoading = false;
        });
      });
    }

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
          body: Container(
              child: _isLoading
                  ? Skeleton(
                isLoading: true,
                skeleton: SkeletonListView(),
                child: Container(),
              ) :
              SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(visible: _visibity, child:Column(
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
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          CarouselSlider.builder(carouselController: controller,
                              itemCount: 6,
                              itemBuilder: (context, index, realIndex) {
                                String urlImage;
                                dishList.isEmpty ? urlImage = '' : urlImage =
                                    dishList[index].urlImageDish;
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
                    ),
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
                    TabBar(onTap:(_)=> scrollToSelectedType(),controller:_tabController,isScrollable: true,tabs: const [
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
                    ],),
                    const SizedBox(
                      height:10,
                    ),

                    SizedBox(
                        width: double.infinity, height: 500,
                        child: GridView(
                          controller: _scrollController,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2
                          ),
                          children: dishList.map((item) {
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
    Future<void> requestPermissionLocal() async {
      PermissionStatus status = await Permission.location.request();
      if (status.isGranted) {
        getCurrentAddress();
      }
      else {

      }
    }
   void getCurrentAddress() async {
     // Lấy vị trí hiện tại của thiết bị
     Position position = await Geolocator.getCurrentPosition(
       desiredAccuracy: LocationAccuracy.high,
     );

     // Lấy danh sách các địa điểm dựa trên vị trí đã lấy được
     List<Placemark> placemarks = await placemarkFromCoordinates(
       position.latitude,
       position.longitude,
     );

     // Lấy thông tin chi tiết địa điểm đầu tiên từ danh sách
     Placemark placemark = placemarks[0];

     // Xây dựng chuỗi địa chỉ bằng cách kết hợp các thuộc tính của địa điểm
     String address = '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}';


     // Cập nhật trạng thái của widget
     setState(() {
       // Gán giá trị địa chỉ cho biến textAddress
       textAddress = address;

       // Đặt cờ hiển thị (_visibity) thành true
       _visibity = true;
     });
   }

   void getAddressFromLatLng(double latitude, double longitude) async {
     const apiKey = 'YOUR_API_KEY'; // Thay YOUR_API_KEY bằng khóa API của bạn

     final url = Uri.parse(
         'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey');

     final response = await http.get(url);
     final decodedData = json.decode(response.body);

     if (decodedData['status'] == 'OK') {
       final results = decodedData['results'];
       if (results.isNotEmpty) {
         final firstResult = results[0];
         final formattedAddress = firstResult['formatted_address'];

         final addressComponents = firstResult['address_components'];
         String streetNumber = '';
         String route = '';
         String subLocality = '';
         String locality = '';
         String administrativeAreaLevel2 = '';
         String administrativeAreaLevel1 = '';
         String country = '';

         for (var component in addressComponents) {
           final types = component['types'];
           final longName = component['long_name'];

           if (types.contains('street_number')) {
             streetNumber = longName; // Lấy số nhà
           } else if (types.contains('route')) {
             route = longName; // Lấy tên đường
           } else if (types.contains('sublocality')) {
             subLocality = longName; // Lấy phường/xã
           } else if (types.contains('locality')) {
             locality = longName; // Lấy quận/huyện
           } else if (types.contains('administrative_area_level_2')) {
             administrativeAreaLevel2 = longName; // Lấy tỉnh/thành phố
           } else if (types.contains('administrative_area_level_1')) {
             administrativeAreaLevel1 = longName; // Lấy tỉnh/bang
           } else if (types.contains('country')) {
             country = longName; // Lấy quốc gia
           }
         }
         String address = '${streetNumber}, ${route}, ${subLocality }, ${locality},${ administrativeAreaLevel2},${country}}';
         // Cập nhật trạng thái của widget
         setState(() {
           // Gán giá trị địa chỉ cho biến textAddress
           textAddress = address;

           // Đặt cờ hiển thị (_visibity) thành true
           _visibity = true;
         });
       }
     }
   }
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

   Future<void> getDataDishRealTimeDataBase() async {
     List<Dish> dishes = [];
     ref
         .child('dishes')
         .onValue
         .listen((event) {
       List<Object?> a = event.snapshot.value as List<Object?>;
       List<Object> nonNullableList = a
           .where((element) => element != null)
           .toList()
           .cast<Object>();
       for (var element in nonNullableList) {
         Map<String, dynamic> map = Map.from(element as dynamic);
         dishes.add(Dish.fromSnapshot(map));
         dishList = dishes;
         dishList.sort((a, b) {
           {
             final priorityA = priorityList.indexOf(a.type);
             final priorityB = priorityList.indexOf(b.type);
             return priorityA.compareTo(priorityB);
           }
         });
       }
     });
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
   Future<void> getDataDishApi()
   async {
     final response= await http.get(Uri.parse('https://appbansmaytinh.000webhostapp.com/oder_food/apiDish/getDish.php'));
     List<dynamic> dataDish=[];
     if(response.statusCode==200)
     {
       dataDish=jsonDecode(response.body);
     }
     else
     {
       throw Exception('Lỗi khi tải dữ liệu từ API');
     }
     for(var element in dataDish)
     {
       dishList.add(Dish.fromSnapshotApi(element));
     }
     dishList.sort((a, b) {
       {
         final priorityA = priorityList.indexOf(a.type);
         final priorityB = priorityList.indexOf(b.type);
         return priorityA.compareTo(priorityB);
       }
     });
   }
}

