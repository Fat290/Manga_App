import 'package:doan_cs3/bloc/manga/manga_bloc.dart';
import 'package:doan_cs3/bloc/search_manga/search_manga_bloc.dart';
import 'package:doan_cs3/pages/components/manga_category.dart';
import 'package:doan_cs3/pages/components/my_textformfield.dart';
import 'package:doan_cs3/pages/components/search_results.dart';
import 'package:doan_cs3/pages/explore_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List previousSearch = [];
  FocusNode focusNode = FocusNode();
  bool isFocused = false;
  bool showSearchResults = false;
  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
    @override
    void dispose() {
      focusNode.dispose();
      super.dispose();
    }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Column(
            children: [
              Container(

                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 20, right: 20, bottom: 10),

                  child: Row(
                    children: [
                      Expanded(
                        child: MyTextFormField(
                          hint: "Search...",
                          prefixIcon: IconlyLight.search,
                          filled: true,
                          controller: searchController,
                          suffixIcon: searchController.text.isEmpty
                              ? null
                              : Icons.cancel_sharp,
                          onTapSuffixIcon: () {
                            searchController.clear();
                            setState(() {
                              searchController.text = "";
                              showSearchResults=false;
                            });
                          },
                          onChanged: (pure) {
                            setState(() {});
                          },
                          onEditingComplete: () {
                            setState(() {
                              previousSearch.add(searchController.text);
                              showSearchResults = true;
                            });
                            FocusScope.of(context).unfocus();
                            context.read<SearchMangaBloc>().add(SearchManga(searchController.text));
                          },
                          focusNode: focusNode,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        child: const Icon(IconlyBold.filter),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: previousSearch.isEmpty
                            ? null
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Recent Searches",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          GestureDetector(
                                            child: Text(
                                              "Delete All",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary
                                                      .withOpacity(0.6)),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                previousSearch.removeRange(
                                                    0, previousSearch.length);
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: previousSearch.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withOpacity(0.6)),
                                                borderRadius: BorderRadius.circular(16)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    child: Text(
                                                      previousSearch[index],
                                                      style:
                                                          const TextStyle(fontSize: 12),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        searchController.text =
                                                            previousSearch[index];
                                                        FocusScope.of(context).requestFocus(focusNode);
                                                      });

                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  GestureDetector(
                                                    child: const Icon(
                                                      Icons.cancel_sharp,
                                                      size: 12,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        previousSearch.removeAt(index);
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const MangaCategory()
                    ],
                  ),
                ),
              ),
            ],
          ),
           if(showSearchResults)
              Positioned(
                left: 0,
                right: 0,
                top: 120,
                child: Container(
                    child: SearchResults(),
                    height: MediaQuery.of(context).size.height+120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background
                  ),
                ),
              )
         ]
        ),
      ),
    );
  }
}
