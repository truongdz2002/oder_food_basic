import 'package:flutter/material.dart';
import 'package:oder_food/ModuleBillOderFood.dart';
import 'package:intl/intl.dart';
class BillOderFood extends StatelessWidget {
    final ModuleBillOderFood moduleBillOderFood;
   const BillOderFood({Key? key, required this.moduleBillOderFood}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,backgroundColor: Colors.orange,
        title: const Text('Hóa đơn đặt hàng',style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
        ),
      ),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          alignment: Alignment.center,
          height: 550,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange,width: 4)
          ),
          child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.all(15),
                  child: SizedBox(
                    height: 100,
                    child: FittedBox(
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/logo_oder_food.png'
                        ),
                      ),
                    ),
                  )
              )
              ,Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('Mã đơn hàng :',style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                    ),
                  ),
                  Text(moduleBillOderFood.id,style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  ),
                ],
              ),
                Row(
                  children: [
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('Họ và tên        :',style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                          ),
                  ),
                  Text(moduleBillOderFood.infor_oder.NameUser,style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                        ),
                  ],
                  ),
                   Row(
                  children: [
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('Số điện thoại :',style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                          ),
                  ),
                  Text(moduleBillOderFood.infor_oder.TelephoneDelevery,style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                        ),
                  ],
                  ),
               Row(
                   children: [
                   const Padding(
                     padding: EdgeInsets.all(15.0),
                     child: Text('Địa chỉ            :',style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                            ),
                   ),
                    Text(moduleBillOderFood.infor_oder.AddressDelevery,style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                          ),
                   ],
                      ),


                       Row(
                      children: [
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text('Thực đơn      :',style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                              ),
                      ),
                      Text(moduleBillOderFood.moduleCart.dish.nameDish,style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                            ),
                      ],
                            ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                      children: [
                            const Text('Ngày đặt hàng : ',style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                                ),
                            Text(moduleBillOderFood.dateOder,style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                                ),
                            ],
                      ),
                    ),
                     Container(
                       width: 300,
                     decoration: const BoxDecoration(
                       border: Border(bottom: BorderSide(color: Colors.orange,width: 2))
                     ),
                     ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                        children: [
                        const Text('Phương thức thanh toán:',style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                          ),
                        Text(moduleBillOderFood.methodsPayment,style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                          ),
                          ],
                          ),
                      ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                          children: [
                          const Text('Tổng tiền:',style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                          ),
                          Text('${NumberFormat.decimalPattern().format(moduleBillOderFood.totalPayment).toString()} VND',style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                          ),
                          ],
                          ),
                        )

            ],
          ),
        ),
      ),
    );
  }
}
