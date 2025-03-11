import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Reviews extends StatelessWidget {
  const Reviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.black87,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amrut Khochikar",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "29-06-2024",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            RatingBarIndicator(
              rating: 4,
              itemBuilder: (context, index) =>
                  const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 18,
            ),
            SizedBox(height: 10.h),
            Text(
              "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve.",
              style: GoogleFonts.inter(fontSize: 15.sp, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
