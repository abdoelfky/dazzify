import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/services/services_bloc.dart';
import 'package:dazzify/features/home/presentation/widgets/popular_service_card.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class PopularServicesScreen extends StatefulWidget implements AutoRouteWrapper {
  const PopularServicesScreen({super.key});

  @override
  State<PopularServicesScreen> createState() => _PopularServicesScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<ServicesBloc>(
      create: (context) =>
          getIt<ServicesBloc>()..add(const GetPopularServicesEvent()),
      child: this,
    );
  }
}

class _PopularServicesScreenState extends State<PopularServicesScreen> {
  late final ScrollController _controller;
  late final ServicesBloc servicesBloc;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: false,
    );
    servicesBloc = context.read<ServicesBloc>();
    _controller.addListener(_onScroll);
  }

  void _onScroll() async {
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      servicesBloc.add(const GetPopularServicesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            DazzifyAppBar(
              isLeading: true,
              title: context.tr.popularServices,
              horizontalPadding: 16.r,
            ),
            Expanded(
              child: BlocBuilder<ServicesBloc, ServicesState>(
                builder: (context, state) {
                  switch (state.popularServicesState) {
                    case UiState.initial:
                    case UiState.loading:
                      return DazzifyLoadingShimmer(
                        dazzifyLoadingType: DazzifyLoadingType.gridView,
                        gridViewItemCount: 12,
                        crossAxisCount: 3,
                        mainAxisSpacing: 6.h,
                        crossAxisSpacing: 6.w,
                        mainAxisExtent: 185.h,
                        widgetPadding: const EdgeInsets.all(8).r,
                      );
                    case UiState.failure:
                      return ErrorDataWidget(
                        errorDataType: DazzifyErrorDataType.screen,
                        message: state.errorMessage,
                        onTap: () {
                          servicesBloc.add(const GetPopularServicesEvent());
                        },
                      );
                    case UiState.success:
                      if (state.popularServices.isEmpty) {
                        return EmptyDataWidget(
                          message: context.tr.noServices,
                        );
                      } else {
                        return RepaintBoundary(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8).r,
                            controller: _controller,
                            physics: const BouncingScrollPhysics(),
                            cacheExtent: 500.0,
                            itemCount: state.popularServices.length + 1,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 6.h,
                            crossAxisSpacing: 6.w,
                            mainAxisExtent: 185.h,
                          ),
                          itemBuilder: (context, index) {
                            if (state.popularServices.isNotEmpty &&
                                index >= state.popularServices.length) {
                              if (state.hasPopularServicesReachedMax) {
                                return const SizedBox.shrink();
                              } else {
                                return LoadingAnimation(
                                  height: 50.h,
                                  width: 50.w,
                                );
                              }
                            } else {
                              final service = state.popularServices[index];
                              return RepaintBoundary(
                                child: PopularServiceCard(
                                  service: service,
                                  nameStyle:
                                      context.textTheme.bodySmall!.copyWith(
                                    color: Colors.white,
                                  ),
                                  iconTop: 5.h,
                                  iconEnd: 5.w,
                                  onTap: () {
                                    context.router.push(
                                      ServiceDetailsRoute(service: service),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                          ),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }
}
