// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AuthScreen]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
      : super(
          AuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthScreen();
    },
  );
}

/// generated route for
/// [Authenticated]
class AuthenticatedRoute extends PageRouteInfo<void> {
  const AuthenticatedRoute({List<PageRouteInfo>? children})
      : super(
          AuthenticatedRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthenticatedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const Authenticated());
    },
  );
}

/// generated route for
/// [BookingStatusScreen]
class BookingStatusRoute extends PageRouteInfo<BookingStatusRouteArgs> {
  BookingStatusRoute({
    Key? key,
    required String bookingId,
    List<PageRouteInfo>? children,
  }) : super(
          BookingStatusRoute.name,
          args: BookingStatusRouteArgs(
            key: key,
            bookingId: bookingId,
          ),
          initialChildren: children,
        );

  static const String name = 'BookingStatusRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BookingStatusRouteArgs>();
      return BookingStatusScreen(
        key: args.key,
        bookingId: args.bookingId,
      );
    },
  );
}

class BookingStatusRouteArgs {
  const BookingStatusRouteArgs({
    this.key,
    required this.bookingId,
  });

  final Key? key;

  final String bookingId;

  @override
  String toString() {
    return 'BookingStatusRouteArgs{key: $key, bookingId: $bookingId}';
  }
}

/// generated route for
/// [BookingsHistoryScreen]
class BookingsHistoryRoute extends PageRouteInfo<void> {
  const BookingsHistoryRoute({List<PageRouteInfo>? children})
      : super(
          BookingsHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'BookingsHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const BookingsHistoryScreen());
    },
  );
}

/// generated route for
/// [BottomNavBar]
class BottomNavBarRoute extends PageRouteInfo<void> {
  const BottomNavBarRoute({List<PageRouteInfo>? children})
      : super(
          BottomNavBarRoute.name,
          initialChildren: children,
        );

  static const String name = 'BottomNavBarRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BottomNavBar();
    },
  );
}

/// generated route for
/// [Brand]
class BrandRoute extends PageRouteInfo<void> {
  const BrandRoute({List<PageRouteInfo>? children})
      : super(
          BrandRoute.name,
          initialChildren: children,
        );

  static const String name = 'BrandRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const Brand());
    },
  );
}

/// generated route for
/// [BrandPostsScreen]
class BrandPostsRoute extends PageRouteInfo<BrandPostsRouteArgs> {
  BrandPostsRoute({
    Key? key,
    required int photoIndex,
    required String brandName,
    required String brandId,
    required BrandBloc brandBloc,
    List<PageRouteInfo>? children,
  }) : super(
          BrandPostsRoute.name,
          args: BrandPostsRouteArgs(
            key: key,
            photoIndex: photoIndex,
            brandName: brandName,
            brandId: brandId,
            brandBloc: brandBloc,
          ),
          initialChildren: children,
        );

  static const String name = 'BrandPostsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BrandPostsRouteArgs>();
      return WrappedRoute(
          child: BrandPostsScreen(
        key: args.key,
        photoIndex: args.photoIndex,
        brandName: args.brandName,
        brandId: args.brandId,
        brandBloc: args.brandBloc,
      ));
    },
  );
}

class BrandPostsRouteArgs {
  const BrandPostsRouteArgs({
    this.key,
    required this.photoIndex,
    required this.brandName,
    required this.brandId,
    required this.brandBloc,
  });

  final Key? key;

  final int photoIndex;

  final String brandName;

  final String brandId;

  final BrandBloc brandBloc;

  @override
  String toString() {
    return 'BrandPostsRouteArgs{key: $key, photoIndex: $photoIndex, brandName: $brandName, brandId: $brandId, brandBloc: $brandBloc}';
  }
}

/// generated route for
/// [BrandProfileScreen]
class BrandProfileRoute extends PageRouteInfo<BrandProfileRouteArgs> {
  BrandProfileRoute({
    Key? key,
    BrandModel? brand,
    String? brandSlug,
    List<PageRouteInfo>? children,
  }) : super(
          BrandProfileRoute.name,
          args: BrandProfileRouteArgs(
            key: key,
            brand: brand,
            brandSlug: brandSlug,
          ),
          initialChildren: children,
        );

  static const String name = 'BrandProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BrandProfileRouteArgs>(
          orElse: () => const BrandProfileRouteArgs());
      return WrappedRoute(
          child: BrandProfileScreen(
        key: args.key,
        brand: args.brand,
        brandSlug: args.brandSlug,
      ));
    },
  );
}

