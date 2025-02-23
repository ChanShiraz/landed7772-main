import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/screens/listing_details.dart';
import 'package:layout/features/home/view/home_page.dart';
import 'package:layout/state/searching_bloc/bloc/searching_bloc.dart';

class SearchResultPage extends StatelessWidget {
  SearchResultPage({super.key});
  late SearchingBloc searchingBloc;
  @override
  Widget build(BuildContext context) {
    searchingBloc = context.read<SearchingBloc>();
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Landed7772',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              'Result Found',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
          ),
          BlocBuilder(
            bloc: searchingBloc,
            builder: (context, state) {
              if (state is SearchingLoadingState) {
                return const SearchLoadinWidget();
              } else if (state is SearchingLoadedState) {
                return Expanded(
                    child: ListView.builder(
                  itemCount: state.listings.length,
                  itemBuilder: (context, index) {
                    return ListingWidget(
                      listing: state.listings[index],
                      showBadge: false,
                      onClick: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListingDetailsScreen(
                            listing: state.listings[index]),
                      )),
                    );
                  },
                ));
              } else if (state is SearchingEmptyState) {
                return const Center(
                  child: Text(
                    'No Match Found!',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54),
                  ),
                );
              } else {
                return const Text('Maybe some error');
              }
            },
          ),
        ],
      ),
    ));
  }
}

//loading widget
class SearchLoadinWidget extends StatelessWidget {
  const SearchLoadinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        child: Column(
      children: [
        ShimmerLoading(),
        ShimmerLoading(),
        ShimmerLoading(),
        ShimmerLoading(),
      ],
    ));
  }
}
