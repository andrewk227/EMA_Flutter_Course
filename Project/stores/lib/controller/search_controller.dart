import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class SearchPageController extends GetxController {
  static SearchPageController get instance => Get.find();

  final searchResult = BehaviorSubject<String>();
  Stream<String> get searchResult$ => searchResult.stream;
  Function(String) get setSearchResult => searchResult.sink.add;

  void dispose() {
    searchResult.close();
  }
}
