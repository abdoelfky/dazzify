class ApiConstants {
  static const String appConfig = "/app-config";

  static const String success = "success";
  static const String sendOtpPath = "/auth/send-otp";
  static const String validateNonExistUserOtpPath =
      "/auth/validate-notexist-user-otp";
  static const String validateExistUserOtpPath =
      "/auth/validate-exist-user-otp";
  static const String addInformationPath = "/auth/register";
  static const String refreshUserAccessTokenPath = "/auth/refresh";
  static const String banners = "/banner/list";
  static const String mainCategories = "/maincategory/list";
  static const String brands = "/brand/list";
  static const String services = "/service/list";

  static String serviceReview(String serviceId) =>
      "/service/$serviceId/reviews";

  static String moreLikeThisService(String serviceId) =>
      "/service/$serviceId/more-like-this";
  static const String getConversations = "/chat/list";
  static const String subscribeToNotification = "/notification/subscribe";
  static const String unSubscribeFromNotification = "/notification/unsubscribe";
  static const String getUserData = "/user/me";
  static const String updatePhoneNumber = "/user/update-phonenumber";
  static const String verifyUpdatePhoneNumberOtp =
      "/user/verify-update-phonenumber-otp";
  static const String updateUserInfo = "/user/me/profile";
  static const String getReels = "/media/reels";
  static const String appTerms = "/terms";
  static const String cancelTerms = "/refundConditions";
  static const String userNotifications = "/notification/list";
  static const String getUserFavorites = "/user/favorites";
  static const String getMediaList = "/media/list";
  static const String getBrandServiceAvailableSlots = "/brand/available-slots";
  static const String getBrandMultipleServicesAvailableSlots =
      "/brand/multiple-services/available-slots";
  ///multiple-services - multiple-services/available-slots
  static const String createBooking = "/booking/multiple-services/create";
  // static const String createBooking = "/booking/create";
  static const brandMedia = "/media/list";
  static const String getUserLikes = "/user/media-likes";
  static const String issue = "/issue/";
  static const String getLocationName = "/location-name";
  static const String notInterestedToReview =
      "/review/not-interested-to-review";
  static const String getMissedReviews = "/review/missed-review";

  static String getBrandTransportationFees(String brandId) =>
      "/brand/$brandId/transportation-fees";

  static String validateCoupn(String brandId) => "/brand/$brandId/coupon-valid";

  static String addView(String mediaId) => "/media/$mediaId/add-view";

  static String addLike(String reelId) => "/media/$reelId/like";

  static String removeLike(String reelId) => "/media/$reelId/unlike";

  static String getVendorBrandProfile({required String username}) =>
      "/brand/$username";

  static String getVendorBrandBranches({required String brandId}) =>
      "/brand/$brandId/branches";

  static String getVendorBrandReviews({required String brandId}) =>
      "/brand/$brandId/reviews";

  static String getVendorBrandCategories({required String brandId}) =>
      "/brand/$brandId/categories";

  static String getBrandServicesWithCategoryAndBranch(
          {required String categoryId}) =>
      "/category/$categoryId/services-with-branch";

  static String getComments({required String mediaId}) =>
      "/media/$mediaId/comments";

  static String addComment({required String mediaId}) =>
      "/media/$mediaId/add-comment";

  static String deleteComment({required String commentId}) =>
      "/comment/$commentId/delete";

  static String getChatMessages({required String branchId}) =>
      "/chat/$branchId/messages";

  static String sendMessage({required String branchId}) =>
      "/chat/$branchId/new-message";

  static const String getCommentLikes = "/user/comment-likes";

  static String addCommentLike({required String commentId}) =>
      "/comment/$commentId/like";

  static String removeCommentLike({required String commentId}) =>
      "/comment/$commentId/unlike";

  static String brandTerms({required String brandId}) =>
      "/brand/$brandId/terms";

  static const String lastActiveBooking = "/booking/last-active-booking";

  static const String bookingsList = "/booking/list";

  static String singleBooking(String bookingId) => "/booking/$bookingId";

  static String cancelBooking(String bookingId) => "/booking/$bookingId/cancel";

  static String userArrived(String bookingId) => "/booking/$bookingId/arrive";

  static const String createReview = "/review/create";

  static String addBrandView({required String brandId}) =>
      "/brand/$brandId/view";

  static String getSingleServiceDetails({required String serviceId}) =>
      "/service/$serviceId";

  static String getSingleBrandDetails({required String username}) =>
      "/brand/$username";

  static String addReply({required String commentId}) =>
      "/comment/$commentId/add-reply";

  static String updateComment({required String commentId}) =>
      "/comment/$commentId/update";

  static const String getPaymentMethods = "/transaction/payment-methods";

  static const String getTransactions = "/transaction/booking";
  static const String report = "/report/create";

  static String addPaymentMethod({required String transactionId}) =>
      "/transaction/$transactionId/pay";

  static const String getTieredCouponRewards = "/user/tiered-coupon-rewards";
}
