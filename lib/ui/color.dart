import 'dart:ui';
import 'package:flutter/material.dart';

/// ============================================================================
/// BASE & BRAND COLORS (Fresh Organic Minimalist Palette)
/// ============================================================================

/// Brand Primary (Botanical Fresh Leaf Green)
const Color primaryColor = Color(0xFF04883B);
const Color primaryColor50 = Color(0xFFEAF6EE);
const Color primaryColor100 = Color(0xFFD4ECD9);
const Color primaryColor200 = Color(0xFFA9DCB6);
const Color primaryColor300 = Color(0xFF78C78F);
const Color primaryColor400 = Color(0xFF45B06B);
const Color primaryColor500 = Color(0xFF04883B);
const Color primaryColor600 = Color(0xFF037432);
const Color primaryColor700 = Color(0xFF03692E);
const Color primaryColor800 = Color(0xFF025224);
const Color primaryColor900 = Color(0xFF013B1A);

/// Brand Secondary (Warm Carrot / Citrus Orange Accent)
const Color secondaryColor = Color(0xFFFF9F29);
const Color secondaryColor50 = Color(0xFFFFF7ED);
const Color secondaryColor100 = Color(0xFFFFEDD5);
const Color secondaryColor200 = Color(0xFFFED7AA);
const Color secondaryColor300 = Color(0xFFFDBA74);
const Color secondaryColor400 = Color(0xFFFB923C);
const Color secondaryColor500 = Color(0xFFFF9F29);
const Color secondaryColor600 = Color(0xFFEA580C);
const Color secondaryColor700 = Color(0xFFC2410C);

/// System Status Colors
const Color errorColor = Color(0xFFEF4444);
const Color successColor = Color(0xFF04883B);
const Color warningColor = Color(0xFFF59E0B);
const Color infoColor = Color(0xFF3B82F6);

/// Shimmer & Utility
const Color shimmerColor = Color(0xFFE2E8F0);
const Color shimmerHighlightColor = Color(0xFFFFFFFF);
const Color transparentColor = Color(0x00FFFFFF);

/// ============================================================================
/// PASTEL PALETTE (Matching Reference: Category Tiles & Feature Badges)
/// ============================================================================
const Color pastelMint = Color(0xFFEAF6EE);    // Sayuran Daun / Salad / Leaf icon
const Color pastelOrange = Color(0xFFFFF3E6);  // Sayuran Buah / Citrus / Carrot
const Color pastelYellow = Color(0xFFFEF9E7);  // Sayuran Umbi / Banana / Corn
const Color pastelPurple = Color(0xFFF3E8FF);  // Grapes / Eggplant / Terong
const Color pastelRed = Color(0xFFFEECEB);     // Tomato / Apple / Strawberry
const Color pastelBlue = Color(0xFFE0F2FE);    // Delivery / Hydration / Info

/// App Organic Backgrounds
const Color bgApp = Color(0xFFF8FAF8);         // Fresh organic off-white background
const Color bgCard = Color(0xFFFFFFFF);        // Pure white card surface
const Color bgSearch = Color(0xFFF4F5F7);      // Squircle search bar background
const Color bgInput = Color(0xFFF8FAF8);       // Form field background

/// ============================================================================
/// NEUTRALS & SCALES
/// ============================================================================

// Black / Gray Scale (Slate & Neutral)
const Color black00 = Color(0xFFFFFFFF);
const Color black50 = Color(0xFFFAFAFA);
const Color black100 = Color(0xFFF4F4F5);
const Color black200 = Color(0xFFE4E4E7);
const Color black300 = Color(0xFFD4D4D8);
const Color black400 = Color(0xFFA1A1AA);
const Color black500 = Color(0xFF71717A);
const Color black600 = Color(0xFF52525B);
const Color black700 = Color(0xFF3F3F46);
const Color black700_20 = Color(0x333F3F46); // 20% opacity
const Color black800 = Color(0xFF27272A);
const Color black900 = Color(0xFF18181B);
const Color black950 = Color(0xFF09090B);
const Color black950_80 = Color(0xCC09090B); // 80% opacity

