import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/extensions/contexExt.dart';
import 'package:layout/screens/login.dart';
import 'package:layout/state/keyboard_bloc/keyboard_bloc.dart';
import 'package:layout/state/searching_bloc/bloc/searching_bloc.dart';
import 'package:layout/utils/keyboard_visibility.dart';

import '../search_result.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
   TextEditingController fromTextController 
     = TextEditingController();
   TextEditingController toTextController = TextEditingController();
  final typesList = [
    'Inter Terrace',
    'Corner Terrace',
    'Semi-Detached',
    'Detached',
    'Strata Landed',
    'GCB'
  ];

  final propertyTypeCheck = List.generate(6, (index) => false);
  final noOfBedList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10+'];
  final districtList = [
    'Central (D9 - D11, D21)',
    'East (D14 - D18)',
    'North (D19,D20,D26 - D28)',
    'West (D5,D22, D23)',
    'Others (D3,D4,D8,D12,D13)'
  ];
  final noOfBedCheck = List.generate(10, (index) => false);
  final forSaleCheck = List.generate(2, (index) => false);
  final districtCheck = List.generate(5, (index) => false);
  final forSaleList = ['Sale', 'Rent'];
  late SearchingBloc searchingBloc;
  late KeyboardBloc keyboardBloc;

  //final lists for checked item to search with
  int? startPrice;
  int? endPrice;
  List<String> propertyTypeChecked = [];
  List<String> bedRoomsChecked = [];
  List<String> forSaleChecked = [];
  List<String> districtChecked = [];

  @override
  Widget build(BuildContext context) {
    searchingBloc = context.read<SearchingBloc>();
    keyboardBloc = context.read<KeyboardBloc>();
    return Scaffold(
      body: InkWell(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: KeyboardVisibilityBuilder(
      
            key: GlobalKey(),
            builder: (BuildContext context, Widget child, bool isKeyboardVisible) {
              if(isKeyboardVisible){
              keyboardBloc.add(KeyboardOpenEvent());
            }
            else{
              keyboardBloc.add(KeyboardCloseEvent());
            }
            return child;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filter listings',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Price Range',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: context.width * 0.45,
                            height: 70,
                            child: MyTextField(
                              controller: fromTextController,
                              prefix: const Text('\$ '),
                              label: 'From',
                              inputType: TextInputType.number,
                              horizontalPadding: 0,
                              onChange: (p0) {},
                              textInputFormatter: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          SizedBox(
                            width: context.width * 0.45,
                            height: 70,
                            child: MyTextField(
                              textInputFormatter: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: toTextController,
                              prefix: const Text('\$ '),
                              label: 'To',
                              inputType: TextInputType.number,
                              horizontalPadding: 0,
                              onChange: (p0) {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Property Type',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CheckBoxs(types: typesList, checkValues: propertyTypeCheck),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'No of Bedrooms',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BedChecks(noOfBeds: noOfBedList, bedCheckValue: noOfBedCheck),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'District',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DistrictChecks(
                          districChecks: districtList,
                          districtCheckValue: districtCheck),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Available for',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ForSaleChecks(
                          forSaleCheck: forSaleList, forSaleCheckValue: forSaleCheck),
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (fromTextController.text.isNotEmpty) {
                                  startPrice = int.parse(fromTextController.text);
                                }
                                if (toTextController.text.isNotEmpty) {
                                  endPrice = int.parse(toTextController.text);
                                }
                                propertyTypeChecked = [];
                                bedRoomsChecked = [];
                                forSaleChecked = [];
                                districtChecked = [];
                                for (var i = 0; i < propertyTypeCheck.length; i++) {
                                  if (propertyTypeCheck[i] == true) {
                                    propertyTypeChecked.add(typesList[i]);
                                    //print(typesList[i]);
                                  }
                                }
                                for (var i = 0; i < noOfBedCheck.length; i++) {
                                  if (noOfBedCheck[i] == true) {
                                    bedRoomsChecked.add(noOfBedList[i]);
                                  }
                                }
                                for (var i = 0; i < forSaleCheck.length; i++) {
                                  if (forSaleCheck[i] == true) {
                                    forSaleChecked.add(forSaleList[i]);
                                  }
                                }
                                for (var i = 0; i < districtCheck.length; i++) {
                                  if (districtCheck[i] == true) {
                                    if (i == 0) {
                                      final central = ['D9', 'D10', 'D11', 'D21'];
                                      districtChecked.addAll(central);
                                    }
                                    if (i == 1) {
                                      final east = [
                                        'D14',
                                        'D15',
                                        'D16',
                                        'D17',
                                        'D18',
                                      ];
                                      districtChecked.addAll(east);
                                    }
                                    if (i == 2) {
                                      final north = [
                                        'D19',
                                        'D20',
                                        'D26',
                                        'D26',
                                        'D27',
                                        'D28',
                                      ];
                                      districtChecked.addAll(north);
                                    }
                                    if (i == 3) {
                                      final west = [
                                        'D5',
                                        'D22',
                                        'D23',
                                      ];
                                      districtChecked.addAll(west);
                                    }
                                    if (i == 4) {
                                      final west = [
                                        'D3',
                                        'D4',
                                        'D8',
                                        'D12',
                                        'D13',
                                      ];
                                      districtChecked.addAll(west);
                                    }
                                  }
                                }
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SearchResultPage(),
                                ));
                                searchingBloc.add(SearchingEvent(
                                    propertyTypesList: propertyTypeChecked,
                                    noOfBedRoomsList: bedRoomsChecked,
                                    forSaleList: forSaleChecked,
                                    startPrice: startPrice,
                                    endPrice: endPrice,
                                    districtList: districtChecked));
                              },
                              child: const Text('Filter')),
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: BlocBuilder(bloc: keyboardBloc,builder: ((context, state) {
      //   if(state is KeyboardOpenState){
      //     return FloatingActionButton(onPressed: (){
      //       FocusManager.instance.primaryFocus?.unfocus();
      //     },child: const Center(child: Icon(Icons.done),),);
      //   }
      //   else{
      //     return Container();
      //   }
      // })),
    );
  }
}

//for sale or rent
class DistrictChecks extends StatefulWidget {
  const DistrictChecks(
      {Key? key, required this.districChecks, required this.districtCheckValue})
      : super(key: key);
  final List<String> districChecks;
  final List<bool?> districtCheckValue;

  @override
  _DistrictChecks createState() => _DistrictChecks();
}

class _DistrictChecks extends State<DistrictChecks> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 15,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: widget.districChecks.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Checkbox(
              value: widget.districtCheckValue[index],
              onChanged: (value) {
                setState(() {
                  widget.districtCheckValue[index] = value;
                });
              },
            ),
            Text(widget.districChecks[index]),
            const SizedBox(width: 10),
          ],
        );
      },
    );
  }
}

