import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController search_controller = TextEditingController();
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextField(
              controller: search_controller,
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: "search items",
                prefixIcon: Icon(Icons.search),
                // suffixIcon: IconButton(
                //   icon: Icon(Icons.clear),
                //   onPressed: () {},
                // ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          SizedBox(
            height: 1.sh - 130.h,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(15.h),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ClipRRect(
                          //   borderRadius:
                          //       BorderRadius.vertical(top: Radius.circular(12)),
                          //   child: Image.network(
                          //     "",
                          //     height: 150,
                          //     width: double.infinity,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Apple iPhone",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                RatingBarIndicator(
                                  rating: 4,
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: Colors.amber),
                                  itemCount: 5,
                                  itemSize: 18,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "150000",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
