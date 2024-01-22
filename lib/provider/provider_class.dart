import 'package:flutter/material.dart';

class ProviderClass extends ChangeNotifier {
  List namaz = [false, false, false, false, false];
  bool isUpdated = false;
  List sabaqType = [];
  bool? notifyAdmin = false;

  updateList({required int num, required bool val}) {
    namaz[num] = val;
    notifyListeners();
  }

  updateSabaq({required int num,}) {
    if (sabaqType.contains(num)) {
      int index = sabaqType.indexOf(num);
      sabaqType[index] = num;
    } else {
      sabaqType.add(num);
    }
    notifyListeners();
  }

  removeSabaq({required int num,}) {
    sabaqType.remove(num);
    notifyListeners();
  }

  updateCompleteList({required List list}) {
    namaz = list;
    isUpdated = true;
  }
  updateSabaqList({required List list}){
    sabaqType=list;
    isUpdated = true;
  }

  updateNotify({required bool val}) {
    notifyAdmin = val;
    notifyListeners();
  }

  // updateSabaqType({required int val}) {
  //   sabaqType = val;
  //   notifyListeners();
  // }
}