class BrandProfileRouteArgs {
  const BrandProfileRouteArgs({
    this.key,
    this.brand,
    this.brandSlug,
  });

  final Key? key;

  final BrandModel? brand;

  final String? brandSlug;

  @override
  String toString() {
    return 'BrandProfileRouteArgs{key: $key, brand: $brand, brandSlug: $brandSlug}';
  }
}

/// generated route for
/// [BrandReelsScreen]
class BrandReelsRoute extends PageRouteInfo<BrandReelsRouteArgs> {
  BrandReelsRoute({
    Key? key,
    required int index,
    required BrandBloc vendorBloc,
    List<PageRouteInfo>? children,
  }) : super(
          BrandReelsRoute.name,
          args: BrandReelsRouteArgs(
            key: key,
            index: index,
            vendorBloc: vendorBloc,
          ),
          initialChildren: children,
        );

  static const String name = 'BrandReelsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BrandReelsRouteArgs>();
      return WrappedRoute(
          child: BrandReelsScreen(
        key: args.key,
        index: args.index,
        vendorBloc: args.vendorBloc,
      ));
    },
  );
}

class BrandReelsRouteArgs {
  const BrandReelsRouteArgs({
    this.key,
    required this.index,
    required this.vendorBloc,
  });

  final Key? key;

  final int index;

  final BrandBloc vendorBloc;

  @override
  String toString() {
    return 'BrandReelsRouteArgs{key: $key, index: $index, vendorBloc: $vendorBloc}';
  }
}

/// generated route for
/// [BrandServiceBookingScreen]
class BrandServiceBookingRoute
    extends PageRouteInfo<BrandServiceBookingRouteArgs> {
  BrandServiceBookingRoute({
    required String brandId,
    Key? key,
    required bool isMultipleBooking,
    required BrandBranchesModel branch,
    List<PageRouteInfo>? children,
  }) : super(
          BrandServiceBookingRoute.name,
          args: BrandServiceBookingRouteArgs(
            brandId: brandId,
            key: key,
            isMultipleBooking: isMultipleBooking,
            branch: branch,
          ),
          initialChildren: children,
        );

  static const String name = 'BrandServiceBookingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BrandServiceBookingRouteArgs>();
      return WrappedRoute(
          child: BrandServiceBookingScreen(
        brandId: args.brandId,
        key: args.key,
        isMultipleBooking: args.isMultipleBooking,
        branch: args.branch,
      ));
    },
  );
}

class BrandServiceBookingRouteArgs {
  const BrandServiceBookingRouteArgs({
    required this.brandId,
    this.key,
    required this.isMultipleBooking,
    required this.branch,
  });

  final String brandId;

  final Key? key;

  final bool isMultipleBooking;

  final BrandBranchesModel branch;

  @override
  String toString() {
    return 'BrandServiceBookingRouteArgs{brandId: $brandId, key: $key, isMultipleBooking: $isMultipleBooking, branch: $branch}';
  }
}

/// generated route for
/// [CategoryScreen]
class CategoryRoute extends PageRouteInfo<CategoryRouteArgs> {
  CategoryRoute({
    Key? key,
    required String categoryName,
    required String categoryId,
    List<PageRouteInfo>? children,
  }) : super(
          CategoryRoute.name,
          args: CategoryRouteArgs(
            key: key,
            categoryName: categoryName,
            categoryId: categoryId,
          ),
          initialChildren: children,
        );

  static const String name = 'CategoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryRouteArgs>();
      return WrappedRoute(
          child: CategoryScreen(
        key: args.key,
        categoryName: args.categoryName,
        categoryId: args.categoryId,
      ));
    },
  );
}

class CategoryRouteArgs {
  const CategoryRouteArgs({
    this.key,
    required this.categoryName,
    required this.categoryId,
  });

  final Key? key;

  final String categoryName;

  final String categoryId;

  @override
  String toString() {
    return 'CategoryRouteArgs{key: $key, categoryName: $categoryName, categoryId: $categoryId}';
  }
}

/// generated route for
/// [ChatScreen]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    required BrandModel brand,
    required String branchId,
    required String branchName,
    String? serviceToBeSent,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            brand: brand,
            branchId: branchId,
            branchName: branchName,
            serviceToBeSent: serviceToBeSent,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return WrappedRoute(
          child: ChatScreen(
        brand: args.brand,
        branchId: args.branchId,
        branchName: args.branchName,
        serviceToBeSent: args.serviceToBeSent,
        key: args.key,
      ));
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    required this.brand,
    required this.branchId,
    required this.branchName,
    this.serviceToBeSent,
    this.key,
  });

  final BrandModel brand;

  final String branchId;

  final String branchName;

  final String? serviceToBeSent;

  final Key? key;

  @override
  String toString() {
    return 'ChatRouteArgs{brand: $brand, branchId: $branchId, branchName: $branchName, serviceToBeSent: $serviceToBeSent, key: $key}';
  }
}

