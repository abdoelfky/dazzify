import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/api/api_status_codes.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/framework/dazzify_drop_down.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/core/util/functions.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
import 'package:dazzify/features/brand/presentation/components/brand_profile_header.dart';
import 'package:dazzify/features/brand/presentation/tabs/brand_photos_tab.dart';
import 'package:dazzify/features/brand/presentation/tabs/brand_reels_tab.dart';
import 'package:dazzify/features/brand/presentation/tabs/brand_reviews_tab.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/bottom_sheets/report_bottom_sheet.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/shared/widgets/glass_icon_button.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/widget_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

@RoutePage()
class BrandProfileScreen extends StatefulWidget implements AutoRouteWrapper {
  final BrandModel? brand;
  final String? brandSlug;

  const BrandProfileScreen({
    super.key,
    this.brand,
    this.brandSlug,
  });

  @override
  State<BrandProfileScreen> createState() => _BrandProfileScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BrandBloc>(),
      child: this,
    );
  }
}

class _BrandProfileScreenState extends State<BrandProfileScreen>
    with SingleTickerProviderStateMixin {
  late  TabController _tabController;
  late final BrandBloc _brandBloc;
  late final ScrollController _controller;

  int _resolveInitialTabIndex(BrandState state) {
    final hasPhotos = state.photos.isNotEmpty;
    final hasReels = state.reels.isNotEmpty;

    if (hasPhotos) return 0;
    if (hasReels) return 1;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _controller = ScrollController();
    _brandBloc = context.read<BrandBloc>();
    _brandBloc.add(GetBrandImagesEvent(widget.brand!.id));
    _brandBloc.add(GetBrandReelsEvent(widget.brand!.id));

    if (widget.brand != null) {
      _brandBloc.add(
        SetSingleBrandDetailsEvent(widget.brand!),
      );
    } else {
      _brandBloc.add(
        GetSingleBrandDetailsEvent(widget.brandSlug!),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _brandBloc.add(const RefreshEvent());
          await Future.delayed(const Duration(seconds: 2));
        },
        child: BlocBuilder<BrandBloc, BrandState>(
          builder: (context, state) {

            if (_tabController.index == 0 &&
                state.brandDetailsState == UiState.success &&
                state.photosState == UiState.success &&
                state.reelsState == UiState.success) {
              final resolvedIndex = _resolveInitialTabIndex(state);
              if (_tabController.index != resolvedIndex) {
                _tabController.animateTo(resolvedIndex);
              }
            }

            if (state.brandDetailsState == UiState.loading) {
              return const Center(
                child: LoadingAnimation(),
              );
            } else if (state.brandDetailsState == UiState.failure) {
              return ErrorDataWidget(
                enableBackIcon: true,
                onTap: state.errorCode != ApiStatusCodes.notFound
                    ? null
                    : () {
                        if (widget.brandSlug != null) {
                          _brandBloc.add(
                            GetSingleBrandDetailsEvent(widget.brandSlug!),
                          );
                        }
                      },
                errorDataType: DazzifyErrorDataType.screen,
                message: state.errorMessage,
              );
            } else {
              return Stack(
                children: [
                  NestedScrollView(
                    controller: _controller,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: BrandProfileHeader(
                            brand: state.brandDetails,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0).r,
                            child: TabBar(
                              onTap: (index) {},
                              controller: _tabController,
                              unselectedLabelColor: context.colorScheme.outline,
                              labelColor: context.colorScheme.primary,
                              dividerColor: context.colorScheme.outlineVariant,
                              indicatorColor: context.colorScheme.primary,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorWeight: 5.h,
                              padding: const EdgeInsets.only(bottom: 24).r,
                              tabs: [
                                Tab(
                                  icon: Icon(
                                    SolarIconsOutline.gallery,
                                    size: 24.r,
                                  ),
                                  height: 50.h,
                                ),
                                Tab(
                                  icon: Icon(
                                    SolarIconsOutline.videoLibrary,
                                    size: 24.r,
                                  ),
                                  height: 50.h,
                                ),
                                Tab(
                                  icon: Icon(
                                    SolarIconsOutline.chatLine,
                                    size: 24.r,
                                  ),
                                  height: 50.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        BrandPhotosTab(
                          key: const PageStorageKey(
                            AppConstants.vendorPhotosTab,
                          ),
                          brandId: state.brandDetails.id,
                          brandName: state.brandDetails.name,
                          tabController: _tabController,
                          scrollController: _controller,
                        ),
                        BrandReelsTab(
                          key: const PageStorageKey(
                            AppConstants.vendorReelsTab,
                          ),
                          brandId: state.brandDetails.id,
                          tabController: _tabController,
                          scrollController: _controller,
                        ),
                        BrandReviewsTab(
                          key: const PageStorageKey(
                            AppConstants.vendorReviewsTab,
                          ),
                          brandId: state.brandDetails.id,
                          tabController: _tabController,
                          scrollController: _controller,
                        ),
                      ],
                    ),
                  ),
                  PositionedDirectional(
                    top: 50.r,
                    start: 15.r,
                    child: WidgetDirection(
                      child: GlassIconButton(
                        icon: SolarIconsOutline.arrowLeft,
                        onPressed: () {
                          context.maybePop();
                        },
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 50.r,
                    end: 15.r,
                    child: DazzifyIconMenu(
                      options: [
                        MenuOption(
                          svgIcon: AssetsManager.shareIcon,
                          onTap: () {
                            openUrlSheet(
                              url: AppConstants.shareBrand(
                                  state.brandDetails.username!),
                            );
                          },
                        ),
                        MenuOption(
                          icon: SolarIconsOutline.dangerCircle,
                          onTap: () {
                            if (AuthLocalDatasourceImpl().checkGuestMode()) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: false,
                                builder: (context) {
                                  return GuestModeBottomSheet();
                                },
                              );
                            } else {
                              showReportBottomSheet(
                                context: context,
                                id: state.brandDetails.id,
                                type: "brand",
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
