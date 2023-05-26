class Notification{
   final  String  notication_Message;
   final String   uid;
   Notification({required this.notication_Message,required this.uid});
   Map<String, dynamic> toJson()
   {
     return {
      'Notification_Messge':notication_Message,
       'Uid':uid
     };
   }
   factory Notification.fromSnapshot(Map<String , dynamic> value)
   {
     return Notification(notication_Message: value['Notification_Messge'], uid:value['Uid']);
   }
}