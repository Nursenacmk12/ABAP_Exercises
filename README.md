# SAP NPL + abapGit + GitHub — Kurulum Kılavuzu

> **Sistem:** SAP NetWeaver AS ABAP Developer Edition (NPL)  
> **Kullanıcı:** DEVELOPER | **Installation:** DEMOSYSTEM | **Tarih:** 2026-04-23

---

## 📋 İçindekiler

1. [Hızlı SSS](#hızlı-sss)
2. [Faz 1 — Lisans Yenileme](#faz-1--lisans-yenileme)
3. [Faz 2 — SSCR Engelini Aşma](#faz-2--sscr-developer-registration-engelini-aşma)
4. [Faz 3 — abapGit Kurulumu](#faz-3--abapgit-standalone-kurulumu)
5. [Faz 4 — GitHub SSL Sertifikası](#faz-4--github-ssl-sertifikasını-sape-tanıtma)
6. [Faz 5 — ICM Restart](#faz-5--icm-restart)
7. [Faz 6 — GitHub Repo ve PAT](#faz-6--github-repo-ve-pat-hazırlığı)
8. [Faz 7 — abapGit Bağlantısı](#faz-7--abapgitte-repou-bağla)
9. [Faz 8 — İlk Commit ve Push](#faz-8--i̇lk-commit-ve-push)
10. [Faz 9 — ZGIT T-code](#faz-9--zgit-t-code-oluşturma)
11. [Günlük Kullanım](#günlük-kullanım-akışı)
12. [Kritik Bilgiler](#kritik-bilgiler-tablosu)
13. [T-code Referansı](#t-code-referansı)
14. [Sorun Giderme](#sorun-giderme)
15. [Sonraki Adımlar](#sonraki-adımlar)

---

## ❓ Hızlı SSS

**S: PAT'ı her seferinde girmem gerekecek mi?**  
C: Hayır. İlk başarılı push'tan sonra abapGit, PAT'ı repo bazında SAP tablosunda cache'ler. 90 gün (PAT süresi) boyunca tekrar sormaz. PAT expire olduğunda yeni üretip bir kez girersin.

**S: GitHub web sitesini SAP GUI içinde görebilir miyim?**  
C: Hayır, SAP GUI tarayıcı değil. GitHub'ı normal tarayıcıda aç, SAP GUI'yi paralelde kullan. abapGit ekranı GitHub'a benziyor ama abapGit'in kendi UI'ı.

**S: abapGit'i nasıl açıyorum?**  
C: `/nZGIT` (T-code oluşturduktan sonra). Eskiden: `/nSE38` → `ZABAPGIT_STANDALONE` → F8.

---

## Faz 1 — Lisans Yenileme

**Amaç:** SLICENSE'ta expired olan NetWeaver_SYB lisansını yenilemek.

### 1.1 Mevcut Durumu Kontrol Et

1. SAP GUI'ye login (User: `DEVELOPER`)
2. `/nSLICENSE` → Enter
3. Beklenen ekran:

| Alan | Değer |
|------|-------|
| Active Hardware Key | `V0737484574` |
| Installation Number | `DEMOSYSTEM` |
| NetWeaver_SYB | Valid (21.06.2026) |
| Maintenance_SYB | Expired (28.03.2026) |

### 1.2 Yeni Lisans Talep Et

1. Tarayıcıda `developers.sap.com` → *"SAP License Keys for Preview, Evaluation and Developer Versions"*
2. System listesinden: **NPL - SAP NetWeaver 7.x (Sybase ASE)**
3. Formu doldur:
   - Hardware Key: `V0737484574`
   - Installation: `DEMOSYSTEM`
   - E-posta adresin
4. Submit → mail ile `NPL.txt` gelir

### 1.3 Lisansı Yükle

1. `/nSLICENSE` → ekranın altında **Install** butonu
2. İndirdiğin `NPL.txt` dosyasını seç
3. Popup: *"License already exists, overwrite?"* → **Yes**
4. ✅ Sonuç: `NetWeaver_SYB` satırı yeşil, Valid To: `23.07.2026`

> **Not:** `Maintenance_SYB` yenilenmedi — dev ortamında zorunlu değil.

---

## Faz 2 — SSCR (Developer Registration) Engelini Aşma

**Problem:** Z-namespace'de yeni obje yaratırken "Register Developer" pop-up çıkıyor, 20 haneli Access Key istiyor.

### 2.1 DEVACCESS Tablosunu Kontrol Et

```
/nSE16 → Table name: DEVACCESS → F8 (Execute)
```
→ Tablo boş ise DEVELOPER kullanıcısı için SSCR kaydı yok.

### 2.2 Community Access Key ile Aş

1. Google: `NPL DEVELOPER access key DEMOSYSTEM`
2. abapGit docs / SAP Community / Stack Overflow'dan 20 haneli key bul
3. SE38'de `ZABAPGIT_STANDALONE` yarat → pop-up gelir
4. Access key alanına yapıştır → **Continue**
5. ✅ `DEVACCESS` tablosuna otomatik kayıt düşer — bundan sonra pop-up gelmez

---

## Faz 3 — abapGit Standalone Kurulumu

### 3.1 Kaynak Kodu Edin

[https://github.com/abapGit/abapGit](https://github.com/abapGit/abapGit) → Releases → `zabapgit_standalone.abap` dosyasını indir veya raw content'ini kopyala.

### 3.2 SE38'de Rapor Yarat

```
/nSE38 → Program: ZABAPGIT_STANDALONE → Create
```

| Alan | Değer |
|------|-------|
| Title | abapGit Standalone |
| Type | Executable program |
| Package | Local Object ($TMP) |

### 3.3 Kaynak Kodu Yapıştır

1. Boş editöre GitHub'dan kopyaladığın tüm abapGit source'unu yapıştır
2. `Ctrl+F3` (Activate) → bekle
3. ✅ Üst çubukta **Active** yazmalı

---

## Faz 4 — GitHub SSL Sertifikasını SAP'ye Tanıtma

**Problem:** abapGit GitHub'a bağlanınca `SSLERR_PEER_CERT_UNTRUSTED (-102)` hatası.

### 4.1 GitHub Sertifikasını İndir

1. Tarayıcıda `https://github.com` aç
2. 🔒 kilit ikonu → *Certificate is valid* → **Details** sekmesi
3. **Copy to File** → Format: **Base-64 encoded X.509 (.CER)**
4. Dosya adı: `github.cer` → Save

### 4.2 STRUST'a Ekle — Anonymous

```
/nSTRUST → SSL client → SSL Client (Anonymous) → çift tık
Menü: Certificate → Change
Alt panel: Import certificate → Base64 → github.cer seç → OK
Add to Certificate List → Ctrl+S
```

### 4.3 STRUST'a Ekle — Standard

Aynı işlemi **SSL Client (Standard)** düğümü için tekrarla.

> **Not:** Leaf sertifika 03.06.2026'da expire olacak. Uzun vadeli için Sectigo Root CA ayrıca eklenebilir.

---

## Faz 5 — ICM Restart

STRUST'a eklenen sertifikaların aktif olması için:

```
/nSMICM → Administration → ICM → Exit Soft → Global → Yes
```

~10 saniye bekle → F5 → ICM Status: **Running** ✅

---

## Faz 6 — GitHub Repo ve PAT Hazırlığı

### 6.1 GitHub'da Repo Yarat

1. `https://github.com` → sağ üst **+** → **New repository**
2. Ayarlar:
   - Repo adı: `ABAP_Exercises`
   - Visibility: **Private**
   - README / gitignore: **seçme** (boş repo)
3. ✅ URL: `https://github.com/Nursenacmk12/ABAP_Exercises`

### 6.2 Personal Access Token (PAT) Üret

```
GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token
```

| Alan | Değer |
|------|-------|
| Token name | `sap-abapgit` |
| Expiration | 90 days |
| Repository access | Only: `ABAP_Exercises` |
| Contents | **Read and write** ⚠️ kritik |
| Metadata | Read (otomatik) |

> ⚠️ Ekrana çıkan `github_pat_...` string'ini kopyala ve güvenli yere kaydet — **bir daha gösterilmez!**

---

## Faz 7 — abapGit'te Repo'yu Bağla

### 7.1 abapGit'i Çalıştır

```
/nSE38 → ZABAPGIT_STANDALONE → F8
```

### 7.2 New Online Repo

Sol üstte **New Online** butonu:

| Alan | Değer |
|------|-------|
| Git repository URL | `https://github.com/Nursenacmk12/ABAP_Exercises` |
| Package | `$ZABAP_EXERCISES` |
| Branch | boş (Autodetect) |
| Folder Logic | Prefix (default) |
| Display Name | Bebisim(Alistirma) |

**Create Online Repo** → bağlantı başarılı.

> **Not:** İlk denemede SSL handshake failed alınırsa → Faz 4 ve Faz 5'i uygula → tekrar dene.

---

## Faz 8 — İlk Commit ve Push

### 8.1 Stage

Repository ekranı → **Stage** linki → iki satırı **Add** et → Staged kolonu.

### 8.2 Commit Formu

| Alan | Değer |
|------|-------|
| Comment | First commit |
| Committer Name | Nursena Camkomuru |
| Committer Email | camkomurunursena@gmail.com |

### 8.3 Login Popup

```
User: Nursenacmk12
Password or Token: <PAT yapıştır — GitHub şifresi DEĞİL>
```

### 8.4 Sonuç

✅ Alt sol yeşil mesaj: **"Commit was successful"**

GitHub'da `src/package.devc.xml` ve `.abapgit.xml` görünür.

---

## Faz 9 — ZGIT T-code Oluşturma

**Amaç:** `/nSE38 → ZABAPGIT_STANDALONE → F8` zincirini `/nZGIT` tek komutuna indirmek.

### 9.1 SE93'te Transaction Yarat

```
/nSE93 → Transaction code: ZGIT → Create
```

| Alan | Değer |
|------|-------|
| Short text | abapGit |
| Start object | Program and selection screen (report transaction) |

### 9.2 Detay Ekranı

| Alan | Değer |
|------|-------|
| Program | `ZABAPGIT_STANDALONE` |
| Screen number | `1000` |
| GUI support | SAP GUI for Windows ☑ |

`Ctrl+S` → Package: `$TMP` → **Local Object**

### 9.3 Test

```
/nZGIT → abapGit UI direkt açılır ✅
```

---

## Günlük Kullanım Akışı

```
1. ABAP'ta kod yaz
   SE80 → Class/Report/Table yarat
   Paket: $ZABAP_EXERCISES

2. Ctrl+F3 ile aktive et

3. /nZGIT → abapGit aç

4. Repository List → repo seç

5. Refresh → değişiklikler görünür

6. Stage → Add → objeleri işaretle

7. Commit → mesaj yaz → ✓
   (PAT cache'de, sormaz)

8. GitHub'da doğrula
```

---

## Kritik Bilgiler Tablosu

| Bilgi | Değer |
|-------|-------|
| SAP System ID | NPL |
| SAP User | DEVELOPER |
| Installation | DEMOSYSTEM |
| Hardware Key | V0737484574 |
| Lisans Geçerlilik | 23.07.2026 |
| abapGit Versiyon | 1.133.0 (Standalone) |
| abapGit Programı | ZABAPGIT_STANDALONE |
| abapGit T-code | ZGIT |
| GitHub Repo | github.com/Nursenacmk12/ABAP_Exercises |
| GitHub User | Nursenacmk12 |
| Git Email | camkomurunursena@gmail.com |
| Branch | main |
| Lokal Paket | $ZABAP_EXERCISES |
| Folder Logic | Prefix |
| PAT Süresi | 90 gün |
| PAT Permissions | Contents: Read/Write |

---

## T-code Referansı

| T-code | İşlev |
|--------|-------|
| SLICENSE | Lisans yönetimi |
| SE38 | ABAP Editor |
| SE80 | Object Navigator (class, paket, tablo) |
| SE16 | Table Browser |
| SE21 | Paket yaratma |
| SE93 | Transaction code yaratma |
| STRUST | SSL sertifika yönetimi |
| SMICM | Internet Communication Manager |
| ZGIT | abapGit (özel yaratılan) |

---

## Sorun Giderme

| Hata | Sebep | Çözüm |
|------|-------|-------|
| "Register Developer" pop-up | DEVACCESS boş | Community access key gir |
| SSLERR_PEER_CERT_UNTRUSTED | GitHub cert tanımsız | STRUST → import → SMICM restart |
| HTTP 401 Unauthorized | PAT yanlış veya yetkisiz | Fine-grained PAT + Contents: R/W |
| HTTP 403 Forbidden | PAT repo access yok | Token'a repo ekle |
| Lisans expired | 90 günlük NPL lisansı bitti | Yeni NPL lisansı talep et |
| Transaction not found: ZGIT | T-code yaratılmadı | SE93 → Create |
| abapGit push hata veriyor | Paket $TMP değil ama transport seçilmedi | $TMP kullan veya transport ata |

---

## PAT Hakkında Detaylı Bilgi

### PAT nerede saklanır?
- SAP'nin iç tablosunda (`ZABAPGIT_CREDS` veya benzer)
- Kullanıcı + repo URL bazında
- Sadece `DEVELOPER` user ile login olduğunda erişilir

### PAT ne zaman tekrar sorulur?
- Token expire olduğunda (90 gün)
- GitHub'da manuel revoke edersen
- abapGit'te Repo Settings → Remote Settings → Change ile credential silersen
- Farklı repo eklediğinde (her repo kendi auth'unu ister)

### PAT süresi yaklaşınca
1. GitHub'da eski token'ı **Revoke**
2. Yeni fine-grained token üret (aynı permission'larla)
3. abapGit'te ilk push'ta popup tekrar çıkar
4. Yeni PAT'ı yapıştır → cache'lenir

### PAT kaybolursa
Paniğe gerek yok:
1. Eski token'ı revoke et
2. Yeni üret
3. abapGit'te ilk push'ta gir

---

## 🔒 Güvenlik Notları

- PAT'ı şifre gibi davran, **git repo'suna commit etme**
- GitHub repo'yu **Private** tut — özellikle SAP dahili bilgi içeriyorsa
- `$` prefix'li lokal paketler başka sisteme taşınmaz (transport olmaz)
- Lisans dosyasını (`NPL.txt`) repo'ya koyma — sisteminize özel

---

## Sonraki Adımlar

- [ ] **Sectigo Root CA'yı STRUST'a ekle** — leaf cert expire olduğunda bağlantı kesilmesin
- [ ] **abapGit Developer Version'a geç** — Advanced → Install abapGit Repo → kendini update edebilir
- [ ] **Gerçek paket yarat** — SE21 ile `ZABAP_EXERCISES` (dolar'sız), transport'lanabilir kod için
- [ ] **OData servisi geliştirme** — SEGW ile proje, entity, DPC_EXT, service register
- [ ] **.NET projesi ile bağlantı** — HttpSapStockClient + appsettings + Basic Auth + CSRF handler

---

## ✅ Kurulum Özeti

| Bileşen | Durum |
|---------|-------|
| SAP NPL (lisans güncel) | ✅ |
| DEVELOPER user aktif (SSCR kayıtlı) | ✅ |
| abapGit sistemde kurulu ve aktif | ✅ |
| GitHub SSL sertifikası tanımlı | ✅ |
| GitHub PAT ile bağlantı | ✅ |
| İlk commit + push başarılı | ✅ |
| ZGIT T-code ile tek komutta erişim | ✅ |

> Artık ABAP kodlarını rahatça yazıp GitHub'a versiyonlayabilirsin.  
> **Bir sonraki büyük hedef:** OData servisi kurup .NET API'den tüketmek.
