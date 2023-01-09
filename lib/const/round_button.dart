import 'package:bolg_app/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  double sizeOfText;

  RoundButton({Key? key, required this.title, required this.onPressed,this.sizeOfText = 38})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: roundButtonColor,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: roundButtonBorderColor,width: 2),
        ),
        child: Center(
            child: Text(
          title,
          style: GoogleFonts.playfairDisplay(
            color: roundButtonTextColor,
            fontSize: sizeOfText,
            fontWeight: FontWeight.bold,
          )
        )),
      ),
    );
  }
}