/// generated route for
/// [ChatTab]
class ChatTabRoute extends PageRouteInfo<void> {
  const ChatTabRoute({List<PageRouteInfo>? children})
      : super(
          ChatTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChatTab();
    },
  );
}

/// generated route for
/// [ConversationsScreen]
class ConversationsRoute extends PageRouteInfo<void> {
  const ConversationsRoute({List<PageRouteInfo>? children})
      : super(
          ConversationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConversationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ConversationsScreen();
    },
  );
}

/// generated route for
/// [DazzifyPhotoViewer]
class DazzifyPhotoViewerRoute
    extends PageRouteInfo<DazzifyPhotoViewerRouteArgs> {
  DazzifyPhotoViewerRoute({
    Key? key,
    bool isProfilePicture = false,
    required String name,
    String? userAvatar,
    required String imageUrl,
    required dynamic heroAnimationKey,
    MediaModel? media,
    List<PageRouteInfo>? children,
  }) : super(
          DazzifyPhotoViewerRoute.name,
          args: DazzifyPhotoViewerRouteArgs(
            key: key,
            isProfilePicture: isProfilePicture,
            name: name,
            userAvatar: userAvatar,
            imageUrl: imageUrl,
            heroAnimationKey: heroAnimationKey,
            media: media,
          ),
          initialChildren: children,
        );

  static const String name = 'DazzifyPhotoViewerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DazzifyPhotoViewerRouteArgs>();
      return WrappedRoute(
          child: DazzifyPhotoViewer(
        key: args.key,
        isProfilePicture: args.isProfilePicture,
        name: args.name,
        userAvatar: args.userAvatar,
        imageUrl: args.imageUrl,
        heroAnimationKey: args.heroAnimationKey,
        media: args.media,
      ));
    },
  );
}

class DazzifyPhotoViewerRouteArgs {
  const DazzifyPhotoViewerRouteArgs({
    this.key,
    this.isProfilePicture = false,
    required this.name,
    this.userAvatar,
    required this.imageUrl,
    required this.heroAnimationKey,
    this.media,
  });

  final Key? key;

  final bool isProfilePicture;

  final String name;

  final String? userAvatar;

  final String imageUrl;

  final dynamic heroAnimationKey;

  final MediaModel? media;

  @override
  String toString() {
    return 'DazzifyPhotoViewerRouteArgs{key: $key, isProfilePicture: $isProfilePicture, name: $name, userAvatar: $userAvatar, imageUrl: $imageUrl, heroAnimationKey: $heroAnimationKey, media: $media}';
  }
}

/// generated route for
/// [Home]
class HomeTabRoute extends PageRouteInfo<void> {
  const HomeTabRoute({List<PageRouteInfo>? children})
      : super(
          HomeTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const Home());
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [Issue]
class IssueRoutes extends PageRouteInfo<void> {
  const IssueRoutes({List<PageRouteInfo>? children})
      : super(
          IssueRoutes.name,
          initialChildren: children,
        );

  static const String name = 'IssueRoutes';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const Issue());
    },
  );
}

/// generated route for
/// [IssueScreen]
class IssueRoute extends PageRouteInfo<void> {
  const IssueRoute({List<PageRouteInfo>? children})
      : super(
          IssueRoute.name,
          initialChildren: children,
        );

  static const String name = 'IssueRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IssueScreen();
    },
  );
}

/// generated route for
/// [IssueStatusScreen]
class IssueStatusRoute extends PageRouteInfo<IssueStatusRouteArgs> {
  IssueStatusRoute({
    Key? key,
    required String status,
    required String? reply,
    List<PageRouteInfo>? children,
  }) : super(
          IssueStatusRoute.name,
          args: IssueStatusRouteArgs(
            key: key,
            status: status,
            reply: reply,
          ),
          initialChildren: children,
        );

  static const String name = 'IssueStatusRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<IssueStatusRouteArgs>();
      return IssueStatusScreen(
        key: args.key,
        status: args.status,
        reply: args.reply,
      );
    },
  );
}

