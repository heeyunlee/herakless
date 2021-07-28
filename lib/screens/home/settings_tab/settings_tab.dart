import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/enum/unit_of_mass.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/screens/home/settings_tab/personal_goals/personal_goals_screen.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import 'change_language_screen.dart';
import 'manage_account/manage_account_screen.dart';
import 'settings_tab_model.dart';
import 'unit_of_mass_screen.dart';
import 'user_feedback_screen.dart';

class SettingsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    logger.d('Settings Tab scaffold building...');

    final model = watch(settingsTabModelProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        flexibleSpace: const AppbarBlurBG(blurSigma: 10),
        backgroundColor: Colors.transparent,
        title: Text(S.current.settingsScreenTitle, style: TextStyles.subtitle1),
      ),
      body: Builder(
        builder: (BuildContext context) => _buildBody(context, model),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SettingsTabModel model) {
    final database = provider.Provider.of<Database>(context, listen: false);

    return CustomStreamBuilderWidget<User?>(
      stream: database.userStream(),
      // errorWidget: EmptyContent(),
      // loadingWidget: Container(
      //   child: Center(
      //     child: ListTile(
      //       onTap: () => model.confirmSignOut(context),
      //       leading: const Icon(Icons.logout, color: Colors.white),
      //       title: Text(S.current.logout, style: TextStyles.body2),
      //     ),
      //   ),
      // ),
      hasDataWidget: (context, user) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                S.current.account,
                style: TextStyles.body2_grey_bold,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: Text(
                S.current.manageAccount,
                style: TextStyles.body2,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 20,
              ),
              onTap: () => ManageAccountScreen.show(
                context,
                user: user!,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.straighten_rounded,
                color: Colors.white,
              ),
              title: Text(
                S.current.unitOfMass,
                style: TextStyles.body2,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    UnitOfMass.values[user!.unitOfMass].label!,
                    style: TextStyles.body2_grey,
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                ],
              ),
              onTap: () => UnitOfMassScreen.show(
                context,
                user: user,
              ),
            ),

            // LANGUAGE
            ListTile(
              leading: const Icon(
                Icons.language_rounded,
                color: Colors.white,
              ),
              title: Text(
                S.current.launguage,
                style: TextStyles.body2,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Intl.getCurrentLocale(),
                    style: TextStyles.body2_grey,
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                ],
              ),
              onTap: () => ChangeLanguageScreen.show(context),
            ),

            // PERSONAL GOALS
            ListTile(
              leading: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.white,
              ),
              title: Text(
                S.current.personalGoals,
                style: TextStyles.body2,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 20,
              ),
              onTap: () => PersonalGoalsScreen.show(context, isRoot: false),
            ),

            // SUPPORT
            kCustomDivider,
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                S.current.support,
                style: TextStyles.body2_grey_bold,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.white),
              title: Text(
                S.current.FeedbackAndFeatureRequests,
                style: TextStyles.body2,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 20,
              ),
              onTap: () => UserFeedbackScreen.show(context),
            ),

            // ABOUT
            kCustomDivider,
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                S.current.about,
                style: TextStyles.body2_grey_bold,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
              title: Text(S.current.about, style: TextStyles.body2),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 20,
              ),
              onTap: () => model.showAboutDialogOfApp(context),
            ),
            ListTile(
              leading: const Icon(
                Icons.policy_outlined,
                color: Colors.white,
              ),
              title: Text(
                S.current.privacyPolicy,
                style: TextStyles.body2,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 20,
              ),
              onTap: model.launchPrivacyServiceURL,
            ),
            ListTile(
              leading: const Icon(
                Icons.description_rounded,
                color: Colors.white,
              ),
              title: Text(S.current.terms, style: TextStyles.body2),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 20,
              ),
              onTap: model.launchTermsURL,
            ),

            // LOG IN
            kCustomDivider,
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                S.current.logIn,
                style: TextStyles.body2_grey_bold,
              ),
            ),
            ListTile(
              onTap: () => model.confirmSignOut(context),
              leading: const Icon(Icons.logout, color: Colors.white),
              title: Text(S.current.logout, style: TextStyles.body2),
            ),
            const SizedBox(height: 48),
            // TODO: CHANGE VERSION CODE HERE
            Center(
              child: const Text('v.0.3.3', style: TextStyles.caption1_grey),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
