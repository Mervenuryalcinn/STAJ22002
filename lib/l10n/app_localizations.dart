import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @pharmacyProducts.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Products'**
  String get pharmacyProducts;

  /// No description provided for @searchProduct.
  ///
  /// In en, this message translates to:
  /// **'Search product...'**
  String get searchProduct;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found.'**
  String get noProductsFound;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get favorites;

  /// No description provided for @loginToViewFavorites.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your favorites.'**
  String get loginToViewFavorites;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No items added to favorites yet.'**
  String get noFavoritesYet;

  /// No description provided for @favoritePharmacy.
  ///
  /// In en, this message translates to:
  /// **'Favorite Pharmacy'**
  String get favoritePharmacy;

  /// No description provided for @favoriteProduct.
  ///
  /// In en, this message translates to:
  /// **'Favorite Product'**
  String get favoriteProduct;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @shoppingCart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shoppingCart;

  /// No description provided for @loginToViewCart.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your cart.'**
  String get loginToViewCart;

  /// No description provided for @cartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty.'**
  String get cartIsEmpty;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @confirmCartAndSelectPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cart & Select Pharmacy'**
  String get confirmCartAndSelectPharmacy;

  /// No description provided for @cartIsNotEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty!'**
  String get cartIsNotEmptyError;

  /// No description provided for @cartEmptyOrderError.
  ///
  /// In en, this message translates to:
  /// **'Order could not be created because your cart is empty.'**
  String get cartEmptyOrderError;

  /// No description provided for @selectPharmacyWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Please select a pharmacy to send your request!'**
  String get selectPharmacyWarning;

  /// No description provided for @pharmacySelected.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Selected'**
  String get pharmacySelected;

  /// No description provided for @selectThisPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Select This Pharmacy'**
  String get selectThisPharmacy;

  /// No description provided for @productStockStatus.
  ///
  /// In en, this message translates to:
  /// **'Stock status of items in your cart'**
  String get productStockStatus;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @distanceAway.
  ///
  /// In en, this message translates to:
  /// **'away'**
  String get distanceAway;

  /// No description provided for @orderApproval.
  ///
  /// In en, this message translates to:
  /// **'Order / Request Approval'**
  String get orderApproval;

  /// No description provided for @selectPharmacyByLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Pharmacy By Your Location'**
  String get selectPharmacyByLocation;

  /// No description provided for @searchingPharmacies.
  ///
  /// In en, this message translates to:
  /// **'Searching for pharmacies based on your location...'**
  String get searchingPharmacies;

  /// No description provided for @gettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting your location...'**
  String get gettingLocation;

  /// No description provided for @locationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not get location. Please check GPS and permissions.'**
  String get locationFailed;

  /// No description provided for @searchingMatchingPharmacies.
  ///
  /// In en, this message translates to:
  /// **'Searching for pharmacies that have all items in your cart...'**
  String get searchingMatchingPharmacies;

  /// No description provided for @pharmacySearchError.
  ///
  /// In en, this message translates to:
  /// **'Error while searching for pharmacies'**
  String get pharmacySearchError;

  /// No description provided for @noMatchingPharmacyFound.
  ///
  /// In en, this message translates to:
  /// **'No nearby pharmacy found containing all items in your cart.'**
  String get noMatchingPharmacyFound;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @completeOrder.
  ///
  /// In en, this message translates to:
  /// **'Complete Order / Request'**
  String get completeOrder;

  /// No description provided for @orderSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your order has been successfully saved!'**
  String get orderSuccess;

  /// No description provided for @patientLogin.
  ///
  /// In en, this message translates to:
  /// **'Patient Login'**
  String get patientLogin;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please log in to continue.'**
  String get loginSubtitle;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @emailEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Email field cannot be empty.'**
  String get emailEmptyError;

  /// No description provided for @emailInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get emailInvalidError;

  /// No description provided for @passwordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Password field cannot be empty.'**
  String get passwordEmptyError;

  /// No description provided for @passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get passwordLengthError;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up / Register'**
  String get registerTitle;

  /// No description provided for @tckn.
  ///
  /// In en, this message translates to:
  /// **'TCKN'**
  String get tckn;

  /// No description provided for @tcknEmptyError.
  ///
  /// In en, this message translates to:
  /// **'TCKN field cannot be empty.'**
  String get tcknEmptyError;

  /// No description provided for @tcknLengthError.
  ///
  /// In en, this message translates to:
  /// **'TCKN must be 11 digits.'**
  String get tcknLengthError;

  /// No description provided for @nameSurname.
  ///
  /// In en, this message translates to:
  /// **'Name Surname'**
  String get nameSurname;

  /// No description provided for @nameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Name Surname field cannot be empty.'**
  String get nameEmptyError;

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Product Description'**
  String get productDescription;

  /// No description provided for @pharmacyQueryButton.
  ///
  /// In en, this message translates to:
  /// **'Which Pharmacies Have This?'**
  String get pharmacyQueryButton;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @loginRequiredForCart.
  ///
  /// In en, this message translates to:
  /// **'Please log in first to add items to the cart!'**
  String get loginRequiredForCart;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'added to favorites!'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'removed from favorites!'**
  String get removedFromFavorites;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'added to cart!'**
  String get addedToCart;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @userInfoNotFound.
  ///
  /// In en, this message translates to:
  /// **'User info not found. Please log in again.'**
  String get userInfoNotFound;

  /// No description provided for @pharmacyStaffLogin.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Staff Login'**
  String get pharmacyStaffLogin;

  /// No description provided for @pharmacyStaffLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Click to go to the pharmacy panel'**
  String get pharmacyStaffLoginSubtitle;

  /// No description provided for @pastOrders.
  ///
  /// In en, this message translates to:
  /// **'Past Orders'**
  String get pastOrders;

  /// No description provided for @favoriteProducts.
  ///
  /// In en, this message translates to:
  /// **'My Favorite Products'**
  String get favoriteProducts;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @pharmacyStaffLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Staff Login'**
  String get pharmacyStaffLoginTitle;

  /// No description provided for @pharmacyManagementPanel.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Management Panel'**
  String get pharmacyManagementPanel;

  /// No description provided for @pharmacyEmail.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Email Address'**
  String get pharmacyEmail;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @noPharmacyOrders.
  ///
  /// In en, this message translates to:
  /// **'There are no requests for your pharmacy yet.'**
  String get noPharmacyOrders;

  /// No description provided for @orderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderId;

  /// No description provided for @patientTckn.
  ///
  /// In en, this message translates to:
  /// **'Patient TCKN'**
  String get patientTckn;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @viewAndManageOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'View & Manage Order Details'**
  String get viewAndManageOrderDetails;

  /// No description provided for @dutyPharmacies.
  ///
  /// In en, this message translates to:
  /// **'Duty Pharmacies'**
  String get dutyPharmacies;

  /// No description provided for @allPharmacies.
  ///
  /// In en, this message translates to:
  /// **'All Pharmacies'**
  String get allPharmacies;

  /// No description provided for @updateLocation.
  ///
  /// In en, this message translates to:
  /// **'Update Location'**
  String get updateLocation;

  /// No description provided for @gpsLoading.
  ///
  /// In en, this message translates to:
  /// **'Detecting your location...'**
  String get gpsLoading;

  /// No description provided for @dutyPharmaciesSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching for the nearest duty pharmacies to your location...'**
  String get dutyPharmaciesSearching;

  /// No description provided for @allPharmaciesSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching for all nearest pharmacies to your location...'**
  String get allPharmaciesSearching;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Could not get location. Please enable GPS and location permissions.'**
  String get locationError;

  /// No description provided for @noDutyPharmaciesFound.
  ///
  /// In en, this message translates to:
  /// **'No duty pharmacy found near your current GPS location.'**
  String get noDutyPharmaciesFound;

  /// No description provided for @noAllPharmaciesFound.
  ///
  /// In en, this message translates to:
  /// **'No registered pharmacy found near your current GPS location.'**
  String get noAllPharmaciesFound;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @mapTouchInstruction.
  ///
  /// In en, this message translates to:
  /// **'Tap to view on map 📍'**
  String get mapTouchInstruction;

  /// No description provided for @duty.
  ///
  /// In en, this message translates to:
  /// **'On Duty'**
  String get duty;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @mapOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open map application.'**
  String get mapOpenError;

  /// No description provided for @orderDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get orderDetailTitle;

  /// No description provided for @currentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get currentStatus;

  /// No description provided for @requestedProducts.
  ///
  /// In en, this message translates to:
  /// **'Requested Products'**
  String get requestedProducts;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get unitPrice;

  /// No description provided for @updateOrderStatus.
  ///
  /// In en, this message translates to:
  /// **'Update Order Status:'**
  String get updateOrderStatus;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @statusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Order status successfully updated.'**
  String get statusUpdated;

  /// No description provided for @pharmaciesContainingProduct.
  ///
  /// In en, this message translates to:
  /// **'Pharmacies Having Product'**
  String get pharmaciesContainingProduct;

  /// No description provided for @noProductInPharmacies.
  ///
  /// In en, this message translates to:
  /// **'This medicine is currently not available in any pharmacy stock.'**
  String get noProductInPharmacies;

  /// No description provided for @stockAmount.
  ///
  /// In en, this message translates to:
  /// **'Stock Amount'**
  String get stockAmount;

  /// No description provided for @userInfoNotFoundLogin.
  ///
  /// In en, this message translates to:
  /// **'User info not found. Please log in again.'**
  String get userInfoNotFoundLogin;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders placed yet.'**
  String get noOrdersYet;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @orderTracking.
  ///
  /// In en, this message translates to:
  /// **'Order Tracking'**
  String get orderTracking;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// No description provided for @orderStatusSteps.
  ///
  /// In en, this message translates to:
  /// **'Order Status Steps'**
  String get orderStatusSteps;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Request Received'**
  String get step1Title;

  /// No description provided for @step1Desc.
  ///
  /// In en, this message translates to:
  /// **'Your pharmacy has received and is reviewing your request.'**
  String get step1Desc;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get step2Title;

  /// No description provided for @step2Desc.
  ///
  /// In en, this message translates to:
  /// **'Your medicines are being prepared by the pharmacist.'**
  String get step2Desc;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'On the Way / Ready'**
  String get step3Title;

  /// No description provided for @step3Desc.
  ///
  /// In en, this message translates to:
  /// **'Courier is on the way or you can pick up from the pharmacy.'**
  String get step3Desc;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get step4Title;

  /// No description provided for @step4Desc.
  ///
  /// In en, this message translates to:
  /// **'Order successfully completed.'**
  String get step4Desc;

  /// No description provided for @loadingInfo.
  ///
  /// In en, this message translates to:
  /// **'Loading information...'**
  String get loadingInfo;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'404 - Page Not Found'**
  String get notFound;

  /// No description provided for @pharmacyNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Is your pharmacy not registered?'**
  String get pharmacyNoAccount;

  /// No description provided for @pharmacyRegisterButton.
  ///
  /// In en, this message translates to:
  /// **'Register Pharmacy'**
  String get pharmacyRegisterButton;

  /// No description provided for @pharmacyRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Registration'**
  String get pharmacyRegisterTitle;

  /// No description provided for @pharmacyName.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy Name'**
  String get pharmacyName;

  /// No description provided for @pharmacyNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy name cannot be empty.'**
  String get pharmacyNameEmptyError;

  /// No description provided for @addressEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Address cannot be empty.'**
  String get addressEmptyError;

  /// No description provided for @phoneEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Phone number cannot be empty.'**
  String get phoneEmptyError;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy registration successfully created!'**
  String get registerSuccess;

  /// No description provided for @registerPharmacyButton.
  ///
  /// In en, this message translates to:
  /// **'Complete Pharmacy Registration'**
  String get registerPharmacyButton;

  /// No description provided for @loginRequiredForFavorites.
  ///
  /// In en, this message translates to:
  /// **'You must log in to add to favorites'**
  String get loginRequiredForFavorites;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