class IssueStatusRouteArgs {
  const IssueStatusRouteArgs({
    this.key,
    required this.status,
    required this.reply,
  });

  final Key? key;

  final String status;

  final String? reply;

  @override
  String toString() {
    return 'IssueStatusRouteArgs{key: $key, status: $status, reply: $reply}';
  }
}

/// generated route for
/// [MaintenanceScreen]
class MaintenanceRoute extends PageRouteInfo<void> {
  const MaintenanceRoute({List<PageRouteInfo>? children})
      : super(
          MaintenanceRoute.name,
          initialChildren: children,
        );

  static const String name = 'MaintenanceRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MaintenanceScreen();
    },
  );
}

/// generated route for
/// [MultipleServiceAvailabilityScreen]
class MultipleServiceAvailabilityRoute
    extends PageRouteInfo<MultipleServiceAvailabilityRouteArgs> {
  MultipleServiceAvailabilityRoute({
    required List<ServiceDetailsModel> services,
    required String branchId,
    required String branchName,
    LocationModel? location,
    ServiceSelectionCubit? serviceSelectionCubit,
    Key? key,
    required String brandId,
    List<PageRouteInfo>? children,
  }) : super(
          MultipleServiceAvailabilityRoute.name,
          args: MultipleServiceAvailabilityRouteArgs(
            services: services,
            branchId: branchId,
            branchName: branchName,
            location: location,
            serviceSelectionCubit: serviceSelectionCubit,
            key: key,
            brandId: brandId,
          ),
          initialChildren: children,
        );

  static const String name = 'MultipleServiceAvailabilityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MultipleServiceAvailabilityRouteArgs>();
      return WrappedRoute(
          child: MultipleServiceAvailabilityScreen(
        services: args.services,
        branchId: args.branchId,
        branchName: args.branchName,
        location: args.location,
        serviceSelectionCubit: args.serviceSelectionCubit,
        key: args.key,
        brandId: args.brandId,
      ));
    },
  );
}

class MultipleServiceAvailabilityRouteArgs {
  const MultipleServiceAvailabilityRouteArgs({
    required this.services,
    required this.branchId,
    required this.branchName,
    this.location,
    this.serviceSelectionCubit,
    this.key,
    required this.brandId,
  });

  final List<ServiceDetailsModel> services;

  final String branchId;

  final String branchName;

  final LocationModel? location;

  final ServiceSelectionCubit? serviceSelectionCubit;

  final Key? key;

  final String brandId;

  @override
  String toString() {
    return 'MultipleServiceAvailabilityRouteArgs{services: $services, branchId: $branchId, branchName: $branchName, location: $location, serviceSelectionCubit: $serviceSelectionCubit, key: $key, brandId: $brandId}';
  }
}

/// generated route for
/// [MyFavoriteScreen]
class MyFavoriteRoute extends PageRouteInfo<void> {
  const MyFavoriteRoute({List<PageRouteInfo>? children})
      : super(
          MyFavoriteRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyFavoriteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const MyFavoriteScreen());
    },
  );
}

/// generated route for
/// [NotificationsScreen]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const NotificationsScreen());
    },
  );
}

/// generated route for
/// [OtpVerifyScreen]
class OtpVerifyRoute extends PageRouteInfo<void> {
  const OtpVerifyRoute({List<PageRouteInfo>? children})
      : super(
          OtpVerifyRoute.name,
          initialChildren: children,
        );

  static const String name = 'OtpVerifyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OtpVerifyScreen();
    },
  );
}

/// generated route for
/// [Payment]
class PaymentRoutes extends PageRouteInfo<void> {
  const PaymentRoutes({List<PageRouteInfo>? children})
      : super(
          PaymentRoutes.name,
          initialChildren: children,
        );

  static const String name = 'PaymentRoutes';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const Payment();
    },
  );
}

/// generated route for
/// [PaymentMethodScreen]
class PaymentMethodRoute extends PageRouteInfo<PaymentMethodRouteArgs> {
  PaymentMethodRoute({
    Key? key,
    required String serviceName,
    required String transactionId,
    List<PageRouteInfo>? children,
  }) : super(
          PaymentMethodRoute.name,
          args: PaymentMethodRouteArgs(
            key: key,
            serviceName: serviceName,
            transactionId: transactionId,
          ),
          initialChildren: children,
        );

  static const String name = 'PaymentMethodRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PaymentMethodRouteArgs>();
      return PaymentMethodScreen(
        key: args.key,
        serviceName: args.serviceName,
        transactionId: args.transactionId,
      );
    },
  );
}

