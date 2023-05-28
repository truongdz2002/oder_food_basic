
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oder_food/bloc/ProcessingPageHome/ProcessingAdressLocal/AddressLocal/AddressLocalEvent.dart';

import '../../../../page/home/requestpermission/RequestpermissionAddress.dart';

class AddressLocalBloc extends Bloc<AddressLocalEvent,String>
{
  AddressLocalBloc():super('')
  {
    on<IsGranted>((event, emit) => _isGrantes(emit));
  }
  _isGrantes(Emitter<String> emit) async {
    RequestpermissionAddress requestpermissionAddress=RequestpermissionAddress();
    String address =await requestpermissionAddress.requestPermissionLocal();
    emit(address);
  }
}

