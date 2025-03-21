import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/shared/logic/tokens/tokens_cubit.dart';
import 'package:dazzify/settings/theme/colors_scheme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Use a Tween to animate between 0 and 0.7 (70% of the container height)
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TokensCubit, TokensState>(
      listener: (context, state) {},
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorsSchemeManager.light.primary,
                      ColorsSchemeManager.light.secondary,
                    ],
                    // Adjusted stops to give more space to the second color
                    stops: [
                      _animation.value - 0.3,
                      // Allow the first color to go slightly offscreen at the top
                      _animation.value + 0.3,
                      // The second color's range is now larger
                    ],
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10,
                ),
                child: Container(
                  color: const Color(0xFF4B108D).withValues(alpha: 0.5),
                ),
              ),
              Center(
                child: Lottie.asset(
                  AssetsManager.splashAnimatedAppLogo,
                  repeat: false,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