class PaymentMethodRouteArgs {
  const PaymentMethodRouteArgs({
    this.key,
    required this.serviceName,
    required this.transactionId,
  });

  final Key? key;

  final String serviceName;

  final String transactionId;

  @override
  String toString() {
    return 'PaymentMethodRouteArgs{key: $key, serviceName: $serviceName, transactionId: $transactionId}';
  }
}

/// generated route for
/// [PaymentWebViewScreen]
class PaymentWebViewRoute extends PageRouteInfo<PaymentWebViewRouteArgs> {
  PaymentWebViewRoute({
    Key? key,
    required String url,
    required TransactionBloc transactionBloc,
    List<PageRouteInfo>? children,
  }) : super(
          PaymentWebViewRoute.name,
          args: PaymentWebViewRouteArgs(
            key: key,
            url: url,
            transactionBloc: transactionBloc,
          ),
          initialChildren: children,
        );

  static const String name = 'PaymentWebViewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PaymentWebViewRouteArgs>();
      return PaymentWebViewScreen(
        key: args.key,
        url: args.url,
        transactionBloc: args.transactionBloc,
      );
    },
  );
}

class PaymentWebViewRouteArgs {
  const PaymentWebViewRouteArgs({
    this.key,
    required this.url,
    required this.transactionBloc,
  });

  final Key? key;

  final String url;

  final TransactionBloc transactionBloc;

  @override
  String toString() {
    return 'PaymentWebViewRouteArgs{key: $key, url: $url, transactionBloc: $transactionBloc}';
  }
}

/// generated route for
/// [PopularBrandsScreen]
class PopularBrandsRoute extends PageRouteInfo<void> {
  const PopularBrandsRoute({List<PageRouteInfo>? children})
      : super(
          PopularBrandsRoute.name,
          initialChildren: children,
        );

  static const String name = 'PopularBrandsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const PopularBrandsScreen());
    },
  );
}

/// generated route for
/// [PopularServicesScreen]
class PopularServicesRoute extends PageRouteInfo<void> {
  const PopularServicesRoute({List<PageRouteInfo>? children})
      : super(
          PopularServicesRoute.name,
          initialChildren: children,
        );

  static const String name = 'PopularServicesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const PopularServicesScreen());
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [ProfileTab]
class ProfileTabRoute extends PageRouteInfo<void> {
  const ProfileTabRoute({List<PageRouteInfo>? children})
      : super(
          ProfileTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileTab();
    },
  );
}

/// generated route for
/// [QrScannerScreen]
class QrScannerRoute extends PageRouteInfo<void> {
  const QrScannerRoute({List<PageRouteInfo>? children})
      : super(
          QrScannerRoute.name,
          initialChildren: children,
        );

  static const String name = 'QrScannerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QrScannerScreen();
    },
  );
}

/// generated route for
/// [ReelViewerScreen]
class ReelViewerRoute extends PageRouteInfo<ReelViewerRouteArgs> {
  ReelViewerRoute({
    Key? key,
    required MediaModel reel,
    List<PageRouteInfo>? children,
  }) : super(
          ReelViewerRoute.name,
          args: ReelViewerRouteArgs(
            key: key,
            reel: reel,
          ),
          initialChildren: children,
        );

  static const String name = 'ReelViewerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReelViewerRouteArgs>();
      return WrappedRoute(
          child: ReelViewerScreen(
        key: args.key,
        reel: args.reel,
      ));
    },
  );
}

class ReelViewerRouteArgs {
  const ReelViewerRouteArgs({
    this.key,
    required this.reel,
  });

  final Key? key;

  final MediaModel reel;

  @override
  String toString() {
    return 'ReelViewerRouteArgs{key: $key, reel: $reel}';
  }
}

/// generated route for
/// [ReelsScreen]
class ReelsRoute extends PageRouteInfo<void> {
  const ReelsRoute({List<PageRouteInfo>? children})
      : super(
          ReelsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReelsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReelsScreen();
    },
  );
}

/// generated route for
/// [ReelsTab]
class ReelsTabRoute extends PageRouteInfo<void> {
  const ReelsTabRoute({List<PageRouteInfo>? children})
      : super(
          ReelsTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReelsTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const ReelsTab());
    },
  );
}

