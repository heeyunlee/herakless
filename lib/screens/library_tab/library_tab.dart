import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/sliver_app_bar_delegate.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/settings/settings_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';
import '../../format.dart';
import 'activity/saved_routine_histories_tab.dart';
import 'routine/saved_routines_tab.dart';
import 'workout/saved_workouts.dart';

class LibraryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('scaffold building...');

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: BackgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.settings_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => SettingsScreen.show(context),
                  ),
                  const SizedBox(width: 8),
                ],
                expandedHeight: 200,
                floating: true,
                pinned: true,
                snap: false,
                centerTitle: true,
                flexibleSpace: _FlexibleSpace(),
                backgroundColor: AppBarColor,
                elevation: 0,
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: SliverAppBarDelegate(
                  TabBar(
                    unselectedLabelColor: Colors.white,
                    labelColor: PrimaryColor,
                    indicatorColor: PrimaryColor,
                    tabs: [
                      const Tab(text: 'Activities'),
                      const Tab(text: 'Routines'),
                      const Tab(text: 'Workouts'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SavedRoutineHistoriesTab(),
              SavedRoutinesTab(),
              SavedWorkoutsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlexibleSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    return FlexibleSpaceBar(
      background: StreamBuilder<User>(
          initialData: User(
            userName: 'John Doe',
            unitOfMass: 1,
            totalWeights: 0,
            totalNumberOfWorkouts: 0,
            signUpDate: null,
            userEmail: null,
            signUpProvider: null,
            userId: null,
          ),
          stream: database.userStream(userId: auth.currentUser.uid),
          builder: (context, snapshot) {
            final Size size = MediaQuery.of(context).size;

            final User user = snapshot.data;

            final String weights = Format.weights(user.totalWeights);
            final String unit = Format.unitOfMass(user.unitOfMass);
            final int numberOfWorkouts = user.totalNumberOfWorkouts;
            final String times = (numberOfWorkouts == 0) ? 'time' : 'times';

            return Column(
              children: <Widget>[
                const SizedBox(height: 64),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(width: 16),
                    Text(user.userName, style: Subtitle1w900),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  color: PrimaryColor,
                  child: Container(
                    height: 80,
                    width: size.width - 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text('Total Weights', style: Caption1),
                              const SizedBox(height: 8),
                              Text(
                                '$weights $unit',
                                style: Headline6w900,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          width: 1,
                          height: 56,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        Container(
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text('Total Activities', style: Caption1),
                              const SizedBox(height: 8),
                              Text(
                                '$numberOfWorkouts $times',
                                style: Subtitle1w900,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
