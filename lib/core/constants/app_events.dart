/// App-wide event names used for logging to `/api/v1/log/event`.
///
/// These values **must** match the backend APP_EVENTS constants exactly.
class AppEvents {
  // App
  static const String openApp = 'open-app';
  static const String closeApp = 'close-app';

  // Nav Bar
  static const String navClickHome = 'nav-click-home';
  static const String navClickReels = 'nav-click-reels';
  static const String navClickChat = 'nav-click-chat';
  static const String navClickSearch = 'nav-click-search';
  static const String navClickProfile = 'nav-click-profile';

  // Notifications Page
  static const String notificationsClickBack = 'notifications-click-back';

  // Favourites Page
  static const String favouritesClickBack = 'favourites-click-back';
  static const String favouritesClickRemoveFavourite =
      'favourites-click-remove-favourite';

  // Maincategory Page
  static const String maincategoryClickBack = 'maincategory-click-back';
  static const String maincategoryClickBrand = 'maincategory-click-brand';

  // Home Page
  static const String homeClickNotifications = 'home-click-notifications';
  static const String homeClickFavourites = 'home-click-favourites';
  static const String homeClickAddFavourite = 'home-click-add-favourite';
  static const String homeClickRemoveFavourite = 'home-click-remove-favourite';
  static const String homeClickBanner = 'home-click-banner';
  static const String homeClickMaincategory = 'home-click-maincategory';
  static const String homeClickBrand = 'home-click-brand';
  static const String homeClickService = 'home-click-service';
  static const String homeClickMorePopularBrands =
      'home-click-more-popular-brands';
  static const String homeClickMorePopularServices =
      'home-click-more-popular-services';
  static const String homeClickMoreTopratedBrands =
      'home-click-more-toprated-brands';
  static const String homeClickMoreTopratedServices =
      'home-click-more-toprated-services';
  static const String homeClickBookingStatus = 'home-click-booking-status';

  // Popular & Toprated Pages
  static const String popularClickBrandsBack = 'popular-click-brands-back';
  static const String popularClickServicesBack = 'popular-click-services-back';
  static const String topratedClickBrandsBack = 'toprated-click-brands-back';
  static const String topratedClickServicesBack =
      'toprated-click-services-back';
  static const String popularClickBrandsBrand = 'popular-click-brands-brand';
  static const String popularClickServicesService =
      'popular-click-services-service';
  static const String topratedClickBrandsBrand = 'toprated-click-brands-brand';
  static const String topratedClickServicesService =
      'toprated-click-services-service';

  // Reels Page
  static const String reelsClickBack = 'reels-click-back';
  static const String reelsClickComments = 'reels-click-comments';
  static const String reelsClickBrand = 'reels-click-brand';
  static const String reelsClickChat = 'reels-click-chat';
  static const String reelsClickFilter = 'reels-click-filter';
  static const String reelsTimeWatching = 'reels-time-start-end-watching';

  // Search Page
  static const String searchClickBack = 'search-click-back';
  static const String searchClickMedia = 'search-click-media';
  static const String searchClickBrand = 'search-click-brand';
  static const String searchClickSearch = 'search-click-search';
  static const String searchSearch = 'search-search';
  static const String searchMediaClickBack = 'search-media-click-back';
  static const String searchMediaClickBrand = 'search-media-click-brand';
  static const String searchMediaClickChat = 'search-media-click-chat';
  static const String searchMediaClickReport = 'search-media-click-report';
  static const String searchMediaSubmitReport = 'search-media-submit-report';
  static const String searchMediaClickBook = 'search-media-click-book';
  static const String searchMediaClickComments = 'search-media-click-comments';

  // Chat Page
  static const String chatClickBack = 'chat-click-back';
  static const String chatOpenChat = 'chat-open-chat';
  static const String chatTimeChatting = 'chat-time-start-end-chating';