/// generated route for
/// [SearchPostScreen]
class SearchPostRoute extends PageRouteInfo<SearchPostRouteArgs> {
  SearchPostRoute({
    Key? key,
    required MediaModel photo,
    List<PageRouteInfo>? children,
  }) : super(
          SearchPostRoute.name,
          args: SearchPostRouteArgs(
            key: key,
            photo: photo,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchPostRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SearchPostRouteArgs>();
      return WrappedRoute(
          child: SearchPostScreen(
        key: args.key,
        photo: args.photo,
      ));
    },
  );
}

class SearchPostRouteArgs {
  const SearchPostRouteArgs({
    this.key,
    required this.photo,
  });

  final Key? key;

  final MediaModel photo;

  @override
  String toString() {
    return 'SearchPostRouteArgs{key: $key, photo: $photo}';
  }
}

/// generated route for
/// [SearchScreen]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute({List<PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SearchScreen();
    },
  );
}

/// generated route for
/// [SearchTab]
class SearchTabRoute extends PageRouteInfo<void> {
  const SearchTabRoute({List<PageRouteInfo>? children})
      : super(
          SearchTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const SearchTab());
    },
  );
}

/// generated route for
/// [SeeAllReviewsScreen]
class SeeAllReviewsRoute extends PageRouteInfo<SeeAllReviewsRouteArgs> {
  SeeAllReviewsRoute({
    Key? key,
    required String serviceId,
    required ServiceDetailsBloc serviceDetailsBloc,
    List<PageRouteInfo>? children,
  }) : super(
          SeeAllReviewsRoute.name,
          args: SeeAllReviewsRouteArgs(
            key: key,
            serviceId: serviceId,
            serviceDetailsBloc: serviceDetailsBloc,
          ),
          initialChildren: children,
        );

  static const String name = 'SeeAllReviewsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SeeAllReviewsRouteArgs>();
      return WrappedRoute(
          child: SeeAllReviewsScreen(
        key: args.key,
        serviceId: args.serviceId,
        serviceDetailsBloc: args.serviceDetailsBloc,
      ));
    },
  );
}

class SeeAllReviewsRouteArgs {
  const SeeAllReviewsRouteArgs({
    this.key,
    required this.serviceId,
    required this.serviceDetailsBloc,
  });

  final Key? key;

  final String serviceId;

  final ServiceDetailsBloc serviceDetailsBloc;

  @override
  String toString() {
    return 'SeeAllReviewsRouteArgs{key: $key, serviceId: $serviceId, serviceDetailsBloc: $serviceDetailsBloc}';
  }
}

/// generated route for
/// [ServiceAvailabilityScreen]
class ServiceAvailabilityRoute
    extends PageRouteInfo<ServiceAvailabilityRouteArgs> {
  ServiceAvailabilityRoute({
    required ServiceDetailsModel service,
    required String branchId,
    required String branchName,
    LocationModel? location,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ServiceAvailabilityRoute.name,
          args: ServiceAvailabilityRouteArgs(
            service: service,
            branchId: branchId,
            branchName: branchName,
            location: location,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ServiceAvailabilityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ServiceAvailabilityRouteArgs>();
      return WrappedRoute(
          child: ServiceAvailabilityScreen(
        service: args.service,
        branchId: args.branchId,
        branchName: args.branchName,
        location: args.location,
        key: args.key,
      ));
    },
  );
}

class ServiceAvailabilityRouteArgs {
  const ServiceAvailabilityRouteArgs({
    required this.service,
    required this.branchId,
    required this.branchName,
    this.location,
    this.key,
  });

  final ServiceDetailsModel service;

  final String branchId;

  final String branchName;

  final LocationModel? location;

  final Key? key;

  @override
  String toString() {
    return 'ServiceAvailabilityRouteArgs{service: $service, branchId: $branchId, branchName: $branchName, location: $location, key: $key}';
  }
}

/// generated route for
/// [ServiceBookingConfirmationScreen]
class ServiceBookingConfirmationRoute extends PageRouteInfo<void> {
  const ServiceBookingConfirmationRoute({List<PageRouteInfo>? children})
      : super(
          ServiceBookingConfirmationRoute.name,
          initialChildren: children,
        );

  static const String name = 'ServiceBookingConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ServiceBookingConfirmationScreen();
    },
  );
}

/// generated route for
/// [ServiceDetailsScreen]
class ServiceDetailsRoute extends PageRouteInfo<ServiceDetailsRouteArgs> {
  ServiceDetailsRoute({
    ServiceDetailsModel? service,
    BrandBranchesModel? branch,
    Key? key,
    String? serviceId,
    bool isBooking = false,
    List<PageRouteInfo>? children,
  }) : super(
          ServiceDetailsRoute.name,
          args: ServiceDetailsRouteArgs(
            service: service,
            branch: branch,
            key: key,
            serviceId: serviceId,
            isBooking: isBooking,
          ),
          initialChildren: children,
        );