// Navy
const Color navy50 = Color(0xFFE4E9F2);
const Color navy100 = Color(0xFFCCD6E6);
const Color navy200 = Color(0xFFAABBD6);
const Color navy200_20 = Color(0x33AABBD6);
const Color navy300 = Color(0xFF8099C2);
const Color navy400 = Color(0xFF2462B7);
const Color navy500 = Color(0xFF2A5499);
const Color navy500_20 = Color(0x332A5499);
const Color navy600 = Color(0xFF003284);
const Color navy700 = Color(0xFF002A6E);
const Color navy800 = Color(0xFF002158);
const Color navy900 = Color(0xFF001942);

// Orange
const Color orange50 = Color(0xFFFFF5ED);
const Color orange100 = Color(0xFFFFE8D4);
const Color orange200 = Color(0xFFFFCCDA);
const Color orange200_20 = Color(0x33FFCCDA);
const Color orange300 = Color(0xFFFFAA72);
const Color orange400 = Color(0xFFFFE7F3);
const Color orange500 = Color(0xFFFD5812);
const Color orange500_20 = Color(0x33FD5812);
const Color orange600 = Color(0xFFED3E09);
const Color orange700 = Color(0xFFC52B09);
const Color orange800 = Color(0xFF9C2310);
const Color orange900 = Color(0xFF7E2010);

// Blue
const Color blue50 = Color(0xFFEEFAFF);
const Color blue100 = Color(0xFFD8F3FF);
const Color blue200 = Color(0xFFBAEBFF);
const Color blue200_20 = Color(0x33BAEBFF);
const Color blue300 = Color(0xFF8BE1FF);
const Color blue400 = Color(0xFF55CDFF);
const Color blue500 = Color(0xFF2DB1FF);
const Color blue500_20 = Color(0x332DB1FF);
const Color blue600 = Color(0xFF1794F9);
const Color blue700 = Color(0xFF0F78E0);
const Color blue800 = Color(0xFF1362BA);
const Color blue900 = Color(0xFF165492);

// Green
const Color green50 = Color(0xFFF1FBEA);
const Color green100 = Color(0xFFDEF6D1);
const Color green200 = Color(0xFFC0EEA8);
const Color green200_20 = Color(0x33C0EEA8);
const Color green300 = Color(0xFF97E076);
const Color green400 = Color(0xFF73D04B);
const Color green500 = Color(0xFF04883B);
const Color green500_20 = Color(0x3304883B);
const Color green600 = Color(0xFF037432);
const Color green700 = Color(0xFF03692E);
const Color green800 = Color(0xFF025224);
const Color green900 = Color(0xFF013B1A);

// Yellow
const Color yellow50 = Color(0xFFFEFBE8);
const Color yellow100 = Color(0xFFFFF7C2);
const Color yellow200 = Color(0xFFFEFEB8);
const Color yellow200_20 = Color(0x33FEFEB8);
const Color yellow300 = Color(0xFFFD7440);
const Color yellow400 = Color(0xFFFEC111);
const Color yellow500 = Color(0xFFF4AC04);
const Color yellow500_20 = Color(0x33F4AC04);
const Color yellow600 = Color(0xFFCE7F00);
const Color yellow700 = Color(0xFFA45A04);
const Color yellow800 = Color(0xFF87460C);
const Color yellow900 = Color(0xFF733910);

// Red
const Color red50 = Color(0xFFFEF4F2);
const Color red100 = Color(0xFFFEE6E2);
const Color red200 = Color(0xFFFDD2CB);
const Color red200_20 = Color(0x33FDD2CB);
const Color red300 = Color(0xFFBB33A6);
const Color red400 = Color(0xFFF68673);
const Color red500 = Color(0xFFEC5F47);
const Color red500_20 = Color(0x33EC5F47);
const Color red600 = Color(0xFFD64026);
const Color red700 = Color(0xFFB6351F);
const Color red800 = Color(0xFF972F1D);
const Color red900 = Color(0xFF7D2D1F);