//for sale or rent
class ForSaleChecks extends StatefulWidget {
  const ForSaleChecks(
      {Key? key, required this.forSaleCheck, required this.forSaleCheckValue})
      : super(key: key);
  final List<String> forSaleCheck;
  final List<bool?> forSaleCheckValue;

  @override
  _ForSaleChecks createState() => _ForSaleChecks();
}

class _ForSaleChecks extends State<ForSaleChecks> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 4.5,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: widget.forSaleCheck.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Checkbox(
              value: widget.forSaleCheckValue[index],
              onChanged: (value) {
                setState(() {
                  widget.forSaleCheckValue[index] = value;
                });
              },
            ),
            Text(widget.forSaleCheck[index]),
            const SizedBox(width: 10),
          ],
        );
      },
    );
  }
}

//bed checks
class BedChecks extends StatefulWidget {
  const BedChecks(
      {Key? key, required this.noOfBeds, required this.bedCheckValue})
      : super(key: key);
  final List<String> noOfBeds;
  final List<bool?> bedCheckValue;

  @override
  _BedChecks createState() => _BedChecks();
}

class _BedChecks extends State<BedChecks> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 4.5,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: widget.noOfBeds.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Checkbox(
              value: widget.bedCheckValue[index],
              onChanged: (value) {
                setState(() {
                  widget.bedCheckValue[index] = value;
                });
              },
            ),
            Text(widget.noOfBeds[index]),
            const SizedBox(width: 10),
          ],
        );
      },
    );
  }
}

//check boxes widget
class CheckBoxs extends StatefulWidget {
  const CheckBoxs({Key? key, required this.types, required this.checkValues})
      : super(key: key);
  final List<String> types;
  final List<bool?> checkValues;

  @override
  _CheckBoxsState createState() => _CheckBoxsState();
}

class _CheckBoxsState extends State<CheckBoxs> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5.5,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: widget.types.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Checkbox(
              value: widget.checkValues[index],
              onChanged: (value) {
                setState(() {
                  widget.checkValues[index] = value;
                });
              },
            ),
            Text(widget.types[index]),
            const SizedBox(width: 10),
          ],
        );
      },
    );
  }
}
