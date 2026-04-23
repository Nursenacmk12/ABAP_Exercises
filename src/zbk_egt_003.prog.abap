*&---------------------------------------------------------------------*
*& Report ZBK_EGT_003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report ZBK_EGT_0003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBK_EGT_0003.

DATA: gv_personelid TYPE ZBK_PERSONEL_ID,
      gv_personelad TYPE ZBK_PERSONEL_AD,
      gv_personelsoyad TYPE ZBK_PERSONEL_SOYAD ,
      gv_personelcinsiyet TYPE ZBK_PERSONEL_CINSIYET ,
      gs_pers_t TYPE ZBK_PERSONEL_T ,
      gt_pers_t TYPE TABLE OF ZBK_PERSONEL_T .

* SELECT
* UPDATE
* INSERT
* DELETE
* MODIFY

Select * FROM ZBK_PERSONEL_T
  INTO TABLE gt_pers_t
  WHERE PERS_ID EQ 1 .

SELECT SINGLE * FROM ZBK_PERSONEL_T
  INTO gs_pers_t.

SELECT SINGLE PERS_ID FROM ZBK_PERSONEL_T
  INTO gv_personelid .

UPDATE ZBK_PERSONEL_T SET PERS_AD = 'Ali'
  WHERE PERS_ID EQ 1 .

*WRITE: 'Update komutu çalıştırıldı'.
*gs_pers_t-PERS_ID = 3.
*gs_pers_t-PERS_AD =  'Furkan' .
*gs_pers_t-PERS_SOYAD = 'Söylemez' .
*gs_pers_t-PERS_CINS = 'E' .
*INSERT ZBK_PERSONEL_T FROM gs_pers_t .

WRITE: 'INSERT komutu çalıştırıldı.' .

DELETE FROM ZBK_PERSONEL_T WHERE PERS_ID EQ 1.
WRITE: 'DELETE komutu çalıştırıldı.' .

gs_pers_t-PERS_ID = 4.
gs_pers_t-PERS_AD =  'Gülçin' .
gs_pers_t-PERS_SOYAD = 'Söylemez' .
gs_pers_t-PERS_CINS = 'K' .
MODIFY ZBK_PERSONEL_T FROM gs_pers_t .
WRITE: 'Modify komutu çalıştırıldı.' .
