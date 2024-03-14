import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_46/business/helpers/image/image_helper.dart';
import 'package:pp_46/business/services/navigation/route_names.dart';
import 'package:pp_46/data/repository/database_keys.dart';
import 'package:pp_46/data/repository/database_service.dart';
import 'package:pp_46/presentation/themes/custom_colors.dart';
import 'package:pp_46/presentation/widgets/app_button.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _databaseService = GetIt.instance<DatabaseService>();

  int currentStep = 0;

  final images = [
    ImageHelper.getImage(ImageNames.onb1),
    ImageHelper.getImage(ImageNames.onb2),
    ImageHelper.getImage(ImageNames.onb3),
  ];

  final title = [
    'Welcome!',
    'Your thoughts are our app.',
    'Where ideas take shape!',
  ];

  final description = [
    'Glad to see you on our app,\ncreate, seek inspiration and grow!',
    'Gathered everything you need\nfor your notes or ideas!',
    'Step into a world of endless possibilities.'
  ];

  void _increaseStep() {
    if (currentStep == 2) {
      Navigator.of(context).pushReplacementNamed(RouteNames.main);
      return;
    }
    setState(() {
      currentStep += 1;
    });
  }

  void _decreaseStep() {
    if (currentStep == 0) {
      return;
    }
    setState(() {
      currentStep -= 1;
    });
  }

  void _init() {
    _databaseService.put(DatabaseKeys.seenOnboarding, true);
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: images[currentStep].image,
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
            child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.6),
            Text(
              title[currentStep],
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description[currentStep],
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            AppButton(
              name: 'Next',
              textColor: Colors.white,
              callback: _increaseStep,
              backgroundColor: Colors.black,
            )
          ],
        )),
      ),
    );
  }
}
