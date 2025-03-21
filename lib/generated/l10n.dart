// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Dazzify`
  String get appName {
    return Intl.message(
      'Dazzify',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get authScreenTitle {
    return Intl.message(
      'Please enter your phone number',
      name: 'authScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Verify phone number`
  String get authVerifyButtonTitle {
    return Intl.message(
      'Verify phone number',
      name: 'authVerifyButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `OTP Code Sent Successfully.`
  String get sendOtpSuccess {
    return Intl.message(
      'OTP Code Sent Successfully.',
      name: 'sendOtpSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't Send OTP Code.`
  String get sendOtpError {
    return Intl.message(
      'Couldn\'t Send OTP Code.',
      name: 'sendOtpError',
      desc: '',
      args: [],
    );
  }

  /// `Please verify your phone number`
  String get otpScreenTitle {
    return Intl.message(
      'Please verify your phone number',
      name: 'otpScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get otpVerifyButtonTitle {
    return Intl.message(
      'Verify',
      name: 'otpVerifyButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add Your Information`
  String get userInfoScreenTitle {
    return Intl.message(
      'Add Your Information',
      name: 'userInfoScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `age`
  String get age {
    return Intl.message(
      'age',
      name: 'age',
      desc: '',
      args: [],
    );
  }

  /// `Dazzify’s Terms & Conditions.`
  String get termsSheetTitle {
    return Intl.message(
      'Dazzify’s Terms & Conditions.',
      name: 'termsSheetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get services {
    return Intl.message(
      'Services',
      name: 'services',
      desc: '',
      args: [],
    );
  }

  /// `Top Rated Brands`
  String get topRated {
    return Intl.message(
      'Top Rated Brands',
      name: 'topRated',
      desc: '',
      args: [],
    );
  }

  /// `Popular Services`
  String get popularServices {
    return Intl.message(
      'Popular Services',
      name: 'popularServices',
      desc: '',
      args: [],
    );
  }

  /// `All Services`
  String get allServices {
    return Intl.message(
      'All Services',
      name: 'allServices',
      desc: '',
      args: [],
    );
  }

  /// `Service Details`
  String get serviceDetails {
    return Intl.message(
      'Service Details',
      name: 'serviceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Book Service`
  String get bookService {
    return Intl.message(
      'Book Service',
      name: 'bookService',
      desc: '',
      args: [],
    );
  }

  /// `About Service`
  String get aboutService {
    return Intl.message(
      'About Service',
      name: 'aboutService',
      desc: '',
      args: [],
    );
  }

  /// `Google Maps Location`
  String get googleMapsLocation {
    return Intl.message(
      'Google Maps Location',
      name: 'googleMapsLocation',
      desc: '',
      args: [],
    );
  }

  /// `Rate this `
  String get rateTitle {
    return Intl.message(
      'Rate this ',
      name: 'rateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tell others what you think`
  String get rateSubtitle {
    return Intl.message(
      'Tell others what you think',
      name: 'rateSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Rating and Reviews`
  String get ratingAndReviewsTitle {
    return Intl.message(
      'Rating and Reviews',
      name: 'ratingAndReviewsTitle',
      desc: '',
      args: [],
    );
  }

  /// `See what others think about this`
  String get ratingAndReviewsSubTitle {
    return Intl.message(
      'See what others think about this',
      name: 'ratingAndReviewsSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `See All Reviews`
  String get seeAllReviews {
    return Intl.message(
      'See All Reviews',
      name: 'seeAllReviews',
      desc: '',
      args: [],
    );
  }

  /// `More Like`
  String get moreLike {
    return Intl.message(
      'More Like',
      name: 'moreLike',
      desc: '',
      args: [],
    );
  }

  /// `All Reviews`
  String get allReviews {
    return Intl.message(
      'All Reviews',
      name: 'allReviews',
      desc: '',
      args: [],
    );
  }

  /// `Original sound`
  String get originalSound {
    return Intl.message(
      'Original sound',
      name: 'originalSound',
      desc: '',
      args: [],
    );
  }

  /// `No Bookings`
  String get noBookings {
    return Intl.message(
      'No Bookings',
      name: 'noBookings',
      desc: '',
      args: [],
    );
  }

  /// `Booking`
  String get booking {
    return Intl.message(
      'Booking',
      name: 'booking',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Booking`
  String get cancelBooking {
    return Intl.message(
      'Cancel Booking',
      name: 'cancelBooking',
      desc: '',
      args: [],
    );
  }

  /// `No Reels, try again later`
  String get noReels {
    return Intl.message(
      'No Reels, try again later',
      name: 'noReels',
      desc: '',
      args: [],
    );
  }

  /// `Add profile picture`
  String get addPic {
    return Intl.message(
      'Add profile picture',
      name: 'addPic',
      desc: '',
      args: [],
    );
  }

  /// `Take a Picture`
  String get takePic {
    return Intl.message(
      'Take a Picture',
      name: 'takePic',
      desc: '',
      args: [],
    );
  }

  /// `From Gallery`
  String get fromGallery {
    return Intl.message(
      'From Gallery',
      name: 'fromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Info Update`
  String get infoUpdate {
    return Intl.message(
      'Info Update',
      name: 'infoUpdate',
      desc: '',
      args: [],
    );
  }

  /// `User Settings`
  String get userSettings {
    return Intl.message(
      'User Settings',
      name: 'userSettings',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get myProfile {
    return Intl.message(
      'My Profile',
      name: 'myProfile',
      desc: '',
      args: [],
    );
  }

  /// `Services Settings`
  String get servicesSettings {
    return Intl.message(
      'Services Settings',
      name: 'servicesSettings',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Booking status`
  String get bookingStatus {
    return Intl.message(
      'Booking status',
      name: 'bookingStatus',
      desc: '',
      args: [],
    );
  }

  /// `My Favorite`
  String get myFavorite {
    return Intl.message(
      'My Favorite',
      name: 'myFavorite',
      desc: '',
      args: [],
    );
  }

  /// `Issue`
  String get issue {
    return Intl.message(
      'Issue',
      name: 'issue',
      desc: '',
      args: [],
    );
  }

  /// `Your Issue Was Created Successfully`
  String get issueCreated {
    return Intl.message(
      'Your Issue Was Created Successfully',
      name: 'issueCreated',
      desc: '',
      args: [],
    );
  }

  /// `Issue Reply`
  String get issueReply {
    return Intl.message(
      'Issue Reply',
      name: 'issueReply',
      desc: '',
      args: [],
    );
  }

  /// `Issue Status`
  String get issueStatus {
    return Intl.message(
      'Issue Status',
      name: 'issueStatus',
      desc: '',
      args: [],
    );
  }

  /// `No Issues Yet`
  String get noIssues {
    return Intl.message(
      'No Issues Yet',
      name: 'noIssues',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Progress`
  String get progress {
    return Intl.message(
      'Progress',
      name: 'progress',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get accepted {
    return Intl.message(
      'Accepted',
      name: 'accepted',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get rejected {
    return Intl.message(
      'Rejected',
      name: 'rejected',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get canceled {
    return Intl.message(
      'Canceled',
      name: 'canceled',
      desc: '',
      args: [],
    );
  }

  /// `Step 1`
  String get step1 {
    return Intl.message(
      'Step 1',
      name: 'step1',
      desc: '',
      args: [],
    );
  }

  /// `Step 2`
  String get step2 {
    return Intl.message(
      'Step 2',
      name: 'step2',
      desc: '',
      args: [],
    );
  }

  /// `Step 3`
  String get step3 {
    return Intl.message(
      'Step 3',
      name: 'step3',
      desc: '',
      args: [],
    );
  }

  /// `Issue Pending`
  String get issuePending {
    return Intl.message(
      'Issue Pending',
      name: 'issuePending',
      desc: '',
      args: [],
    );
  }

  /// `your issue is pending please wait`
  String get yourIssuePending {
    return Intl.message(
      'your issue is pending please wait',
      name: 'yourIssuePending',
      desc: '',
      args: [],
    );
  }

  /// `Issue in Progress`
  String get issueProgress {
    return Intl.message(
      'Issue in Progress',
      name: 'issueProgress',
      desc: '',
      args: [],
    );
  }

  /// `We appreciate your understanding\nas we work to find a solution.`
  String get yourIssueProgress {
    return Intl.message(
      'We appreciate your understanding\nas we work to find a solution.',
      name: 'yourIssueProgress',
      desc: '',
      args: [],
    );
  }

  /// `Issue checked this is\nthe answer of our team`
  String get issueChecked {
    return Intl.message(
      'Issue checked this is\nthe answer of our team',
      name: 'issueChecked',
      desc: '',
      args: [],
    );
  }

  /// `Dazzify’s points`
  String get dazzifyPoints {
    return Intl.message(
      'Dazzify’s points',
      name: 'dazzifyPoints',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `App Settings`
  String get appSettings {
    return Intl.message(
      'App Settings',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get dazzifyTheme {
    return Intl.message(
      'Theme',
      name: 'dazzifyTheme',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account ?`
  String get deleteAccountMessage {
    return Intl.message(
      'Are you sure you want to delete your account ?',
      name: 'deleteAccountMessage',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message(
      'Log Out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out of your account ?`
  String get logOutMessage {
    return Intl.message(
      'Are you sure you want to log out of your account ?',
      name: 'logOutMessage',
      desc: '',
      args: [],
    );
  }

  /// `Choose Your Preferred Language`
  String get chooseLanguage {
    return Intl.message(
      'Choose Your Preferred Language',
      name: 'chooseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Change Phone Number`
  String get changePhoneNumber {
    return Intl.message(
      'Change Phone Number',
      name: 'changePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Update Phone Number`
  String get updatePhoneNumber {
    return Intl.message(
      'Update Phone Number',
      name: 'updatePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Verify Phone Number`
  String get verifyPhoneNumber {
    return Intl.message(
      'Verify Phone Number',
      name: 'verifyPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Select Your Booking Then Add\nA Comment About It`
  String get selectAndAddComment {
    return Intl.message(
      'Select Your Booking Then Add\nA Comment About It',
      name: 'selectAndAddComment',
      desc: '',
      args: [],
    );
  }

  /// `Your comment`
  String get yourComment {
    return Intl.message(
      'Your comment',
      name: 'yourComment',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Create Issue`
  String get createIssue {
    return Intl.message(
      'Create Issue',
      name: 'createIssue',
      desc: '',
      args: [],
    );
  }

  /// `All Packages`
  String get allPackagesTab {
    return Intl.message(
      'All Packages',
      name: 'allPackagesTab',
      desc: '',
      args: [],
    );
  }

  /// `Collections`
  String get collectionsTab {
    return Intl.message(
      'Collections',
      name: 'collectionsTab',
      desc: '',
      args: [],
    );
  }

  /// `Makeup Vendor accepted your request please keep in touch with him`
  String get notificationMessage {
    return Intl.message(
      'Makeup Vendor accepted your request please keep in touch with him',
      name: 'notificationMessage',
      desc: '',
      args: [],
    );
  }

  /// `11:50 am`
  String get notificationTime {
    return Intl.message(
      '11:50 am',
      name: 'notificationTime',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `There are no media items now, try again later.`
  String get noMedia {
    return Intl.message(
      'There are no media items now, try again later.',
      name: 'noMedia',
      desc: '',
      args: [],
    );
  }

  /// `There are no results matching your input`
  String get noSearchResult {
    return Intl.message(
      'There are no results matching your input',
      name: 'noSearchResult',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get conversationsAppBarTitle {
    return Intl.message(
      'Chats',
      name: 'conversationsAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `is required`
  String get textIsRequired {
    return Intl.message(
      'is required',
      name: 'textIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `is too short`
  String get textIsTooShort {
    return Intl.message(
      'is too short',
      name: 'textIsTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Phone Number`
  String get invalidPhoneNumber {
    return Intl.message(
      'Invalid Phone Number',
      name: 'invalidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `You can't use your old phone number`
  String get newPhoneNumberError {
    return Intl.message(
      'You can\'t use your old phone number',
      name: 'newPhoneNumberError',
      desc: '',
      args: [],
    );
  }

  /// `There was an error, try again later.`
  String get unknownError {
    return Intl.message(
      'There was an error, try again later.',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid email.`
  String get notValidEmail {
    return Intl.message(
      'Not a valid email.',
      name: 'notValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message(
      'Continue',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `YES`
  String get yes {
    return Intl.message(
      'YES',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get agree {
    return Intl.message(
      'Agree',
      name: 'agree',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `ُEGP`
  String get currency {
    return Intl.message(
      'ُEGP',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `Arrived at time`
  String get arrivedAtTime {
    return Intl.message(
      'Arrived at time',
      name: 'arrivedAtTime',
      desc: '',
      args: [],
    );
  }

  /// `Arrived Late`
  String get arrivedLate {
    return Intl.message(
      'Arrived Late',
      name: 'arrivedLate',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `العربية`
  String get arabic {
    return Intl.message(
      'العربية',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `My Wallet`
  String get myWallet {
    return Intl.message(
      'My Wallet',
      name: 'myWallet',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Bookings`
  String get bookings {
    return Intl.message(
      'Bookings',
      name: 'bookings',
      desc: '',
      args: [],
    );
  }

  /// `Your available balance`
  String get availableBalance {
    return Intl.message(
      'Your available balance',
      name: 'availableBalance',
      desc: '',
      args: [],
    );
  }

  /// `EGP`
  String get egp {
    return Intl.message(
      'EGP',
      name: 'egp',
      desc: '',
      args: [],
    );
  }

  /// `Add to your balance`
  String get addToBalance {
    return Intl.message(
      'Add to your balance',
      name: 'addToBalance',
      desc: '',
      args: [],
    );
  }

  /// `Pay Service`
  String get payService {
    return Intl.message(
      'Pay Service',
      name: 'payService',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message(
      'Payment',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `E-Wallet`
  String get eWallet {
    return Intl.message(
      'E-Wallet',
      name: 'eWallet',
      desc: '',
      args: [],
    );
  }

  /// `Card`
  String get card {
    return Intl.message(
      'Card',
      name: 'card',
      desc: '',
      args: [],
    );
  }

  /// `Installment`
  String get installment {
    return Intl.message(
      'Installment',
      name: 'installment',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone {
    return Intl.message(
      'Phone Number',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Credit card`
  String get creditCard {
    return Intl.message(
      'Credit card',
      name: 'creditCard',
      desc: '',
      args: [],
    );
  }

  /// `next`
  String get next {
    return Intl.message(
      'next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `card Holder Name`
  String get cardHolderName {
    return Intl.message(
      'card Holder Name',
      name: 'cardHolderName',
      desc: '',
      args: [],
    );
  }

  /// `cvc`
  String get cvc {
    return Intl.message(
      'cvc',
      name: 'cvc',
      desc: '',
      args: [],
    );
  }

  /// `MM/YY`
  String get expire {
    return Intl.message(
      'MM/YY',
      name: 'expire',
      desc: '',
      args: [],
    );
  }

  /// `Dazzify installment`
  String get dazzifyInstallment {
    return Intl.message(
      'Dazzify installment',
      name: 'dazzifyInstallment',
      desc: '',
      args: [],
    );
  }

  /// `Aman`
  String get amanInstallment {
    return Intl.message(
      'Aman',
      name: 'amanInstallment',
      desc: '',
      args: [],
    );
  }

  /// `Value`
  String get valueInstallment {
    return Intl.message(
      'Value',
      name: 'valueInstallment',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contactInstallment {
    return Intl.message(
      'Contact',
      name: 'contactInstallment',
      desc: '',
      args: [],
    );
  }

  /// `Sympl`
  String get symplInstallment {
    return Intl.message(
      'Sympl',
      name: 'symplInstallment',
      desc: '',
      args: [],
    );
  }

  /// `Bank`
  String get bankInstallment {
    return Intl.message(
      'Bank',
      name: 'bankInstallment',
      desc: '',
      args: [],
    );
  }

  /// `Souhoola`
  String get souhoolaInstallment {
    return Intl.message(
      'Souhoola',
      name: 'souhoolaInstallment',
      desc: '',
      args: [],
    );
  }

  /// `Forsa`
  String get forsaInstallment {
    return Intl.message(
      'Forsa',
      name: 'forsaInstallment',
      desc: '',
      args: [],
    );
  }

  /// `NowPay`
  String get nowPayInstallment {
    return Intl.message(
      'NowPay',
      name: 'nowPayInstallment',
      desc: '',
      args: [],
    );
  }

  /// `Halan`
  String get halanInstallment {
    return Intl.message(
      'Halan',
      name: 'halanInstallment',
      desc: '',
      args: [],
    );
  }

  /// `6 months`
  String get months6 {
    return Intl.message(
      '6 months',
      name: 'months6',
      desc: '',
      args: [],
    );
  }

  /// `12 months`
  String get months12 {
    return Intl.message(
      '12 months',
      name: 'months12',
      desc: '',
      args: [],
    );
  }

  /// `24 months`
  String get months24 {
    return Intl.message(
      '24 months',
      name: 'months24',
      desc: '',
      args: [],
    );
  }

  /// `36 months`
  String get months36 {
    return Intl.message(
      '36 months',
      name: 'months36',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Payment`
  String get confirmPayment {
    return Intl.message(
      'Confirm Payment',
      name: 'confirmPayment',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get pay {
    return Intl.message(
      'Pay',
      name: 'pay',
      desc: '',
      args: [],
    );
  }

  /// `Choose installment period`
  String get choosePeriod {
    return Intl.message(
      'Choose installment period',
      name: 'choosePeriod',
      desc: '',
      args: [],
    );
  }

  /// `Installment Details`
  String get installmentDetails {
    return Intl.message(
      'Installment Details',
      name: 'installmentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Payment Confirmation`
  String get paymentConfirmation {
    return Intl.message(
      'Payment Confirmation',
      name: 'paymentConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Back To Wallet`
  String get backToWallet {
    return Intl.message(
      'Back To Wallet',
      name: 'backToWallet',
      desc: '',
      args: [],
    );
  }

  /// `Add New Visa`
  String get addNewVisa {
    return Intl.message(
      'Add New Visa',
      name: 'addNewVisa',
      desc: '',
      args: [],
    );
  }

  /// `Your Points`
  String get yourPoints {
    return Intl.message(
      'Your Points',
      name: 'yourPoints',
      desc: '',
      args: [],
    );
  }

  /// `Earn\nPoints`
  String get earnPoints {
    return Intl.message(
      'Earn\nPoints',
      name: 'earnPoints',
      desc: '',
      args: [],
    );
  }

  /// `Redeem\nPoints`
  String get redeemPoints {
    return Intl.message(
      'Redeem\nPoints',
      name: 'redeemPoints',
      desc: '',
      args: [],
    );
  }

  /// `"Use your points towards exclusive offers and limited-edition services."`
  String get pointsStatement {
    return Intl.message(
      '"Use your points towards exclusive offers and limited-edition services."',
      name: 'pointsStatement',
      desc: '',
      args: [],
    );
  }

  /// `Redeem it`
  String get redeemIt {
    return Intl.message(
      'Redeem it',
      name: 'redeemIt',
      desc: '',
      args: [],
    );
  }

  /// ` Points`
  String get point {
    return Intl.message(
      ' Points',
      name: 'point',
      desc: '',
      args: [],
    );
  }

  /// `Bookings History`
  String get bookingsHistory {
    return Intl.message(
      'Bookings History',
      name: 'bookingsHistory',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Earned`
  String get earned {
    return Intl.message(
      'Earned',
      name: 'earned',
      desc: '',
      args: [],
    );
  }

  /// `Spent`
  String get spent {
    return Intl.message(
      'Spent',
      name: 'spent',
      desc: '',
      args: [],
    );
  }

  /// `Woohoo! You've hit the points target! Go ahead and grab your reward`
  String get pointsStatement2 {
    return Intl.message(
      'Woohoo! You\'ve hit the points target! Go ahead and grab your reward',
      name: 'pointsStatement2',
      desc: '',
      args: [],
    );
  }

  /// `Reach 4000 points and treat yourself to this amazing service!`
  String get pointsStatement3 {
    return Intl.message(
      'Reach 4000 points and treat yourself to this amazing service!',
      name: 'pointsStatement3',
      desc: '',
      args: [],
    );
  }

  /// `Booking Date`
  String get bookingDate {
    return Intl.message(
      'Booking Date',
      name: 'bookingDate',
      desc: '',
      args: [],
    );
  }

  /// `Service added to your wallet`
  String get serviceAdded {
    return Intl.message(
      'Service added to your wallet',
      name: 'serviceAdded',
      desc: '',
      args: [],
    );
  }

  /// `Service added to your favorites`
  String get serviceFavoriteAdding {
    return Intl.message(
      'Service added to your favorites',
      name: 'serviceFavoriteAdding',
      desc: '',
      args: [],
    );
  }

  /// `Service removed from your favorites`
  String get serviceFavoriteRemoving {
    return Intl.message(
      'Service removed from your favorites',
      name: 'serviceFavoriteRemoving',
      desc: '',
      args: [],
    );
  }

  /// `No Data, try again later`
  String get noData {
    return Intl.message(
      'No Data, try again later',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get posts {
    return Intl.message(
      'Posts',
      name: 'posts',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `There is no comments yet.`
  String get commentsEmpty {
    return Intl.message(
      'There is no comments yet.',
      name: 'commentsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Like`
  String get like {
    return Intl.message(
      'Like',
      name: 'like',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get likes {
    return Intl.message(
      'Likes',
      name: 'likes',
      desc: '',
      args: [],
    );
  }

  /// `Write a comment`
  String get commentsTextFieldHint {
    return Intl.message(
      'Write a comment',
      name: 'commentsTextFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to Delete this Comment ?`
  String get deleteCommentConfirmation {
    return Intl.message(
      'Are you sure you want to Delete this Comment ?',
      name: 'deleteCommentConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Delete comment`
  String get deleteComment {
    return Intl.message(
      'Delete comment',
      name: 'deleteComment',
      desc: '',
      args: [],
    );
  }

  /// `Edit comment`
  String get editComment {
    return Intl.message(
      'Edit comment',
      name: 'editComment',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Edited`
  String get edited {
    return Intl.message(
      'Edited',
      name: 'edited',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to Delete this Review ?`
  String get deleteReview {
    return Intl.message(
      'Are you sure you want to Delete this Review ?',
      name: 'deleteReview',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get reply {
    return Intl.message(
      'Reply',
      name: 'reply',
      desc: '',
      args: [],
    );
  }

  /// `There is No Vendors in This Section at the moment`
  String get noVendors {
    return Intl.message(
      'There is No Vendors in This Section at the moment',
      name: 'noVendors',
      desc: '',
      args: [],
    );
  }

  /// `Rate`
  String get rate {
    return Intl.message(
      'Rate',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `View Branches`
  String get viewBranches {
    return Intl.message(
      'View Branches',
      name: 'viewBranches',
      desc: '',
      args: [],
    );
  }

  /// `Book`
  String get book {
    return Intl.message(
      'Book',
      name: 'book',
      desc: '',
      args: [],
    );
  }

  /// `Branches`
  String get branches {
    return Intl.message(
      'Branches',
      name: 'branches',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get brandCategories {
    return Intl.message(
      'Categories',
      name: 'brandCategories',
      desc: '',
      args: [],
    );
  }

  /// `No Categories Found`
  String get noCategories {
    return Intl.message(
      'No Categories Found',
      name: 'noCategories',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get brandServices {
    return Intl.message(
      'Services',
      name: 'brandServices',
      desc: '',
      args: [],
    );
  }

  /// `No Services Found`
  String get noServices {
    return Intl.message(
      'No Services Found',
      name: 'noServices',
      desc: '',
      args: [],
    );
  }

  /// `No Branches Found`
  String get noBranches {
    return Intl.message(
      'No Branches Found',
      name: 'noBranches',
      desc: '',
      args: [],
    );
  }

  /// `Didn't Share Any Images Yet.`
  String get emptyVendorImages {
    return Intl.message(
      'Didn\'t Share Any Images Yet.',
      name: 'emptyVendorImages',
      desc: '',
      args: [],
    );
  }

  /// `Didn't Share Any Reels Yet.`
  String get emptyVendorReels {
    return Intl.message(
      'Didn\'t Share Any Reels Yet.',
      name: 'emptyVendorReels',
      desc: '',
      args: [],
    );
  }

  /// `No Reviews Yet.`
  String get noReviews {
    return Intl.message(
      'No Reviews Yet.',
      name: 'noReviews',
      desc: '',
      args: [],
    );
  }

  /// `Price Range`
  String get priceRange {
    return Intl.message(
      'Price Range',
      name: 'priceRange',
      desc: '',
      args: [],
    );
  }

  /// `No sessions on this day, select another day`
  String get noSessionsToday {
    return Intl.message(
      'No sessions on this day, select another day',
      name: 'noSessionsToday',
      desc: '',
      args: [],
    );
  }

  /// `Click to pick your time`
  String get pickTime {
    return Intl.message(
      'Click to pick your time',
      name: 'pickTime',
      desc: '',
      args: [],
    );
  }

  /// `There are no terms and conditions for this brand`
  String get noBrandTerms {
    return Intl.message(
      'There are no terms and conditions for this brand',
      name: 'noBrandTerms',
      desc: '',
      args: [],
    );
  }

  /// `Service was booked successfully`
  String get serviceBookedSuccessfully {
    return Intl.message(
      'Service was booked successfully',
      name: 'serviceBookedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Proceed`
  String get proceed {
    return Intl.message(
      'Proceed',
      name: 'proceed',
      desc: '',
      args: [],
    );
  }

  /// `There are no available sessions for this vender yet, try again later`
  String get noSessions {
    return Intl.message(
      'There are no available sessions for this vender yet, try again later',
      name: 'noSessions',
      desc: '',
      args: [],
    );
  }

  /// `There are no available sessions for this vender in this month, select another time.`
  String get noMonthSessions {
    return Intl.message(
      'There are no available sessions for this vender in this month, select another time.',
      name: 'noMonthSessions',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationsTitle {
    return Intl.message(
      'Notifications',
      name: 'notificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have to re-enable Notifications\n permissions from settings`
  String get notificationPermissionDialog {
    return Intl.message(
      'You have to re-enable Notifications\n permissions from settings',
      name: 'notificationPermissionDialog',
      desc: '',
      args: [],
    );
  }

  /// `You have to re-enable Gallery\n permissions from settings`
  String get galleryPermissionDialog {
    return Intl.message(
      'You have to re-enable Gallery\n permissions from settings',
      name: 'galleryPermissionDialog',
      desc: '',
      args: [],
    );
  }

  /// `You have to re-enable Location\n permissions from settings`
  String get locationPermissionDialog {
    return Intl.message(
      'You have to re-enable Location\n permissions from settings',
      name: 'locationPermissionDialog',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings`
  String get openSettings {
    return Intl.message(
      'Open Settings',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `There are no notifications for you right now`
  String get noNotifications {
    return Intl.message(
      'There are no notifications for you right now',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Age must be at least 14`
  String get atLeast14 {
    return Intl.message(
      'Age must be at least 14',
      name: 'atLeast14',
      desc: '',
      args: [],
    );
  }

  /// `Your Age Can't Exceed 120 years`
  String get not120 {
    return Intl.message(
      'Your Age Can\'t Exceed 120 years',
      name: 'not120',
      desc: '',
      args: [],
    );
  }

  /// `Update location`
  String get updateLocation {
    return Intl.message(
      'Update location',
      name: 'updateLocation',
      desc: '',
      args: [],
    );
  }

  /// `Confirm location`
  String get confirmLocation {
    return Intl.message(
      'Confirm location',
      name: 'confirmLocation',
      desc: '',
      args: [],
    );
  }

  /// `Your location was updated`
  String get locationUpdated {
    return Intl.message(
      'Your location was updated',
      name: 'locationUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Select Location`
  String get selectLocation {
    return Intl.message(
      'Select Location',
      name: 'selectLocation',
      desc: '',
      args: [],
    );
  }

  /// `View Location`
  String get viewLocation {
    return Intl.message(
      'View Location',
      name: 'viewLocation',
      desc: '',
      args: [],
    );
  }

  /// `Please Select Your Location`
  String get selectYourLocation {
    return Intl.message(
      'Please Select Your Location',
      name: 'selectYourLocation',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `There are no conversations yet, select any vendor to start chatting with`
  String get noConversations {
    return Intl.message(
      'There are no conversations yet, select any vendor to start chatting with',
      name: 'noConversations',
      desc: '',
      args: [],
    );
  }

  /// `In branch`
  String get inBranch {
    return Intl.message(
      'In branch',
      name: 'inBranch',
      desc: '',
      args: [],
    );
  }

  /// `Brand Terms & conditions`
  String get brandTermsSheetTitle {
    return Intl.message(
      'Brand Terms & conditions',
      name: 'brandTermsSheetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message(
      'Duration',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get minutes {
    return Intl.message(
      'minutes',
      name: 'minutes',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Service price`
  String get servicePrice {
    return Intl.message(
      'Service price',
      name: 'servicePrice',
      desc: '',
      args: [],
    );
  }

  /// `Coupon disc`
  String get couponDisc {
    return Intl.message(
      'Coupon disc',
      name: 'couponDisc',
      desc: '',
      args: [],
    );
  }

  /// `Delivery fees`
  String get deliferyFees {
    return Intl.message(
      'Delivery fees',
      name: 'deliferyFees',
      desc: '',
      args: [],
    );
  }

  /// `App fees`
  String get appFees {
    return Intl.message(
      'App fees',
      name: 'appFees',
      desc: '',
      args: [],
    );
  }

  /// `Total price`
  String get totalPrice {
    return Intl.message(
      'Total price',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Out branch`
  String get outBranch {
    return Intl.message(
      'Out branch',
      name: 'outBranch',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Not selected yet`
  String get NotSelectedYet {
    return Intl.message(
      'Not selected yet',
      name: 'NotSelectedYet',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Select your governorate`
  String get selectGovernorate {
    return Intl.message(
      'Select your governorate',
      name: 'selectGovernorate',
      desc: '',
      args: [],
    );
  }

  /// `"The provider will process your request and send a response within 12 hours."`
  String get bookingSuccess {
    return Intl.message(
      '"The provider will process your request and send a response within 12 hours."',
      name: 'bookingSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Back To Brand Profile`
  String get backToBrand {
    return Intl.message(
      'Back To Brand Profile',
      name: 'backToBrand',
      desc: '',
      args: [],
    );
  }

  /// `Back To Service Details`
  String get backToService {
    return Intl.message(
      'Back To Service Details',
      name: 'backToService',
      desc: '',
      args: [],
    );
  }

  /// `From {startTime} to {endTime} On {date}`
  String serviceSelectionConfirmation(
      Object startTime, Object endTime, Object date) {
    return Intl.message(
      'From $startTime to $endTime On $date',
      name: 'serviceSelectionConfirmation',
      desc: '',
      args: [startTime, endTime, date],
    );
  }

  /// `Cairo`
  String get cairo {
    return Intl.message(
      'Cairo',
      name: 'cairo',
      desc: '',
      args: [],
    );
  }

  /// `Alexandria`
  String get alexandria {
    return Intl.message(
      'Alexandria',
      name: 'alexandria',
      desc: '',
      args: [],
    );
  }

  /// `Giza`
  String get giza {
    return Intl.message(
      'Giza',
      name: 'giza',
      desc: '',
      args: [],
    );
  }

  /// `PortSaid`
  String get portSaid {
    return Intl.message(
      'PortSaid',
      name: 'portSaid',
      desc: '',
      args: [],
    );
  }

  /// `Suez`
  String get suez {
    return Intl.message(
      'Suez',
      name: 'suez',
      desc: '',
      args: [],
    );
  }

  /// `Damietta`
  String get damietta {
    return Intl.message(
      'Damietta',
      name: 'damietta',
      desc: '',
      args: [],
    );
  }

  /// `Dakahlia`
  String get dakahlia {
    return Intl.message(
      'Dakahlia',
      name: 'dakahlia',
      desc: '',
      args: [],
    );
  }

  /// `Sharqia`
  String get sharqia {
    return Intl.message(
      'Sharqia',
      name: 'sharqia',
      desc: '',
      args: [],
    );
  }

  /// `Qalyubia`
  String get qalyubia {
    return Intl.message(
      'Qalyubia',
      name: 'qalyubia',
      desc: '',
      args: [],
    );
  }

  /// `KafrElSheikh`
  String get kafrElsheikh {
    return Intl.message(
      'KafrElSheikh',
      name: 'kafrElsheikh',
      desc: '',
      args: [],
    );
  }

  /// `Gharbia`
  String get gharbia {
    return Intl.message(
      'Gharbia',
      name: 'gharbia',
      desc: '',
      args: [],
    );
  }

  /// `Monufia`
  String get monufia {
    return Intl.message(
      'Monufia',
      name: 'monufia',
      desc: '',
      args: [],
    );
  }

  /// `Beheira`
  String get beheira {
    return Intl.message(
      'Beheira',
      name: 'beheira',
      desc: '',
      args: [],
    );
  }

  /// `Ismailia`
  String get ismailia {
    return Intl.message(
      'Ismailia',
      name: 'ismailia',
      desc: '',
      args: [],
    );
  }

  /// `BeniSuef`
  String get benisuef {
    return Intl.message(
      'BeniSuef',
      name: 'benisuef',
      desc: '',
      args: [],
    );
  }

  /// `Fayoum`
  String get fayoum {
    return Intl.message(
      'Fayoum',
      name: 'fayoum',
      desc: '',
      args: [],
    );
  }

  /// `Minya`
  String get minya {
    return Intl.message(
      'Minya',
      name: 'minya',
      desc: '',
      args: [],
    );
  }

  /// `Asyut`
  String get asyut {
    return Intl.message(
      'Asyut',
      name: 'asyut',
      desc: '',
      args: [],
    );
  }

  /// `Sohag`
  String get sohag {
    return Intl.message(
      'Sohag',
      name: 'sohag',
      desc: '',
      args: [],
    );
  }

  /// `Qena`
  String get qena {
    return Intl.message(
      'Qena',
      name: 'qena',
      desc: '',
      args: [],
    );
  }

  /// `Luxor`
  String get luxor {
    return Intl.message(
      'Luxor',
      name: 'luxor',
      desc: '',
      args: [],
    );
  }

  /// `Aswan`
  String get aswan {
    return Intl.message(
      'Aswan',
      name: 'aswan',
      desc: '',
      args: [],
    );
  }

  /// `RedSea`
  String get redSea {
    return Intl.message(
      'RedSea',
      name: 'redSea',
      desc: '',
      args: [],
    );
  }

  /// `NewValley`
  String get newValley {
    return Intl.message(
      'NewValley',
      name: 'newValley',
      desc: '',
      args: [],
    );
  }

  /// `Matruh`
  String get matruh {
    return Intl.message(
      'Matruh',
      name: 'matruh',
      desc: '',
      args: [],
    );
  }

  /// `NorthSinai`
  String get northSinai {
    return Intl.message(
      'NorthSinai',
      name: 'northSinai',
      desc: '',
      args: [],
    );
  }

  /// `SouthSinai`
  String get southSinai {
    return Intl.message(
      'SouthSinai',
      name: 'southSinai',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get days {
    return Intl.message(
      'Days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `D`
  String get daysShortcut {
    return Intl.message(
      'D',
      name: 'daysShortcut',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get hours {
    return Intl.message(
      'Hours',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  /// `H`
  String get hoursShortcut {
    return Intl.message(
      'H',
      name: 'hoursShortcut',
      desc: '',
      args: [],
    );
  }

  /// `Mins`
  String get min {
    return Intl.message(
      'Mins',
      name: 'min',
      desc: '',
      args: [],
    );
  }

  /// `M`
  String get minShortcut {
    return Intl.message(
      'M',
      name: 'minShortcut',
      desc: '',
      args: [],
    );
  }

  /// `And`
  String get and {
    return Intl.message(
      'And',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `This Service Will Start After `
  String get serviceStartTime {
    return Intl.message(
      'This Service Will Start After ',
      name: 'serviceStartTime',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Ready For This Service`
  String get readyForService {
    return Intl.message(
      'Ready For This Service',
      name: 'readyForService',
      desc: '',
      args: [],
    );
  }

  /// `Fees`
  String get fees {
    return Intl.message(
      'Fees',
      name: 'fees',
      desc: '',
      args: [],
    );
  }

  /// `Rate Service`
  String get rateService {
    return Intl.message(
      'Rate Service',
      name: 'rateService',
      desc: '',
      args: [],
    );
  }

  /// `Here We Go`
  String get hereWeGo {
    return Intl.message(
      'Here We Go',
      name: 'hereWeGo',
      desc: '',
      args: [],
    );
  }

  /// `This Booking is`
  String get thisBookingIs {
    return Intl.message(
      'This Booking is',
      name: 'thisBookingIs',
      desc: '',
      args: [],
    );
  }

  /// `Service is Done, Hope you liked it`
  String get serviceDone {
    return Intl.message(
      'Service is Done, Hope you liked it',
      name: 'serviceDone',
      desc: '',
      args: [],
    );
  }

  /// `Swipe`
  String get swipe {
    return Intl.message(
      'Swipe',
      name: 'swipe',
      desc: '',
      args: [],
    );
  }

  /// `"Get Ready! This Button Will Unlock\n1 Hour Before We Start."`
  String get getReadyForService {
    return Intl.message(
      '"Get Ready! This Button Will Unlock\n1 Hour Before We Start."',
      name: 'getReadyForService',
      desc: '',
      args: [],
    );
  }

  /// `Booking Cancelled`
  String get bookingCancelled {
    return Intl.message(
      'Booking Cancelled',
      name: 'bookingCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Reviews are public and include your account info`
  String get reviewConditions {
    return Intl.message(
      'Reviews are public and include your account info',
      name: 'reviewConditions',
      desc: '',
      args: [],
    );
  }

  /// `Describe your opinion`
  String get reviewComment {
    return Intl.message(
      'Describe your opinion',
      name: 'reviewComment',
      desc: '',
      args: [],
    );
  }

  /// `Write a review`
  String get writeReview {
    return Intl.message(
      'Write a review',
      name: 'writeReview',
      desc: '',
      args: [],
    );
  }

  /// `Create Review`
  String get createReview {
    return Intl.message(
      'Create Review',
      name: 'createReview',
      desc: '',
      args: [],
    );
  }

  /// `We Appreciate Your Review`
  String get reviewCreated {
    return Intl.message(
      'We Appreciate Your Review',
      name: 'reviewCreated',
      desc: '',
      args: [],
    );
  }

  /// `Waiting For response`
  String get waitingForResponse {
    return Intl.message(
      'Waiting For response',
      name: 'waitingForResponse',
      desc: '',
      args: [],
    );
  }

  /// `Oooops`
  String get oops {
    return Intl.message(
      'Oooops',
      name: 'oops',
      desc: '',
      args: [],
    );
  }

  /// `Unable to Connect to the Server Check\nYour Internet Connection.`
  String get unableToConnect {
    return Intl.message(
      'Unable to Connect to the Server Check\nYour Internet Connection.',
      name: 'unableToConnect',
      desc: '',
      args: [],
    );
  }

  /// `No Messages Yet.`
  String get noMessagesYet {
    return Intl.message(
      'No Messages Yet.',
      name: 'noMessagesYet',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't find more services like this`
  String get noMoreLikeThis {
    return Intl.message(
      'Couldn\'t find more services like this',
      name: 'noMoreLikeThis',
      desc: '',
      args: [],
    );
  }

  /// `Late time`
  String get lateTime {
    return Intl.message(
      'Late time',
      name: 'lateTime',
      desc: '',
      args: [],
    );
  }

  /// `Includes`
  String get includes {
    return Intl.message(
      'Includes',
      name: 'includes',
      desc: '',
      args: [],
    );
  }

  /// `View on Map`
  String get viewOnMap {
    return Intl.message(
      'View on Map',
      name: 'viewOnMap',
      desc: '',
      args: [],
    );
  }

  /// `Make a Booking To Show Bookings History`
  String get noBookingsYet {
    return Intl.message(
      'Make a Booking To Show Bookings History',
      name: 'noBookingsYet',
      desc: '',
      args: [],
    );
  }

  /// `Favorite Services Will Appear Here`
  String get noFavorites {
    return Intl.message(
      'Favorite Services Will Appear Here',
      name: 'noFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Your Data Updated`
  String get dataUpdated {
    return Intl.message(
      'Your Data Updated',
      name: 'dataUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Popular Brands`
  String get popularBrands {
    return Intl.message(
      'Popular Brands',
      name: 'popularBrands',
      desc: '',
      args: [],
    );
  }

  /// `Top Rated Brands`
  String get topRatedBrands {
    return Intl.message(
      'Top Rated Brands',
      name: 'topRatedBrands',
      desc: '',
      args: [],
    );
  }

  /// `Back Home`
  String get backHome {
    return Intl.message(
      'Back Home',
      name: 'backHome',
      desc: '',
      args: [],
    );
  }

  /// `No messages, send a message.`
  String get noMessages {
    return Intl.message(
      'No messages, send a message.',
      name: 'noMessages',
      desc: '',
      args: [],
    );
  }

  /// `Crop Image`
  String get cropImage {
    return Intl.message(
      'Crop Image',
      name: 'cropImage',
      desc: '',
      args: [],
    );
  }

  /// `Show Less`
  String get less {
    return Intl.message(
      'Show Less',
      name: 'less',
      desc: '',
      args: [],
    );
  }

  /// `Clients`
  String get clients {
    return Intl.message(
      'Clients',
      name: 'clients',
      desc: '',
      args: [],
    );
  }

  /// `Top Rated Services`
  String get topRatedServices {
    return Intl.message(
      'Top Rated Services',
      name: 'topRatedServices',
      desc: '',
      args: [],
    );
  }

  /// `Invalid coupon code.`
  String get couponNotValidated {
    return Intl.message(
      'Invalid coupon code.',
      name: 'couponNotValidated',
      desc: '',
      args: [],
    );
  }

  /// `Discount added by coupon`
  String get couponValidated {
    return Intl.message(
      'Discount added by coupon',
      name: 'couponValidated',
      desc: '',
      args: [],
    );
  }

  /// `You are not connected to internet, try again.`
  String get youAreNotConnectedTryLater {
    return Intl.message(
      'You are not connected to internet, try again.',
      name: 'youAreNotConnectedTryLater',
      desc: '',
      args: [],
    );
  }

  /// `Are You Sure You Want To Cancel This Booking?`
  String get cancelBookingValidation {
    return Intl.message(
      'Are You Sure You Want To Cancel This Booking?',
      name: 'cancelBookingValidation',
      desc: '',
      args: [],
    );
  }

  /// `Code copied to clipboard`
  String get couponCopied {
    return Intl.message(
      'Code copied to clipboard',
      name: 'couponCopied',
      desc: '',
      args: [],
    );
  }

  /// `Show replies`
  String get showReplies {
    return Intl.message(
      'Show replies',
      name: 'showReplies',
      desc: '',
      args: [],
    );
  }

  /// `Replies`
  String get replies {
    return Intl.message(
      'Replies',
      name: 'replies',
      desc: '',
      args: [],
    );
  }

  /// `Write a reply`
  String get writeReply {
    return Intl.message(
      'Write a reply',
      name: 'writeReply',
      desc: '',
      args: [],
    );
  }

  /// `Transaction`
  String get transaction {
    return Intl.message(
      'Transaction',
      name: 'transaction',
      desc: '',
      args: [],
    );
  }

  /// `Down Payment`
  String get downPayment {
    return Intl.message(
      'Down Payment',
      name: 'downPayment',
      desc: '',
      args: [],
    );
  }

  /// `Last Payment`
  String get lastPayment {
    return Intl.message(
      'Last Payment',
      name: 'lastPayment',
      desc: '',
      args: [],
    );
  }

  /// `Expiration Date`
  String get expirationDate {
    return Intl.message(
      'Expiration Date',
      name: 'expirationDate',
      desc: '',
      args: [],
    );
  }

  /// `Paid Amount`
  String get paidAmount {
    return Intl.message(
      'Paid Amount',
      name: 'paidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Refund Amount`
  String get refundAmount {
    return Intl.message(
      'Refund Amount',
      name: 'refundAmount',
      desc: '',
      args: [],
    );
  }

  /// `Refund`
  String get refund {
    return Intl.message(
      'Refund',
      name: 'refund',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get none {
    return Intl.message(
      'None',
      name: 'none',
      desc: '',
      args: [],
    );
  }

  /// `Not Paid`
  String get notPaid {
    return Intl.message(
      'Not Paid',
      name: 'notPaid',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paid {
    return Intl.message(
      'Paid',
      name: 'paid',
      desc: '',
      args: [],
    );
  }

  /// `Refunded`
  String get refunded {
    return Intl.message(
      'Refunded',
      name: 'refunded',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message(
      'Cancelled',
      name: 'cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Vodafone Cash`
  String get vodafoneCash {
    return Intl.message(
      'Vodafone Cash',
      name: 'vodafoneCash',
      desc: '',
      args: [],
    );
  }

  /// `Etisalat Cash`
  String get etisalatCash {
    return Intl.message(
      'Etisalat Cash',
      name: 'etisalatCash',
      desc: '',
      args: [],
    );
  }

  /// `We Pay`
  String get wePay {
    return Intl.message(
      'We Pay',
      name: 'wePay',
      desc: '',
      args: [],
    );
  }

  /// `Orange Cash`
  String get orangeCash {
    return Intl.message(
      'Orange Cash',
      name: 'orangeCash',
      desc: '',
      args: [],
    );
  }

  /// `Other Wallets`
  String get otherWallets {
    return Intl.message(
      'Other Wallets',
      name: 'otherWallets',
      desc: '',
      args: [],
    );
  }

  /// `Visa Card`
  String get visaCard {
    return Intl.message(
      'Visa Card',
      name: 'visaCard',
      desc: '',
      args: [],
    );
  }

  /// `Master Card`
  String get masterCard {
    return Intl.message(
      'Master Card',
      name: 'masterCard',
      desc: '',
      args: [],
    );
  }

  /// `Premium Card`
  String get premiumCard {
    return Intl.message(
      'Premium Card',
      name: 'premiumCard',
      desc: '',
      args: [],
    );
  }

  /// `There is No Transactions.`
  String get noTransactions {
    return Intl.message(
      'There is No Transactions.',
      name: 'noTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Service Booked`
  String get serviceBooked {
    return Intl.message(
      'Service Booked',
      name: 'serviceBooked',
      desc: '',
      args: [],
    );
  }

  /// `{count} Service Selected`
  String countServiceSelected(Object count) {
    return Intl.message(
      '$count Service Selected',
      name: 'countServiceSelected',
      desc: '',
      args: [count],
    );
  }

  /// `Select Date`
  String get selectDate {
    return Intl.message(
      'Select Date',
      name: 'selectDate',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP`
  String get resendOtp {
    return Intl.message(
      'Resend OTP',
      name: 'resendOtp',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive OTP ?`
  String get noOtpCode {
    return Intl.message(
      'Didn\'t receive OTP ?',
      name: 'noOtpCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP in`
  String get resendOtpIn {
    return Intl.message(
      'Resend OTP in',
      name: 'resendOtpIn',
      desc: '',
      args: [],
    );
  }

  /// `Add To Favorite`
  String get addToFavorite {
    return Intl.message(
      'Add To Favorite',
      name: 'addToFavorite',
      desc: '',
      args: [],
    );
  }

  /// `Review Created Successfully`
  String get reviewCreatedSuccessfully {
    return Intl.message(
      'Review Created Successfully',
      name: 'reviewCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Arrived`
  String get arrived {
    return Intl.message(
      'Arrived',
      name: 'arrived',
      desc: '',
      args: [],
    );
  }

  /// `Enter New Phone Number`
  String get enterNewPhoneNumber {
    return Intl.message(
      'Enter New Phone Number',
      name: 'enterNewPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number Changed Successfully`
  String get phoneNumberChangedSuccessfully {
    return Intl.message(
      'Phone Number Changed Successfully',
      name: 'phoneNumberChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Report Your issue`
  String get reportYourIssue {
    return Intl.message(
      'Report Your issue',
      name: 'reportYourIssue',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message(
      'Report',
      name: 'report',
      desc: '',
      args: [],
    );
  }

  /// `Service Provider`
  String get serviceProvider {
    return Intl.message(
      'Service Provider',
      name: 'serviceProvider',
      desc: '',
      args: [],
    );
  }

  /// `Service Location`
  String get serviceLocation {
    return Intl.message(
      'Service Location',
      name: 'serviceLocation',
      desc: '',
      args: [],
    );
  }

  /// `In/Out Branch`
  String get inOrOutBranch {
    return Intl.message(
      'In/Out Branch',
      name: 'inOrOutBranch',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get birthDate {
    return Intl.message(
      'Birth Date',
      name: 'birthDate',
      desc: '',
      args: [],
    );
  }

  /// `Invalid date format`
  String get invalidDateFormat {
    return Intl.message(
      'Invalid date format',
      name: 'invalidDateFormat',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
