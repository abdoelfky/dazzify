import 'package:dazzify/core/framework/export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DazzifyIconMenu extends StatefulWidget {
  final bool removeInitialBackground;
  final List<MenuOption> options;

  const DazzifyIconMenu(
      {super.key, required this.options, this.removeInitialBackground = false});

  @override
  State<DazzifyIconMenu> createState() => _DazzifyIconMenuState();
}

class _DazzifyIconMenuState extends State<DazzifyIconMenu> {
  bool _isMenuOpen = false;
  IconData _menuIcon = SolarIconsOutline.menuDots;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isMenuOpen = !_isMenuOpen;
          _menuIcon = _isMenuOpen ? Icons.close : SolarIconsOutline.menuDots;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _isMenuOpen ? (widget.options.length * 70.0).h : 44.h,
        curve: Curves.easeInOut,
        width: 40.w,
        decoration: BoxDecoration(
          color: (widget.removeInitialBackground && !_isMenuOpen)
              ? Colors.transparent
              : Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12).r,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              key: ValueKey(_menuIcon),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isMenuOpen = !_isMenuOpen;
                    _menuIcon =
                        _isMenuOpen ? Icons.close : SolarIconsOutline.menuDots;
                  });
                },
                child: Padding(
                  padding: _isMenuOpen
                      ? EdgeInsets.only(top: 16).r
                      : EdgeInsets.zero,
                  child: Icon(
                    _menuIcon,
                    size: 26.r,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (_isMenuOpen)
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16).r,
                  children: widget.options.map<Widget>((option) {
                    if (option.icon != null){
                      return GestureDetector(
                        onTap: option.onTap,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16).r,
                          child: Icon(
                            option.icon,
                            size: 26.r,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    if (option.svgIcon != null) {
                      return GestureDetector(
                        onTap: option.onTap,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16).r,
                          child: SizedBox(
                            width: 26.r,
                            height: 26.r,
                            child: SvgPicture.asset(
                              option.svgIcon!,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MenuOption {
  final IconData? icon;
  final String? svgIcon;
  final Function() onTap;

  MenuOption({
    this.icon,
    this.svgIcon,
    required this.onTap,
  });
}