/// ============================================================================
/// SEMANTIC TOKENS (Text, Icon, Background, Border)
/// ============================================================================

// Text
const Color textNeutralPrimary = Color(0xFF1E293B);   // Slate 800 - crisp heading
const Color textDarkPrimary = Color(0xFF1E293B);
const Color textDarkSecondary = Color(0xFF64748B);   // Slate 500 - subtitle
const Color textDarkTertiary = Color(0xFF94A3B8);    // Slate 400 - hints
const Color textLightPrimary = Color(0xFFFFFFFF);
const Color textLightSecondary = Color(0xFFE2E8F0);
const Color textNeutralSecondary = Color(0xFF64748B);
const Color textNeutralTertiary = Color(0xFF94A3B8);
const Color textWhitePrimary = Color(0xFFFFFFFF);
const Color textWhiteSecondary = Color(0xFFE2E8F0);
const Color textDisabled = Color(0xFF94A3B8);

const Color textPrimary = Color(0xFF04883B);         // Fresh botanical green text
const Color textPrimaryPressed = Color(0xFF03692E);
const Color textSecondary = Color(0xFFFF9F29);       // Carrot orange text
const Color textSecondaryPressed = Color(0xFFEA580C);
const Color textDanger = Color(0xFFEF4444);
const Color textPressed = Color(0xFF8C2624);
const Color textSuccess = Color(0xFF04883B);
const Color textSuccessPressed = Color(0xFF03692E);
const Color textWarning = Color(0xFFF59E0B);
const Color textWarningPressed = Color(0xFFD97706);
const Color textInfo = Color(0xFF3B82F6);
const Color textInfoPressed = Color(0xFF2563EB);

const Color textButtonPrimary = Color(0xFFFFFFFF);
const Color textButtonSecondaryDefault = Color(0xFF04883B);
const Color textButtonSecondaryHover = Color(0xFF037432);
const Color textButtonSecondaryPressed = Color(0xFF025224);
const Color textButtonOutlined = Color(0xFF1E293B);
const Color textButtonDanger = Color(0xFFFFFFFF);
const Color textButtonSuccess = Color(0xFFFFFFFF);
const Color textButtonWarning = Color(0xFFFFFFFF);

// Icon
const Color iconNeutralPrimary = Color(0xFF1E293B);
const Color iconDarkPrimary = Color(0xFF1E293B);
const Color iconDarkSecondary = Color(0xFF64748B);
const Color iconDarkTertiary = Color(0xFF94A3B8);
const Color iconLightPrimary = Color(0xFFFFFFFF);
const Color iconLightSecondary = Color(0xFFE2E8F0);
const Color iconLightDisabled = Color(0xFF94A3B8);
const Color iconNeutralSecondary = Color(0xFF64748B);
const Color iconWhite = Color(0xFFFFFFFF);
const Color iconDisabled = Color(0xFFA1A1AA);

const Color iconPrimary = Color(0xFF04883B);
const Color iconPrimaryPressed = Color(0xFF03692E);
const Color iconSecondary = Color(0xFFFF9F29);
const Color iconSecondaryPressed = Color(0xFFEA580C);
const Color iconDanger = Color(0xFFEF4444);
const Color iconDangerPressed = Color(0xFFDC2626);
const Color iconSuccess = Color(0xFF04883B);
const Color iconSuccessPressed = Color(0xFF03692E);
const Color iconWarning = Color(0xFFF59E0B);
const Color iconWarningPressed = Color(0xFFD97706);
const Color iconLoading = Color(0xFFE2E8F0);
const Color iconInfo = Color(0xFF3B82F6);
const Color iconInfoPressed = Color(0xFF2563EB);

const Color iconButtonPrimary = Color(0xFFFFFFFF);
const Color iconTextSecondaryDefault = Color(0xFF04883B);
const Color iconButtonSecondaryHover = Color(0xFF037432);
const Color iconButtonSecondaryPressed = Color(0xFF025224);
const Color iconButtonOutlined = Color(0xFF1E293B);
const Color iconButtonDanger = Color(0xFFFFFFFF);
const Color iconButtonSuccess = Color(0xFFFFFFFF);
const Color iconButtonWarning = Color(0xFFFFFFFF);

