import 'dart:ui';

class ColorStyles {
  ColorStyles._();

  static const Color primaryBlue = Color(0xff236be9);
  static const Color primaryDark = Color(0xffCD5A64);
  static const Color offWhite = Color(0xfff8f8f9);
  static const Color errorRed = Color(0xffb00020);
  static const Color gold1 = Color(0xffac8131);
  static const Color gold2 = Color(0xfff6cb92);
  static const Color silver2 = Color(0xff8e8e8e);
  static const Color silver1 = Color(0xff505050);
  static const Color bronze1 = Color(0xff9f5c3c);
  static const Color paleLilac = Color(0xffe9e9ea);
  static const Color slateGrey = Color(0xff60616c);
  static const Color cloudyBlue = Color(0xffbdbdc2);
  static const Color charcoalGrey = Color(0xff393b49);
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color pine = Color(0xff1f5822);
  static const Color accentSeaGreen = Color(0xffb4e2df);
  static const Color pale = Color(0xfffde5db);
  static const Color accentSand = Color(0xfff4ebe1);
  static const Color veryLightBrown = Color(0xffd4b18a);
  static const Color shadow = Color(0x80393b49);
  static const Color transparent = Color(0x00000000);
  static const Color divider = Color(0xfff2f2f2);
  static const Color progressBar = Color(0xFFd8d8d8);
  static const Color link = Color(0xff076dee);
  static const Color skeletonLoadingGradientEnd = Color(0x0cffffff);
  static const Color skeletonLoadingGradientStart = Color(0x0c000000);
  static const Color skeletonLoadingDefaultGradientStart = Color(0xFFF4F4F4);
  static const Color black15 = Color(0x26000000);
  static const Color redOverdue = Color(0xffc13246);

  static Color inputBorderColor({bool hasFocus, bool hasError}) {
    if (hasError) {
      return ColorStyles.errorRed;
    }

    if (hasFocus) {
      return ColorStyles.primaryBlue;
    }

    return ColorStyles.paleLilac;
  }

  // new colors
  static const Color chestNutRose = Color(0xffc85962);
  static const Color vividTangerine = Color(0xffff8d86);
  static const Color bitterSweet = Color(0xffff7068);
  static const Color dustyGray = Color(0xff979797);
  static const Color grayNurse = Color(0xffe3e5e3);
  static const Color redOrange = Color(0xffff3339);
  static const Color boulder = Color(0xff757575);
  static const Color alabaster = Color(0xfff9f9f9);

  static const Color robRoy = Color(0xffebc976);
  static const Color tradeWind = Color(0xff5cacb2);
  static const Color overlayBottom = Color(0xfff9f9f9);
  static const Color roseBud = Color(0xfffdb699);
  static const Color rawSienna = Color(0xffd78d4a);
  static const Color ghost = Color(0xffcac9d6);
  static const Color silverChalice = Color(0xff9d9d9d);
  static const Color fuzzyWuzzyBrown = Color(0xffc65862);
  static const Color sunglo = Color(0xffE56365);
  static const Color concrete = Color(0xffF2F2F2);
  static const Color resolutionBlue = Color(0xff032C83);
  static const Color easternBlue = Color(0xff17999E);
  static const Color geraldine = Color(0xffFC7E78);
  static const Color shamrock = Color(0xff37CB77);

  //zeplin colors
  static const Color salmon = Color(0xfffd7f76);

  //voucher colors

  static const Color piper = Color(0xffBF6421);
  static const Color jakarta = Color(0xff392F6C);
  static const Color blueStone = Color(0xff005F71);
  static const Color eminence = Color(0xff57266A);
  static const Color shark = Color(0xff2E2E2F);
  static const Color selectiveYellow = Color(0xffFFB100);
  static const Color silver = Color(0xffBABABA);
  static const Color apple = Color(0xff40B12B);
  static const Color pictonBlue = Color(0xff2F8FEF);
  static const Color manatee = Color(0xff979DA3);
  static const Color manatee50 = Color(0x80979DA3);
  static const Color wildSand = Color(0xFFF4F4F4);
  static const Color froly = Color(0xffF87B73);
}