  static const String name = 'ServiceDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ServiceDetailsRouteArgs>(
          orElse: () => const ServiceDetailsRouteArgs());
      return WrappedRoute(
          child: ServiceDetailsScreen(
        service: args.service,
        branch: args.branch,
        key: args.key,
        serviceId: args.serviceId,
        isBooking: args.isBooking,
      ));
    },
  );
}

class ServiceDetailsRouteArgs {
  const ServiceDetailsRouteArgs({
    this.service,
    this.branch,
    this.key,
    this.serviceId,
    this.isBooking = false,
  });

  final ServiceDetailsModel? service;

  final BrandBranchesModel? branch;

  final Key? key;

  final String? serviceId;

  final bool isBooking;

  @override
  String toString() {
    return 'ServiceDetailsRouteArgs{service: $service, branch: $branch, key: $key, serviceId: $serviceId, isBooking: $isBooking}';
  }
}

/// generated route for
/// [ServiceInvoiceScreen]
class ServiceInvoiceRoute extends PageRouteInfo<ServiceInvoiceRouteArgs> {
  ServiceInvoiceRoute({
    required ServiceDetailsModel service,
    required ServiceSelectionCubit serviceSelectionCubit,
    required List<ServiceDetailsModel> services,
    required String branchId,
    required String branchName,
    required String selectedDate,
    required String selectedStartTimeStamp,
    String? selectedFromTime,
    String? selectedToTime,
    LocationModel? branchLocation,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ServiceInvoiceRoute.name,
          args: ServiceInvoiceRouteArgs(
            service: service,
            serviceSelectionCubit: serviceSelectionCubit,
            services: services,
            branchId: branchId,
            branchName: branchName,
            selectedDate: selectedDate,
            selectedStartTimeStamp: selectedStartTimeStamp,
            selectedFromTime: selectedFromTime,
            selectedToTime: selectedToTime,
            branchLocation: branchLocation,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ServiceInvoiceRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ServiceInvoiceRouteArgs>();
      return WrappedRoute(
          child: ServiceInvoiceScreen(
        service: args.service,
        serviceSelectionCubit: args.serviceSelectionCubit,
        services: args.services,
        branchId: args.branchId,
        branchName: args.branchName,
        selectedDate: args.selectedDate,
        selectedStartTimeStamp: args.selectedStartTimeStamp,
        selectedFromTime: args.selectedFromTime,
        selectedToTime: args.selectedToTime,
        branchLocation: args.branchLocation,
        key: args.key,
      ));
    },
  );
}

class ServiceInvoiceRouteArgs {
  const ServiceInvoiceRouteArgs({
    required this.service,
    required this.serviceSelectionCubit,
    required this.services,
    required this.branchId,
    required this.branchName,
    required this.selectedDate,
    required this.selectedStartTimeStamp,
    this.selectedFromTime,
    this.selectedToTime,
    this.branchLocation,
    this.key,
  });

  final ServiceDetailsModel service;

  final ServiceSelectionCubit serviceSelectionCubit;

  final List<ServiceDetailsModel> services;

  final String branchId;

  final String branchName;

  final String selectedDate;

  final String selectedStartTimeStamp;

  final String? selectedFromTime;

  final String? selectedToTime;

  final LocationModel? branchLocation;

  final Key? key;

  @override
  String toString() {
    return 'ServiceInvoiceRouteArgs{service: $service, serviceSelectionCubit: $serviceSelectionCubit, services: $services, branchId: $branchId, branchName: $branchName, selectedDate: $selectedDate, selectedStartTimeStamp: $selectedStartTimeStamp, selectedFromTime: $selectedFromTime, selectedToTime: $selectedToTime, branchLocation: $branchLocation, key: $key}';
  }
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [TopRatedBrandsScreen]
class TopRatedBrandsRoute extends PageRouteInfo<void> {
  const TopRatedBrandsRoute({List<PageRouteInfo>? children})
      : super(
          TopRatedBrandsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TopRatedBrandsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const TopRatedBrandsScreen());
    },
  );
}

/// generated route for
/// [TopRatedServicesScreen]
class TopRatedServicesRoute extends PageRouteInfo<void> {
  const TopRatedServicesRoute({List<PageRouteInfo>? children})
      : super(
          TopRatedServicesRoute.name,
          initialChildren: children,
        );

