*&---------------------------------------------------------------------*
*& Report ZBK_EGT_005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBK_EGT_005.

PARAMETERS: p_num TYPE int4.

DATA: gv_num1 TYPE int4,
      gv_num2 TYPE int4,
      gv_num3 TYPE int4.

INITIALIZATION.
  p_num = 12.

AT SELECTION-SCREEN.
  p_num = p_num + 1.

START-OF-SELECTION.
  WRITE: / 'START-OF-SELECTION'.

  PERFORM sayiya_bir_ekle.
  PERFORM sayiya_bir_ekle.
  PERFORM iki_sayinin_carpimi USING 10 5.

  gv_num2 = 15.
  gv_num3 = 5.

  PERFORM iki_sayinin_farki USING gv_num2 gv_num3.
  PERFORM form1.
  PERFORM form2.

  WRITE: / gv_num1.
  WRITE: / 'END-OF-SELECTION'.

FORM sayiya_bir_ekle.
  gv_num1 = gv_num1 + 1.
ENDFORM.

FORM iki_sayinin_carpimi USING p_num1 p_num2.
  DATA lv_sonuc TYPE int4.
  lv_sonuc = p_num1 * p_num2.
  WRITE: / 'iki sayinin carpimi:', lv_sonuc.
ENDFORM.

FORM iki_sayinin_farki USING p_num1 p_num2.
  DATA lv_sonuc2 TYPE int4.
  lv_sonuc2 = p_num1 - p_num2.
  WRITE: / 'iki sayinin farki:', lv_sonuc2.
ENDFORM.

FORM form1.
  DATA lv_num2 TYPE int4.
  gv_num1 = gv_num1 + 1.
  lv_num2 = lv_num2 + 1.
ENDFORM.

FORM form2.
  WRITE: / 'FORM2 calisti'.
ENDFORM.
