## 💊 Acil Eczane ve İlaç Talep Platformu (Lideatech Staj Projesi)

Bu proje, Flutter ve Dart kullanılarak geliştirilmiş kurumsal seviyede bir **Acil Eczane ve İlaç Talep Platformu** e-ticaret ve talep mobil uygulamasıdır. Proje, modern yazılım mühendisliği prensiplerine, sürdürülebilir mimari standartlarına ve endüstri en iyi pratiklerine uygun olarak sıfırdan inşa edilmiştir.

---

## 🚀 Projenin Amacı ve Kapsamı
Acil Eczane ve İlaç Talep Platformu; kullanıcıların acil ihtiyaç duydukları sağlık ürünlerini arayabildiği, çevrelerindeki nöbetçi veya açık eczaneleri listeleyebildiği, sepet oluşturarak talep iletebildiği ve bu talepleri adım adım takip edebildiği kapsamlı bir ekosistemdir.

> **Not:** Uygulama eğitim ve portföy amaçlı geliştirilmiş olup gerçek ilaç satışı veya reçete doğrulaması yapmamaktadır; örnek veriler ve backend servis altyapısı kullanmaktadır.

---

## 🏛️ Mimari ve Klasör Yapısı (Clean Architecture + Feature-First)
Projede kodun sürdürülebilirliğini ve test edilebilirliğini artırmak amacıyla **Feature-First** yaklaşımıyla birleştirilmiş **Clean Architecture** katmanlı mimarisi benimsenmiştir. Her modül kendi içinde sorumluluklarına göre ayrılmıştır:

## 📁 Proje Yapısı

```text
# lideatech_pharmacy_app

## 📁 Proje Yapısı

```text
lideatech_pharmacy_app/
│
├── backend/
│   ├── main.py
│   ├── requirements.txt
│   └── database/
│       ├── schema.sql
│       └── seed_data.sql
│
├── lib/
│   ├── app/
│   │   ├── app.dart
│   │   ├── bootstrap.dart
│   │   └── router/
│   ├── core/
│   │   ├── config/
│   │   ├── constants/
│   │   ├── di/
│   │   ├── error/
│   │   ├── network/
│   │   ├── theme/
│   │   ├── utils/
│   │   └── widgets/
│   │
│   ├── features/
│   │   ├── authentication/
│   │   ├── pharmacy/
│   │   ├── product/
│   │   ├── cart/
│   │   ├── order/
│   │   ├── favorites/
│   │   └── profile/
│   │
│   └── main.dart
│
├── test/
├── assets/
├── .env
├── .gitignore
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## 📋 Katman Sorumlulukları

| Katman | Açıklama | Sorumluluk Kuralı |
| :--- | :--- | :--- |
| **Presentation** | UI bileşenleri, Page/Widget yapıları ve BLoC/Cubit state yönetimi. | Doğrudan veri kaynaklarıyla (`Dio`, veritabanı vb.) konuşmaz. |
| **Domain** | Entity, Repository arayüzleri ve Use Case'ler. | Flutter UI paketlerinden ve dış detaylardan bağımsızdır. |
| **Data** | Model, Repository implementasyonları ve veri kaynakları. | API ve yerel veri detaylarını yönetir. |

---

## 🛠️ Teknik Özellikler

| Kategori | Teknoloji | Açıklama |
| :--- | :--- | :--- |
| **Framework** | Flutter & Dart | Mobil uygulama geliştirme |
| **Mimari** | Clean Architecture | Feature-first modüler yapı |
| **State Management** | `flutter_bloc` / Cubit | State yönetimi |
| **Routing** | `go_router` | Merkezi rota yönetimi |
| **Network** | `Dio` | API iletişimi |
| **Environment** | `AppConfig` | Dev / Prod yapılandırması |
| **Localization** | ARB | Türkçe ve İngilizce dil desteği |
| **Tema** | `ThemeCubit` | Dark / Light tema yönetimi |
| **Test** | `flutter_test`, `bloc_test` | Uygulama testleri |

---

## 🔒 Güvenlik ve Rota Yönetimi

- **Oturum Kontrolü:** Kullanıcı giriş yapmadan `/cart`, `/checkout`, `/profile` ve `/orders` gibi korumalı sayfalara erişemez.
- **Merkezi Hata Yönetimi:** Tanımlanmamış rotalar için 404 sayfası gösterilir.
- **Parametrik Rotalar:** Ürün, eczane ve sipariş detaylarında `:id` parametreleri kullanılmaktadır.

---

## ⚙️ Kurulum ve Çalıştırma

### 1. Repoyu Klonlayın

```bash
git clone https://github.com/kullanici-adin/lideatech_pharmacy_app.git
cd lideatech_pharmacy_app
```

### 2. Bağımlılıkları Yükleyin

```bash
flutter pub get
```

### 3. Localization Dosyalarını Üretin

```bash
flutter gen-l10n
```

### 4. Backend'i Başlatın

```bash
cd backend
python main.py
```

### 5. Flutter Uygulamasını Çalıştırın

Yeni bir terminal açın:

```bash
cd lideatech_pharmacy_app
flutter run
```