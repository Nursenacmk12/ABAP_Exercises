*&---------------------------------------------------------------------*
*& Report ZBK_EGT_004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBK_EGT_004.
TABLES: ZBK_PERSONEL_T .
DATA: gv_persoyad TYPE ZBK_PERSONEL_SOYAD .
PARAMETERS: p_num1 TYPE int4,
            p_PERSAD TYPE ZBK_PERSONEL_AD .

SELECT-OPTIONS: s_persad for gv_persoyad ,
              s_perscn for ZBK_PERSONEL_T-PERS_CINS .

PARAMETERS: p_cbox1 AS CHECKBOX .
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME  TITLE text-001.
PARAMETERS: p_rad1 RADIOBUTTON GROUP grp1,
            p_rad2 RADIOBUTTON GROUP grp1,
            p_rad3 RADIOBUTTON GROUP grp1.
SELECTION-SCREEN END OF BLOCK bl1 .

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE text-002.
PARAMETERS: p_rad4 RADIOBUTTON GROUP grp2,
            p_rad5 RADIOBUTTON GROUP grp2.
SELECTION-SCREEN END OF BLOCK bl2.
