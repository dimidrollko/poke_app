import 'package:flutter/material.dart';

class Gaps {
  static const shrink = SizedBox.shrink();
  static const spacer = Spacer();

  static const w2 = SizedBox(width: 2);
  static const w4 = SizedBox(width: 4);
  static const w8 = SizedBox(width: 8);
  static const w12 = SizedBox(width: 12);
  static const w16 = SizedBox(width: 16);
  static const w24 = SizedBox(width: 24);
  static const w32 = SizedBox(width: 32);
  static const w64 = SizedBox(width: 64);

  static const h2 = SizedBox(height: 2);
  static const h4 = SizedBox(height: 4);
  static const h8 = SizedBox(height: 8);
  static const h12 = SizedBox(height: 12);
  static const h16 = SizedBox(height: 16);
  static const h24 = SizedBox(height: 24);
  static const h32 = SizedBox(height: 32);
  static const h64 = SizedBox(height: 64);
}

class Edges {
  static const contentLarge = EdgeInsets.symmetric(horizontal: 32, vertical: 8);
  static const contentMedium = EdgeInsets.all(16);
  static const contentDense = EdgeInsets.all(12);
  static const btn = EdgeInsets.all(14);
}

class Decorations {
  static final smBorderRadius = BorderRadius.circular(4);
  static final mdBorderRadius = BorderRadius.circular(8);
  static final lgBorderRadius = BorderRadius.circular(16);
}

class Styles {
  static final mediumOutlinedBorder = RoundedRectangleBorder(
    borderRadius: Decorations.mdBorderRadius,
  );

  static final largeOutlinedBorder = RoundedRectangleBorder(
    borderRadius: Decorations.lgBorderRadius,
  );
}
