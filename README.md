## 💊 Acil Eczane ve İlaç Talep Platformu (Lideatech Staj Projesi)

Bu proje, Flutter ve Dart kullanılarak geliştirilmiş kurumsal seviyede bir **Acil Eczane ve İlaç Talep Platformu** e-ticaret ve talep mobil uygulamasıdır. Proje, modern yazılım mühendisliği prensiplerine, sürdürülebilir mimari standartlarına ve endüstri en iyi pratiklerine uygun olarak sıfırdan inşa edilmiştir.

---

## 🚀 Projenin Amacı ve Kapsamı
Acil Eczane ve İlaç Talep Platformu; kullanıcıların acil ihtiyaç duydukları sağlık ürünlerini arayabildiği, çevrelerindeki nöbetçi veya açık eczaneleri listeleyebildiği, sepet oluşturarak talep iletebildiği ve bu talepleri adım adım takip edebildiği kapsamlı bir ekosistemdir.

> **Not:** Uygulama eğitim ve portföy amaçlı geliştirilmiş olup gerçek ilaç satışı veya reçete doğrulaması yapmamaktadır; örnek veriler ve backend servis altyapısı kullanmaktadır.

---

## 🏛️ Mimari ve Klasör Yapısı (Clean Architecture + Feature-First)
Projede kodun sürdürülebilirliğini ve test edilebilirliğini artırmak amacıyla **Feature-First** yaklaşımıyla birleştirilmiş **Clean Architecture** katmanlı mimarisi benimsenmiştir. Her modül kendi içinde sorumluluklarına göre ayrılmıştır:

```text
lib/
├── app/
│   ├── app.dart
│   ├── bootstrap.dart
│   └── router/
│       ├── app_router.dart
│       ├── route_names.dart
│       └── route_guards.dart
├── core/
│   ├── config/          # AppConfig (Dev/Prod Environment yönetimi)
│   ├── constants/       # Sabitler ve uygulama genel değerler
│   ├── di/              # GetIt Dependency Injection altyapısı
│   ├── error/           # Failure ve Exception sınıfları
│   ├── network/         # Dio Client ve Interceptor yapılandırması
│   ├── theme/           # ThemeCubit (Dark/Light tema yönetimi)
│   ├── utils/           # Yardımcı araçlar ve extension'lar
│   └── widgets/         # Ortak yeniden kullanılabilir (reusable) bileşenler
├── features/
│   ├── authentication/  # Kimlik doğrulama (Login, Register, AuthBloc)
│   ├── pharmacy/        # Eczane listeleme, harita ve eczane paneli
│   ├── product/         # Ürün arama, filtreleme ve detay modülü
│   ├── cart/            # Sepet yönetimi ve talep onayı (Checkout)
│   ├── order/           # Sipariş geçmişi ve adım adım durum takibi
│   ├── favorites/       # Favori ürünler ve eczaneler
│   └── profile/         # Kullanıcı profili, ayarlar ve rol yönetimi
└── main.dart# lideatech_pharmacy_app~~

## 📋 Katman Sorumlulukları

| Katman | Açıklama | Sorumluluk Kuralı |
| :--- | :--- | :--- |
| **Presentation** <br>*(Sunum Katmanı)* | UI bileşenleri, Page/Widget yapıları, BLoC/Cubit state yönetim sınıfları ve UI modelleri. | Doğrudan veri kaynaklarıyla (`Dio`, veritabanı vb.) konuşmaz. |
| **Domain** <br>*(İş Mantığı Katmanı)* | Saf Dart sınıfları (`Entity`), Repository arayüzleri ve iş kurallarını içeren `Use Case`'ler. | Flutter UI paketlerinden ve dış detaylardan bağımsızdır. |
| **Data** <br>*(Veri Katmanı)* | DTO/Model sınıfları, Mapper yapıları, Repository implementasyonları (`_impl`) ve Remote/Local kaynaklar. | API ve yerel veri detaylarını yönetir; domain entity döndürür. |

---

## 🛠️ Teknik Özellikler ve Kullanılan Teknolojiler

| Kategori | Tercih / Teknoloji | Açıklama |
| :--- | :--- | :--- |
| **Framework** | Flutter & Dart | Güncel kararlı sürüm |
| **Mimari** | Clean Architecture | Feature-first modüler yaklaşım |
| **State Management** | `flutter_bloc` / Cubit | Asenkron durum ve ekran akış yönetimi |
| **Routing** | `go_router` | Merkezi rota yönetimi, parametreler ve korumalı rotalar (`redirect`) |
| **Network** | `Dio` | Merkezi BaseURL, Interceptor ve hata yönetimi |
| **Environment** | `AppConfig` | Geliştirme (`dev`) ve Canlı (`prod`) ortam konfigürasyonları |
| **Yerel Dil (l10n)** | ARB Tabanlı Localization | Türkçe ve İngilizce dil desteği |
| **Tema** | `ThemeCubit` | Dinamik Dark / Light tema geçişleri |
| **Test** | `flutter_test`, `bloc_test` | Unit, Bloc ve modül testleri |

---

## 🔒 Güvenlik ve Rota Yönetimi (`go_router`)

* **Oturum Kontrolü (`redirect`):** Kullanıcı kimlik doğrulaması yapmadan korumalı alanlara (`/cart`, `/checkout`, `/profile`, `/orders`) erişmeye çalıştığında sistem otomatik olarak `/login` sayfasına yönlendirir.
* **Merkezi Hata Yönetimi (`404`):** Tanımlı olmayan rotalar için dinamik lokalize edilmiş 404 Not Found sayfası sunulur.
* **Parametrik Rotalar:** Ürün ve eczane detay sayfalarında path parametreleri (`:id`) etkin bir şekilde kullanılmaktadır.

---

## ⚙️ Kurulum ve Çalıştırma

Projeyi yerel ortamınızda çalıştırmak için aşağıdaki adımları takip edebilirsiniz:

1. **Repoyu Klonlayın:**
   ```bash
   git clone [https://github.com/kullanici-adin/lideatech_pharmacy_app.git](https://github.com/kullanici-adin/lideatech_pharmacy_app.git)
   cd lideatech_pharmacy_app
1. **Bağımlılıkları Yükleyin::**
   ```bash
   flutter pub get

1. **Repoyu Klonlayın:**
   ```bash
   git clone [https://github.com/kullanici-adin/lideatech_pharmacy_app.git](https://github.com/kullanici-adin/lideatech_pharmacy_app.git)
   cd lideatech_pharmacy_app

# 1. Bağımlılıkları yükleyin
flutter pub get

# 2. Yerelleştirme (Localization) dosyalarını üretin
flutter gen-l10n

#3. backend aktif etmek için
cd backend
python main.py   

# 3. Uygulamayı çalıştırın
cd .. 
flutter run