  // Profile Page
  static const String profileClickBack = 'profile-click-back';
  static const String profileClickEditData = 'profile-click-edit-data';
  static const String profileClickEditPhone = 'profile-click-edit-phone';
  static const String profileClickEditPhoto = 'profile-click-edit-photo';
  static const String profileSubmitEditData = 'profile-submit-edit-data';
  static const String profileSubmitEditPhoto = 'profile-submit-edit-photo';
  static const String profileSubmitEditPhone = 'profile-submit-edit-phone';
  static const String profileClickFavourites = 'profile-click-favourites';
  static const String profileClickQrCode = 'profile-click-qrcode';
  static const String profileClickBookingHistory =
      'profile-click-bookinghistory';
  static const String profileClickIssue = 'profile-click-issue';
  static const String profileClickPayments = 'profile-click-payments';
  static const String profileChangeLanguage = 'profile-change-language';
  static const String profileChangeTheme = 'profile-change-theme';
  static const String profileOnNotifications = 'profile-on-notifications';
  static const String profileOffNotifications = 'profile-off-notifications';
  static const String profileClickLogout = 'profile-click-logout';
  static const String profileClickConfirmLogout =
      'profile-click-confirm-logout';
  static const String profileClickCancelLogout = 'profile-click-cancel-logout';
  static const String profileClickDeleteAccount = 'profile-click-deleteaccount';
  static const String profileClickConfirmDeleteAccount =
      'profile-click-confirm-deleteaccount';
  static const String profileClickCancelDeleteAccount =
      'profile-click-cancel-deleteaccount';

  // QR Code Page
  static const String qrCodeClickBack = 'qrcode-click-back';
  static const String qrCodeScan = 'qrcode-scan';

  // Coupon QR Code Page
  static const String couponQrCodeBack = 'coupon-qrcode-back';
  static const String couponQrCodeDetailsBack = 'coupon-qrcode-details-back';
  static const String couponQrCodeClickDetails = 'coupon-qrcode-click-details';
  static const String couponQrCodeScratch = 'coupon-qrcode-scratch';
  static const String couponQrCodeCopy = 'coupon-qrcode-copy';

  // Booking History Page
  static const String bookingHistoryClickBooking =
      'bookinghistory-click-booking';
  static const String bookingHistoryClickBack = 'bookinghistory-click-back';

  // Issue Page
  static const String issueClickBack = 'issue-click-back';
  static const String issueClickDetails = 'issue-click-details';
  static const String issueSubmit = 'issue-submit';

  // Payment Page
  static const String paymentsClickBack = 'payments-click-back';
  static const String paymentsClickFilter = 'payments-click-filter';
  static const String paymentsClickPay = 'payments-click-pay';

  // Payment Method Page
  static const String paymentMethodsClickBack = 'paymentmethods-click-back';
  static const String paymentMethodsClickWallet = 'paymentmethods-click-wallet';
  static const String paymentMethodsClickCard = 'paymentmethods-click-card';
  static const String paymentMethodsClickInstallment =
      'paymentmethods-click-installment';
  static const String paymentMethodsClickPaymentMethod =
      'paymentmethods-click-paymentmethod';

  // Brand Page
  static const String brandClickBack = 'brand-click-back';
  static const String brandClickShare = 'brand-click-share';
  static const String brandClickReport = 'brand-click-report';
  static const String brandSubmitReport = 'brand-submit-report';
  static const String brandClickBranches = 'brand-click-branches';
  static const String brandClickBranchGoMap = 'brand-click-branch-go-map';
  static const String brandClickChat = 'brand-click-chat';
  static const String brandClickShowServices = 'brand-click-showservices';
  static const String brandClickShowBranchServices =
      'brand-click-showbranchservices';
  static const String brandClickTabPhotos = 'brand-click-tab-photos';
  static const String brandClickTabVideos = 'brand-click-tab-videos';
  static const String brandClickTabReviews = 'brand-click-tab-reviews';
  static const String brandClickMedia = 'brand-click-media';
  static const String brandMediaClickBack = 'brand-media-click-back';
  static const String brandMediaClickBrand = 'brand-media-click-brand';
  static const String brandMediaClickChat = 'brand-media-click-chat';
  static const String brandMediaClickReport = 'brand-media-click-report';
  static const String brandMediaSubmitReport = 'brand-media-submit-report';
  static const String brandMediaClickBook = 'brand-media-click-book';
  static const String brandMediaClickComments = 'brand-media-click-comments';

