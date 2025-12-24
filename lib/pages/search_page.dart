import 'package:flutter/material.dart';
import 'search_result_page.dart';

class SearchPage extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const SearchPage({
    super.key,
    required this.themeNotifier,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),

                  Expanded(
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Search courses",
                        filled: true,
                        fillColor: const Color(0xFFF1F4F9),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SearchResultPage(keyword: value),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // SEARCH SUGGESTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: [
                  _suggestionChip(context, "Flutter"),
                  _suggestionChip(context, "UI/UX"),
                  _suggestionChip(context, "Web Development"),
                  _suggestionChip(context, "Digital Marketing"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _suggestionChip(BuildContext context, String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchResultPage(keyword: text),
          ),
        );
      },
    );
  }
}
