import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  AppFonts._();

  static TextStyle getFont(String fontName, {TextStyle? base}) {
    print(fontName);
    switch (fontName.toLowerCase()) {
      case 'roboto':
        return GoogleFonts.roboto(textStyle: base);

      case 'open sans':
        return GoogleFonts.openSans(textStyle: base);

      case 'lato':
        return GoogleFonts.lato(textStyle: base);

      case 'montserrat':
        return GoogleFonts.montserrat(textStyle: base);

      case 'poppins':
        return GoogleFonts.poppins(textStyle: base);

      case 'raleway':
        return GoogleFonts.raleway(textStyle: base);

      case 'ubuntu':
        return GoogleFonts.ubuntu(textStyle: base);

      case 'nunito':
        return GoogleFonts.nunito(textStyle: base);

      default:
      // Fallback font
        return GoogleFonts.roboto(textStyle: base);
    }
  }
}

