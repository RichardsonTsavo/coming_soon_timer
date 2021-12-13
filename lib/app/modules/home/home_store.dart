class HomeStore {
  DateTime dateTime = DateTime.now();
  List<int> days = [];
  List<int> hours = List.generate(23, (index) => index+1);
  List<int> minutes = List.generate(59, (index) => index+1);
  List<int> seconds = List.generate(59, (index) => index+1);


  void setList(){
    int difference = DateTime(DateTime.now().year+1,1,1,1,0,0).difference(DateTime.now()).inDays;
    days = List.generate(difference, (index) => index);

    List<int> data = [];
    data.addAll(seconds);
    seconds.clear();
    seconds.addAll(data.reversed);
    data.clear();
    data.addAll(minutes);
    minutes.clear();
    minutes.addAll(data.reversed);
    data.clear();
    data.addAll(hours);
    hours.clear();
    hours.addAll(data.reversed);
    data.clear();
    data.addAll(days);
    days.clear();
    days.addAll(data.reversed);
  }


  int getCurrentIndex ({required int list}){
    int value = 0;
    switch(list){
      case 1:
        for(int i = 0; i < hours.length;i++){
          if(hours[i] == (24 - DateTime.now().hour)){
            value = i;
          }
        }
        return value;
      case 2:
        for(int i = 0; i < minutes.length;i++){
          if(minutes[i] == (60 - DateTime.now().minute)){
            value = i;
          }
        }
        return value;
      case 3:
        for(int i = 0; i < seconds.length;i++){
          if(seconds[i] == (60 - DateTime.now().second)){
            value = i;
          }
        }
        return value;
      default:
        return value;
    }
  }
}