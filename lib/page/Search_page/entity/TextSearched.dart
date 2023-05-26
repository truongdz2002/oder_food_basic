class TextSearched
{
  final String Id;
  final String uid;
  final String textSearched;

  TextSearched({required this.Id, required this.uid, required this.textSearched});
  Map<String,dynamic> ToJson()
  {
    return
      {
        'Id':this.Id,
        'Uid':this.uid,
        'TextSearched':this.textSearched
      };
  }
  factory TextSearched.FromSnapshot(Map<dynamic,dynamic> value)
  {
    return TextSearched(Id: value['Id'],uid: value['Uid'], textSearched: value['TextSearched']);
  }
}