// Background
const Color bg = Color(0xFFF8FAF8);
const Color bgLight = Color(0xFFFFFFFF);
const Color bgDark = Color(0xFF0F172A);
const Color bgSurfaceNeutralLight = Color(0xFFF8FAF8);
const Color bgSurfaceNeutralDark = Color(0xFFF1F5F9);
const Color bgBlack = Color(0xFF0F172A);
const Color bgSurfaceNeutral = Color(0xFFF1F5F9);
const Color bgSurfaceNeutral2 = Color(0xFFE2E8F0);

const Color bgSurfacePrimary = Color(0xFFEAF6EE);     // Pastel Mint
const Color bgSurfaceSecondary = Color(0xFFFFF3E6);   // Pastel Peach
const Color bgSurfaceDanger = Color(0xFFFEECEB);      // Pastel Red
const Color bgSurfaceSuccess = Color(0xFFEAF6EE);     // Pastel Mint
const Color bgSurfaceWarning = Color(0xFFFEF9E7);     // Pastel Yellow
const Color bgSurfaceInfo = Color(0xFFE0F2FE);        // Pastel Blue

const Color bgHoverNeutral = Color(0xFFE2E8F0);
const Color bgHoverPrimary = Color(0xFFD4ECD9);
const Color bgHoverDanger = Color(0xFFFEE2E2);
const Color bgHoverSuccess = Color(0xFFD4ECD9);
const Color bgHoverWarning = Color(0xFFFEF3C7);
const Color bgHoverInfo = Color(0xFFBAE6FD);

const Color bgFillNeutral = Color(0xFF64748B);
const Color bgFillPrimary = Color(0xFF04883B);
const Color bgFillSecondary = Color(0xFFFF9F29);
const Color bgFillDanger = Color(0xFFEF4444);
const Color bgFillSuccess = Color(0xFF04883B);
const Color bgFillWarning = Color(0xFFF59E0B);
const Color bgFillInfo = Color(0xFF3B82F6);

// Buttons Background
const Color bgButtonPrimaryDefault = Color(0xFF04883B);
const Color bgButtonPrimaryHover = Color(0xFF037432);
const Color bgButtonPrimaryPressed = Color(0xFF025224);

const Color bgButtonSecondaryDefault = Color(0xFFFF9F29);
const Color bgButtonSecondaryHover = Color(0xFFEA580C);
const Color bgButtonSecondaryPressed = Color(0xFFC2410C);

const Color bgButtonInfoDefault = Color(0xFF3B82F6);
const Color bgButtonInfoHover = Color(0xFF2563EB);
const Color bgButtonInfoPressed = Color(0xFF1D4ED8);

const Color bgButtonOutlinedDefault = Color(0xFFFFFFFF);
const Color bgButtonOutlinedHover = Color(0xFFF8FAF8);
const Color bgButtonOutlinedPressed = Color(0xFFE2E8F0);

const Color bgButtonDangerDefault = Color(0xFFEF4444);
const Color bgButtonDangerHover = Color(0xFFDC2626);
const Color bgButtonDangerPressed = Color(0xFFB91C1C);

const Color bgButtonSuccessDefault = Color(0xFF04883B);
const Color bgButtonSuccessHover = Color(0xFF037432);
const Color bgButtonSuccessPressed = Color(0xFF025224);

const Color bgButtonWarningDefault = Color(0xFFF59E0B);
const Color bgButtonWarningHover = Color(0xFFD97706);
const Color bgButtonWarningPressed = Color(0xFFB45309);

const Color bgDisabled = Color(0xFFE2E8F0);
const Color bgButtonContainedDisabled = Color(0xFFE2E8F0);
const Color bgButtonOutlinedDisabled = Color(0xFFF1F5F9);
const Color bgForm = Color(0xFFFFFFFF);
const Color bgModal = Color(0xFFFFFFFF);
const Color bgBackdrop = Color(0x660F172A);
const Color bgSwitch = Color(0xFFE2E8F0);
const Color bgButtonSwitch = Color(0xFFFFFFFF);