  static const String name = 'TopRatedServicesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const TopRatedServicesScreen());
    },
  );
}

/// generated route for
/// [TransactionScreen]
class TransactionRoute extends PageRouteInfo<void> {
  const TransactionRoute({List<PageRouteInfo>? children})
      : super(
          TransactionRoute.name,
          initialChildren: children,
        );

  static const String name = 'TransactionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TransactionScreen();
    },
  );
}

/// generated route for
/// [UnAuthenticated]
class UnAuthenticatedRoute extends PageRouteInfo<void> {
  const UnAuthenticatedRoute({List<PageRouteInfo>? children})
      : super(
          UnAuthenticatedRoute.name,
          initialChildren: children,
        );

  static const String name = 'UnAuthenticatedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const UnAuthenticated());
    },
  );
}

/// generated route for
/// [UserInfoScreen]
class UserInfoRoute extends PageRouteInfo<void> {
  const UserInfoRoute({List<PageRouteInfo>? children})
      : super(
          UserInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserInfoScreen();
    },
  );
}

/// generated route for
/// [UserLocationScreen]
class UserLocationRoute extends PageRouteInfo<UserLocationRouteArgs> {
  UserLocationRoute({
    LocationModel? locationModel,
    required UserCubit userCubit,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UserLocationRoute.name,
          args: UserLocationRouteArgs(
            locationModel: locationModel,
            userCubit: userCubit,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'UserLocationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserLocationRouteArgs>();
      return WrappedRoute(
          child: UserLocationScreen(
        locationModel: args.locationModel,
        userCubit: args.userCubit,
        key: args.key,
      ));
    },
  );
}

class UserLocationRouteArgs {
  const UserLocationRouteArgs({
    this.locationModel,
    required this.userCubit,
    this.key,
  });

  final LocationModel? locationModel;

  final UserCubit userCubit;

  final Key? key;

  @override
  String toString() {
    return 'UserLocationRouteArgs{locationModel: $locationModel, userCubit: $userCubit, key: $key}';
  }
}

/// generated route for
/// [VendorRoute]
class VendorRoutes extends PageRouteInfo<void> {
  const VendorRoutes({List<PageRouteInfo>? children})
      : super(
          VendorRoutes.name,
          initialChildren: children,
        );

  static const String name = 'VendorRoutes';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const VendorRoute());
    },
  );
}

/// generated route for
/// [ViewLocationScreen]
class ViewLocationRoute extends PageRouteInfo<ViewLocationRouteArgs> {
  ViewLocationRoute({
    LocationModel? locationModel,
    required ServiceInvoiceCubit invoiceCubit,
    required bool isDisplayOnly,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ViewLocationRoute.name,
          args: ViewLocationRouteArgs(
            locationModel: locationModel,
            invoiceCubit: invoiceCubit,
            isDisplayOnly: isDisplayOnly,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ViewLocationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ViewLocationRouteArgs>();
      return WrappedRoute(
          child: ViewLocationScreen(
        locationModel: args.locationModel,
        invoiceCubit: args.invoiceCubit,
        isDisplayOnly: args.isDisplayOnly,
        key: args.key,
      ));
    },
  );
}

class ViewLocationRouteArgs {
  const ViewLocationRouteArgs({
    this.locationModel,
    required this.invoiceCubit,
    required this.isDisplayOnly,
    this.key,
  });

  final LocationModel? locationModel;

  final ServiceInvoiceCubit invoiceCubit;

  final bool isDisplayOnly;

  final Key? key;

  @override
  String toString() {
    return 'ViewLocationRouteArgs{locationModel: $locationModel, invoiceCubit: $invoiceCubit, isDisplayOnly: $isDisplayOnly, key: $key}';
  }
}

/// generated route for
/// [WebViewScreen]
class WebViewRoute extends PageRouteInfo<WebViewRouteArgs> {
  WebViewRoute({
    Key? key,
    required String url,
    List<PageRouteInfo>? children,
  }) : super(
          WebViewRoute.name,
          args: WebViewRouteArgs(
            key: key,
            url: url,
          ),
          initialChildren: children,
        );

  static const String name = 'WebViewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WebViewRouteArgs>();
      return WebViewScreen(
        key: args.key,
        url: args.url,
      );
    },
  );
}

class WebViewRouteArgs {
  const WebViewRouteArgs({
    this.key,
    required this.url,
  });

  final Key? key;

  final String url;

  @override
  String toString() {
    return 'WebViewRouteArgs{key: $key, url: $url}';
  }
}
