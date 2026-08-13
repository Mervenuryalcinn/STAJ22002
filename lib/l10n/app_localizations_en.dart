// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pharmacyProducts => 'Pharmacy Products';

  @override
  String get searchProduct => 'Search product...';

  @override
  String get noProductsFound => 'No products found.';

  @override
  String get stock => 'Stock';

  @override
  String get error => 'Error';

  @override
  String get favorites => 'My Favorites';

  @override
  String get loginToViewFavorites => 'Please log in to view your favorites.';

  @override
  String get login => 'Login';

  @override
  String get noFavoritesYet => 'No items added to favorites yet.';

  @override
  String get favoritePharmacy => 'Favorite Pharmacy';

  @override
  String get favoriteProduct => 'Favorite Product';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get name => 'Name';

  @override
  String get shoppingCart => 'Shopping Cart';

  @override
  String get loginToViewCart => 'Please log in to view your cart.';

  @override
  String get cartIsEmpty => 'Your cart is empty.';

  @override
  String get total => 'Total';

  @override
  String get confirmCartAndSelectPharmacy => 'Confirm Cart & Select Pharmacy';

  @override
  String get cartIsNotEmptyError => 'Your cart is empty!';

  @override
  String get cartEmptyOrderError =>
      'Order could not be created because your cart is empty.';

  @override
  String get selectPharmacyWarning =>
      '⚠️ Please select a pharmacy to send your request!';

  @override
  String get pharmacySelected => 'Pharmacy Selected';

  @override
  String get selectThisPharmacy => 'Select This Pharmacy';

  @override
  String get productStockStatus => 'Stock status of items in your cart';

  @override
  String get units => 'Units';

  @override
  String get distanceAway => 'away';

  @override
  String get orderApproval => 'Order / Request Approval';

  @override
  String get selectPharmacyByLocation => 'Select Pharmacy By Your Location';

  @override
  String get searchingPharmacies =>
      'Searching for pharmacies based on your location...';

  @override
  String get gettingLocation => 'Getting your location...';

  @override
  String get locationFailed =>
      'Could not get location. Please check GPS and permissions.';

  @override
  String get searchingMatchingPharmacies =>
      'Searching for pharmacies that have all items in your cart...';

  @override
  String get pharmacySearchError => 'Error while searching for pharmacies';

  @override
  String get noMatchingPharmacyFound =>
      'No nearby pharmacy found containing all items in your cart.';

  @override
  String get retry => 'Retry';

  @override
  String get completeOrder => 'Complete Order / Request';

  @override
  String get orderSuccess => 'Your order has been successfully saved!';

  @override
  String get patientLogin => 'Patient Login';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get welcome => 'Welcome';

  @override
  String get loginSubtitle => 'Please log in to continue.';

  @override
  String get password => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get registerButton => 'Register';

  @override
  String get emailEmptyError => 'Email field cannot be empty.';

  @override
  String get emailInvalidError => 'Please enter a valid email address.';

  @override
  String get passwordEmptyError => 'Password field cannot be empty.';

  @override
  String get passwordLengthError => 'Password must be at least 6 characters.';

  @override
  String get registerTitle => 'Sign Up / Register';

  @override
  String get tckn => 'TCKN';

  @override
  String get tcknEmptyError => 'TCKN field cannot be empty.';

  @override
  String get tcknLengthError => 'TCKN must be 11 digits.';

  @override
  String get nameSurname => 'Name Surname';

  @override
  String get nameEmptyError => 'Name Surname field cannot be empty.';

  @override
  String get productDescription => 'Product Description';

  @override
  String get pharmacyQueryButton => 'Which Pharmacies Have This?';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get loginRequiredForCart =>
      'Please log in first to add items to the cart!';

  @override
  String get addedToFavorites => 'added to favorites!';

  @override
  String get removedFromFavorites => 'removed from favorites!';

  @override
  String get addedToCart => 'added to cart!';

  @override
  String get userProfile => 'User Profile';

  @override
  String get userInfoNotFound => 'User info not found. Please log in again.';

  @override
  String get pharmacyStaffLogin => 'Pharmacy Staff Login';

  @override
  String get pharmacyStaffLoginSubtitle => 'Click to go to the pharmacy panel';

  @override
  String get pastOrders => 'Past Orders';

  @override
  String get favoriteProducts => 'My Favorite Products';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get pharmacyStaffLoginTitle => 'Pharmacy Staff Login';

  @override
  String get pharmacyManagementPanel => 'Pharmacy Management Panel';

  @override
  String get pharmacyEmail => 'Pharmacy Email Address';

  @override
  String get refresh => 'Refresh';

  @override
  String get noPharmacyOrders => 'There are no requests for your pharmacy yet.';

  @override
  String get orderId => 'Order ID';

  @override
  String get patientTckn => 'Patient TCKN';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get date => 'Date';

  @override
  String get viewAndManageOrderDetails => 'View & Manage Order Details';

  @override
  String get dutyPharmacies => 'Duty Pharmacies';

  @override
  String get allPharmacies => 'All Pharmacies';

  @override
  String get updateLocation => 'Update Location';

  @override
  String get gpsLoading => 'Detecting your location...';

  @override
  String get dutyPharmaciesSearching =>
      'Searching for the nearest duty pharmacies to your location...';

  @override
  String get allPharmaciesSearching =>
      'Searching for all nearest pharmacies to your location...';

  @override
  String get locationError =>
      'Could not get location. Please enable GPS and location permissions.';

  @override
  String get noDutyPharmaciesFound =>
      'No duty pharmacy found near your current GPS location.';

  @override
  String get noAllPharmaciesFound =>
      'No registered pharmacy found near your current GPS location.';

  @override
  String get phone => 'Phone Number';

  @override
  String get mapTouchInstruction => 'Tap to view on map 📍';

  @override
  String get duty => 'On Duty';

  @override
  String get open => 'Open';

  @override
  String get mapOpenError => 'Could not open map application.';

  @override
  String get orderDetailTitle => 'Order Detail';

  @override
  String get currentStatus => 'Current Status';

  @override
  String get requestedProducts => 'Requested Products';

  @override
  String get unitPrice => 'Unit Price';

  @override
  String get updateOrderStatus => 'Update Order Status:';

  @override
  String get active => 'Active';

  @override
  String get statusUpdated => 'Order status successfully updated.';

  @override
  String get pharmaciesContainingProduct => 'Pharmacies Having Product';

  @override
  String get noProductInPharmacies =>
      'This medicine is currently not available in any pharmacy stock.';

  @override
  String get stockAmount => 'Stock Amount';

  @override
  String get userInfoNotFoundLogin =>
      'User info not found. Please log in again.';

  @override
  String get noOrdersYet => 'No orders placed yet.';

  @override
  String get address => 'Address';

  @override
  String get amount => 'Amount';

  @override
  String get orderTracking => 'Order Tracking';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get orderStatusSteps => 'Order Status Steps';

  @override
  String get step1Title => 'Request Received';

  @override
  String get step1Desc =>
      'Your pharmacy has received and is reviewing your request.';

  @override
  String get step2Title => 'Preparing';

  @override
  String get step2Desc =>
      'Your medicines are being prepared by the pharmacist.';

  @override
  String get step3Title => 'On the Way / Ready';

  @override
  String get step3Desc =>
      'Courier is on the way or you can pick up from the pharmacy.';

  @override
  String get step4Title => 'Completed';

  @override
  String get step4Desc => 'Order successfully completed.';

  @override
  String get loadingInfo => 'Loading information...';

  @override
  String get notFound => '404 - Page Not Found';

  @override
  String get pharmacyNoAccount => 'Is your pharmacy not registered?';

  @override
  String get pharmacyRegisterButton => 'Register Pharmacy';

  @override
  String get pharmacyRegisterTitle => 'Pharmacy Registration';

  @override
  String get pharmacyName => 'Pharmacy Name';

  @override
  String get pharmacyNameEmptyError => 'Pharmacy name cannot be empty.';

  @override
  String get addressEmptyError => 'Address cannot be empty.';

  @override
  String get phoneEmptyError => 'Phone number cannot be empty.';

  @override
  String get registerSuccess => 'Pharmacy registration successfully created!';

  @override
  String get registerPharmacyButton => 'Complete Pharmacy Registration';

  @override
  String get loginRequiredForFavorites => 'You must log in to add to favorites';
}
