import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_hub/data/data.dart';
import 'package:wallpaper_hub/view/image_view.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var searchController = TextEditingController();
  var showSearchResult = false;
  var gridController = ScrollController();
  var hits = [];
  int page = 0;

  @override
  void initState() {
    gridController.addListener(scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(20), right: Radius.circular(20)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      blurRadius: 5,
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  style: GoogleFonts.sarabun(),
                  cursorColor: Colors.black,
                  autofocus: true,
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    focusColor: Colors.black,
                    border: InputBorder.none,
                    hintText: 'Search',
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      showSearchResult = true;
                    });
                    saveSuggestions(value);
                    resetSearch();
                    loadSearchImages(value);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: (showSearchResult) ? imagesGridList() : suggestionsWidget(),
          )
        ],
      ),
    );
  }

  suggestionsWidget() {
    return FutureBuilder(
      future: getSuggestions(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (!snapshot.hasData) return Container();
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.restore),
              title: Text(snapshot.data[index]),
              onTap: () {
                searchController.text = snapshot.data[index];
                setState(() {
                  showSearchResult = true;
                });
                saveSuggestions(snapshot.data[index]);
                resetSearch();
                loadSearchImages(snapshot.data[index]);
              },
            );
          },
        );
      },
    );
  }

  imagesGridList() {
    return (hits.length > 0)
        ? GridView.builder(
            controller: gridController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 6.0,
              crossAxisSpacing: 6.0,
            ),
            itemCount: hits.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageView(model: hits[index]),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(4, 6),
                            blurRadius: 3,
                          ),
                        ],
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: NetworkImage(
                            hits[index].webformatURL,
                          ),
                        ),
                      ),
                    )
                    // child: Image.network(
                    //   hits[index].webformatURL,
                    //   fit: BoxFit.fill,
                    // ),
                    ),
              );
            })
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  resetSearch() {
    hits.clear();
    page = 0;
  }

  loadSearchImages(String query) async {
    var model = await Data().getSearchedImages(query, ++page);
    hits.addAll(model.hits);
    setState(() {});
  }

  scrollListener() {
    if (gridController.offset >= gridController.position.maxScrollExtent &&
        !gridController.position.outOfRange) {
      loadSearchImages(searchController.text);
    }
  }

  Future<List<String>> getSuggestions() async {
    var prefs = await SharedPreferences.getInstance();
    List<String> suggestions = prefs.getStringList('suggestions_list') ?? [];
    return suggestions;
  }

  saveSuggestions(String value) async {
    var prefs = await SharedPreferences.getInstance();
    List<String> suggestions = prefs.getStringList('suggestions_list') ?? [];
    if (!suggestions.contains(value)) {
      suggestions.insert(0, value);
    } else {
      var existingIndex = suggestions.indexOf(value);
      suggestions.removeAt(existingIndex);
      suggestions.insert(0, value);
    }
    if (suggestions.length > 5) {
      suggestions.removeLast();
    }
    prefs.setStringList('suggestions_list', suggestions);
  }
}