// Border
const Color borderNeutral = Color(0xFFE2E8F0);
const Color borderNeutralLight = Color(0x1A0A0A0A);
const Color borderNeutralDark = Color(0x290A0A0A);
const Color borderLight = Color(0xFFFFFFFF);
const Color borderDark = Color(0xFF0A0A0A);

const Color borderSurfacePrimary = Color(0xFFC7EBD2);
const Color borderSurfaceSecondary = Color(0xFFFFE8D4);
const Color borderSurfaceDanger = Color(0xFFFECACA);
const Color borderSurfaceSuccess = Color(0xFFC7EBD2);
const Color borderSurfaceInfo = Color(0xFFBAE6FD);
const Color borderSurfaceWarning = Color(0xFFFEF08A);
const Color borderTransparentDark = Color(0x0A0A0A0A);
const Color borderTransparentLight = Color(0x1FFFFFFF);

const Color borderPrimary = Color(0xFF04883B);
const Color borderSecondary = Color(0xFFFFE8D4);
const Color borderDanger = Color(0xFFFEE2E2);
const Color borderSuccess = Color(0xFFC7EBD2);
const Color borderWarning = Color(0xFFFEF3C7);
const Color borderInfo = Color(0xFFBAE6FD);
const Color borderDisabled = Color(0xFFE2E8F0);

const Color borderFillNeutral = Color(0xFF64748B);
const Color borderFillPrimary = Color(0xFF04883B);
const Color borderFillSecondary = Color(0xFFFF9F29);
const Color borderFillDanger = Color(0xFFEF4444);
const Color borderFillSuccess = Color(0xFF04883B);
const Color borderFillWarning = Color(0xFFF59E0B);
const Color borderFillInfo = Color(0xFF3B82F6);

const Color borderButtonOutlinedDefault = Color(0xFFE2E8F0);
const Color borderButtonOutlinedFocused = Color(0xFF04883B);
const Color borderButtonOutlinedPressed = Color(0xFFCBD5E1);
const Color borderButtonFocused = Color(0x3304883B);
const Color borderButtonDangerFocused = Color(0x33EF4444);
const Color borderButtonSuccessFocused = Color(0x3304883B);
const Color borderButtonWarningFocused = Color(0x33F59E0B);

const Color borderFormDefault = Color(0xFFE2E8F0);
const Color borderFormDanger = Color(0xFFEF4444);
const Color borderSelectField = Color(0x14030712);
const Color borderTable = Color(0x0A0A0A0A);

/// Jacarta Accent
const Color jacarta50 = Color(0xFFF0F0F9);
const Color jacarta100 = Color(0xFFE6E5F5);
const Color jacarta200 = Color(0xFFD7D6F0);
const Color jacarta200_20 = Color(0x33D7D6F0);
const Color jacarta300 = Color(0xFFB3B1E2);
const Color jacarta400 = Color(0xFF8F8CD3);
const Color jacarta500 = Color(0xFF6A67C5);
const Color jacarta500_20 = Color(0x33666AEE);
const Color jacarta600 = Color(0xFF4845B5);
const Color jacarta700 = Color(0xFF393790);
const Color jacarta800 = Color(0xFF2B296C);
const Color jacarta900 = Color(0xFF1C1B46);
const Color jacarta950 = Color(0xFF0D0D21);

/// Sunglow / Gold Accent
const Color sunglow50 = Color(0xFFFEFBE8);
const Color sunglow100 = Color(0xFFFEF7C3);
const Color sunglow200 = Color(0xFFFEED8A);
const Color sunglow300 = Color(0xFFFEDB46);
const Color sunglow400 = Color(0xFFFBCA24);
const Color sunglow500 = Color(0xFFEBAD07);
const Color sunglow500_20 = Color(0x33EBAD07);
const Color sunglow600 = Color(0xFFCB8503);
const Color sunglow700 = Color(0xFFA15E07);
const Color sunglow800 = Color(0xFF854A0E);
const Color sunglow900 = Color(0xFF713C12);
