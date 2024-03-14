import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_46/business/helpers/image/image_helper.dart';
import 'package:pp_46/presentation/pages/ideas_view.dart';
import 'package:pp_46/presentation/pages/notes_view.dart';
import 'package:pp_46/presentation/pages/quotes_view.dart';
import 'package:pp_46/presentation/pages/settings_view.dart';
import 'package:pp_46/presentation/themes/app_theme.dart';
import 'package:theme_provider/theme_provider.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  _MainScreenViewState createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const NotesView(),
    const IdeasView(),
    const QuotesView(),
    const SettingsView(),
  ];

  void _navigate(int index) => setState(() {
        _currentIndex = index;
      });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeProvider.themeOf(context).id == DefaultTheme.dark.id;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        margin: const EdgeInsets.only(left: 51, right: 51, bottom: 34),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.15),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavItem(
                icon: ImageHelper.svgImage(
                  isDarkMode
                      ? _currentIndex == 0
                          ? SvgNames.notesLight
                          : SvgNames.notesDark
                      : _currentIndex == 0
                          ? SvgNames.notesDark
                          : SvgNames.notesLight,
                  width: 55,
                  height: 55,
                ),
                callback: () => _navigate(0),
              ),
              const SizedBox(width: 12.5),
              NavItem(
                icon: ImageHelper.svgImage(
                  isDarkMode
                      ? _currentIndex == 1
                          ? SvgNames.ideasLight
                          : SvgNames.ideasDark
                      : _currentIndex == 1
                          ? SvgNames.ideasDark
                          : SvgNames.ideasLight,
                  width: 55,
                  height: 55,
                ),
                callback: () => _navigate(1),
              ),
              const SizedBox(width: 12.5),
              NavItem(
                icon: ImageHelper.svgImage(
                  isDarkMode
                      ? _currentIndex == 2
                          ? SvgNames.quotesLight
                          : SvgNames.quotesDark
                      : _currentIndex == 2
                          ? SvgNames.quotesDark
                          : SvgNames.quotesLight,
                  width: 55,
                  height: 55,
                ),
                callback: () => _navigate(2),
              ),
              const SizedBox(width: 12.5),
              NavItem(
                icon: ImageHelper.svgImage(
                  isDarkMode
                      ? _currentIndex == 3
                          ? SvgNames.settingsLight
                          : SvgNames.settingsDark
                      : _currentIndex == 3
                          ? SvgNames.settingsDark
                          : SvgNames.settingsLight,
                  width: 55,
                  height: 55,
                ),
                callback: () => _navigate(3),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.callback,
    this.background,
  });

  final VoidCallback callback;
  final Widget icon;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 55,
      child: CupertinoButton(
        onPressed: () => callback.call(),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            icon,
          ],
        ),
      ),
    );
  }
}
