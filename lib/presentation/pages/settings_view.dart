import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_46/business/helpers/image/image_helper.dart';
import 'package:pp_46/business/services/navigation/route_names.dart';
import 'package:pp_46/presentation/pages/agreement_view.dart';
import 'package:pp_46/presentation/themes/app_theme.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  void _switchTheme() {
    final currentId = ThemeProvider.themeOf(context).id;
    String? oppositeId;
    if (currentId == DefaultTheme.dark.id) {
      oppositeId = DefaultTheme.light.id;
    } else {
      oppositeId = DefaultTheme.dark.id;
    }
    ThemeProvider.controllerOf(context).setTheme(oppositeId);
  }

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ThemeProvider.themeOf(context).id == DefaultTheme.dark.id;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SettingsItem(
                        svgIcon: ImageHelper.svgImage(
                          SvgNames.support,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        label: 'Support',
                        callback: () => Navigator.of(context).pushNamed(RouteNames.support),
                      ),
                      const SizedBox(height: 10),
                      SettingsItem(
                        svgIcon: ImageHelper.svgImage(
                          SvgNames.share,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        label: 'Share app',
                        callback: () {},
                      ),
                      const SizedBox(height: 10),
                      SettingsItem(
                        svgIcon: ImageHelper.svgImage(
                          SvgNames.privacy,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        label: 'Privacy Policy',
                        callback: () => Navigator.of(context).pushNamed(RouteNames.agreement, arguments: AgreementType.privacy),
                      ),
                      const SizedBox(height: 10),
                      SettingsItem(
                        svgIcon: ImageHelper.svgImage(
                          SvgNames.terms,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        label: 'Terms of use',
                        callback: () => Navigator.of(context).pushNamed(RouteNames.agreement, arguments: AgreementType.terms),
                      ),
                      const SizedBox(height: 10),
                      SettingsItem(
                        svgIcon: ImageHelper.svgImage(
                          SvgNames.contact,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        label: 'Contact developer',
                        callback: () {},
                      ),
                      const SizedBox(height: 10),
                      SettingsItem(
                        svgIcon: ImageHelper.svgImage(
                          SvgNames.darkTheme,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        label: 'Dark theme',
                        suffix: CupertinoSwitch(
                          value: isDarkMode,
                          onChanged: (bool value) {
                            _switchTheme();
                            setState(() {
                              isDarkMode = value;
                            });
                          },
                        ),
                        callback: _switchTheme,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem(
      {super.key, required this.svgIcon, required this.label, required this.callback, this.suffix});

  final Widget svgIcon;
  final String label;
  final VoidCallback callback;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeProvider.themeOf(context).id == DefaultTheme.dark.id;
    return CupertinoButton(
      onPressed: callback,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: isDarkMode ? Border.all(color: const Color(0xFF828282)) : null,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(10), width: 44, height: 44, child: svgIcon),
            const SizedBox(height: 10),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            const Spacer(),
            suffix != null
                ? suffix!
                : const Icon(
                    CupertinoIcons.chevron_forward,
                    size: 24,
                    color: Color(0xFF828282),
                  )
          ],
        ),
      ),
    );
  }
}
