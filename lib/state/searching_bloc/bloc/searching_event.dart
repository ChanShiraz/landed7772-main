part of 'searching_bloc.dart';

@immutable
abstract class SearchingEvents {}

@immutable
class SearchingEvent extends SearchingEvents {
  List<String>? propertyTypesList;
  List<String>? noOfBedRoomsList;
  List<String>? forSaleList;
  List<String>? districtList;
  List<String>? conditionList;
  int? startPrice;
  int? endPrice;
  SearchingEvent(
      {this.propertyTypesList,
      this.noOfBedRoomsList,
      this.forSaleList,
      this.startPrice,
      this.conditionList,
      this.endPrice,
      this.districtList
      });
}

class SearchingLoadingEvent extends SearchingEvents {}

class SearchingEmptyEvent extends SearchingEvents {}
