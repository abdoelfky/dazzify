import 'dart:ui';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/shared/widgets/category_selectable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

class AnimatedFilterButton extends StatefulWidget {
  final void Function(int index) onItemTap;
  final Color? iconColor;

  const AnimatedFilterButton({
    super.key,
    required this.onItemTap,
    this.iconColor,
  });

  @override
  State<AnimatedFilterButton> createState() => _AnimatedFilterButtonState();
}

class _AnimatedFilterButtonState extends State<AnimatedFilterButton>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<double> _categoriesHeight;
  late final AnimationController _iconRotationController;
  late final ValueNotifier<bool> _isIconRotated;
  late final ValueNotifier<int?> _selectedIndex;

  void _onCategoryTap(int index) {
    if (_selectedIndex.value == index) {
      _selectedIndex.value = null;
    } else {
      _selectedIndex.value = index;
    }
  }

  void _toggleAnimation() {
    if (_categoriesHeight.value == 55) {
      _categoriesHeight.value = 344;
    } else {
      _categoriesHeight.value = 55;
    }
    _isIconRotated.value = !_isIconRotated.value;
    if (_isIconRotated.value) {
      _iconRotationController.forward(from: 0.0);
    } else {
      _iconRotationController.reverse(from: 1.0);
    }
  }

  @override
  void initState() {
    _categoriesHeight = ValueNotifier<double>(55);
    _isIconRotated = ValueNotifier(false);
    _selectedIndex = ValueNotifier(null);
    _iconRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _categoriesHeight,
      builder: (context, height, child) => ClipRRect(
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          width: 72.w,
          height: height.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10).r,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  _toggleAnimation();
                },
                icon: RotationTransition(
                  turns: _iconRotationController,
                  child: Icon(
                    SolarIconsOutline.widget_6,
                    color: widget.iconColor ?? Colors.white,
                    size: 24.r,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                height: _isIconRotated.value ? 280.h : 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10).r,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.inversePrimary
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10).r,
                      ),
                      child: ListView.builder(
                        itemCount: mainCategories.length,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0).r,
                            child: ValueListenableBuilder(
                              valueListenable: _selectedIndex,
                              builder: (context, value, child) =>
                                  CategorySelectableButton(
                                imagePath: mainCategories[index].image,
                                title: mainCategories[index].name,
                                isAnimated: _isIconRotated.value,
                                isSelected: _selectedIndex.value == index,
                                onTap: () {
                                  _onCategoryTap(index);
                                  widget.onItemTap(index);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _categoriesHeight.dispose();
    _iconRotationController.dispose();
    _isIconRotated.dispose();
    super.dispose();
  }
}