  // Services Page
  static const String servicesClickBack = 'services-click-back';
  static const String servicesClickCategory = 'services-click-category';
  static const String servicesClickService = 'services-click-service';
  static const String servicesClickBook = 'services-click-book';

  // Service Details Page
  static const String serviceDetailsClickBack = 'servicedetails-click-back';
  static const String serviceDetailsClickAddFavourite =
      'servicedetails-click-add-favourite';
  static const String serviceDetailsClickRemoveFavourite =
      'servicedetails-click-remove-favourite';
  static const String serviceDetailsClickService =
      'servicedetails-click-service';
  static const String serviceDetailsClickBook = 'servicedetails-click-book';
  static const String serviceDetailsClickBrand = 'servicedetails-click-brand';
  static const String serviceDetailsClickAllReviews =
      'servicedetails-click-allreviews';
  static const String serviceDetailsClickShare = 'servicedetails-click-share';
  static const String serviceDetailsClickReport = 'servicedetails-click-report';
  static const String serviceDetailsSubmitReport =
      'servicedetails-submit-report';

  // All Reviews Page
  static const String allReviewsClickBack = 'allreviews-click-back';

  // Calendar Page
  static const String calendarClickBack = 'calendar-click-back';
  static const String calendarClickDate = 'calendar-click-date';
  static const String calendarClickTime = 'calendar-click-time';
  static const String calendarClickProceed = 'calendar-click-proceed';
  static const String calendarSelectDate = 'calendar-select-date';
  static const String calendarSelectTime = 'calendar-select-time';
  static const String calendarAgreeTerms = 'calendar-agree-terms';
  static const String calendarCancelTerms = 'calendar-cancel-terms';

  // Confirmation Booking Page
  static const String confirmationClickBackHome =
      'confirmation-click-back-home';
  static const String confirmationClickAgree = 'confirmation-click-agree';
  static const String confirmationClickCancel = 'confirmation-click-cancel';
  static const String confirmationBookingClickBack =
      'confirmtionbooking-click-back';
  static const String confirmationBookingClickInBranch =
      'confirmtionbooking-click-inbranch';
  static const String confirmationBookingClickBranchLocation =
      'confirmtionbooking-click-branchlocation';
  static const String confirmationBookingClickOutBranch =
      'confirmtionbooking-click-outbranch';
  static const String confirmationBookingClickSelectGovernorate =
      'confirmtionbooking-click-selectgovernorate';
  static const String confirmationBookingClickSelectLocation =
      'confirmtionbooking-click-selectlocation';
  static const String confirmationBookingClickConfirmLocation =
      'confirmtionbooking-click-confirmelocation';
  static const String confirmationBookingAddNotes =
      'confirmtionbooking-add-notes';
  static const String confirmationBookingRemoveNotes =
      'confirmtionbooking-remove-notes';
  static const String confirmationBookingAddCoupon =
      'confirmtionbooking-add-coupone';
  static const String confirmationBookingRemoveCoupon =
      'confirmtionbooking-remove-coupone';
  static const String confirmationBookingSubmitBooking =
      'confirmtionbooking-submit-booking';
  static const String confirmationBookingClick12hGoToHome =
      'confirmtionbooking-click-12h-gotohome';

  // Booking Status Page
  static const String bookingStatusClickBack = 'bookingstatus-click-back';
  static const String bookingStatusClickViewLocation =
      'bookingstatus-click-view-location';
  static const String bookingStatusClickCancel = 'bookingstatus-click-cancel';
  static const String bookingStatusClickCancelCancel =
      'bookingstatus-click-cancel-cancel';
  static const String bookingStatusClickAgreeCancel =
      'bookingstatus-click-agree-cancel';
  static const String bookingStatusSwipeArrive = 'bookingstatus-swipe-arrive';
  static const String bookingStatusClickPay = 'bookingstatus-click-pay';
}
