import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/format.dart';

import '../../common_widgets/appbar_blur_bg.dart';
import '../../common_widgets/choice_chips_app_bar_widget.dart';
import '../../common_widgets/custom_list_tile_3.dart';
import '../../common_widgets/list_item_builder.dart';
import '../../constants.dart';
import '../../models/routine.dart';
import '../../services/database.dart';
import '../library_tab/routine/routine_detail_screen.dart';

class StartWorkoutShortcutScreen extends StatefulWidget {
  const StartWorkoutShortcutScreen({Key key, this.database}) : super(key: key);

  final Database database;

  static void show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);

    HapticFeedback.mediumImpact();

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => StartWorkoutShortcutScreen(
          database: database,
        ),
      ),
    );
  }

  @override
  _StartWorkoutShortcutScreenState createState() =>
      _StartWorkoutShortcutScreenState();
}

class _StartWorkoutShortcutScreenState
    extends State<StartWorkoutShortcutScreen> {
  String _selectedChip = 'All';

  // set string(String value) => setState(() => _selectedChip = value);

  @override
  Widget build(BuildContext context) {
    debugPrint('scaffold building...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: true,
              title: const Text('Choose Routine to Start', style: Subtitle1),
              flexibleSpace: const AppbarBlurBG(),
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              bottom: ChoiceChipsAppBarWidget(
                callback: (value) {
                  setState(() {
                    _selectedChip = value;
                  });
                },
              ),
            ),
          ];
        },
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: StreamBuilder<List<Routine>>(
        stream: (_selectedChip == 'All')
            ? widget.database.routinesStream()
            : widget.database.routinesSearchStream(
                searchCategory: 'mainMuscleGroup',
                isEqualTo: _selectedChip,
              ),
        builder: (context, snapshot) {
          return ListItemBuilder<Routine>(
            emptyContentTitle: 'No $_selectedChip Routines yet...',
            snapshot: snapshot,
            itemBuilder: (context, routine) {
              final trainingLevel = Format.difficulty(routine.trainingLevel);
              final String weights = Format.weights(routine.totalWeights);
              final String unit = Format.unitOfMass(routine.initialUnitOfMass);

              final duration =
                  Duration(seconds: routine?.duration ?? 0).inMinutes;

              return CustomListTile3(
                isLeadingDuration: true,
                tag: 'startShortcut-${routine.routineId}',
                title: routine.routineTitle,
                leadingText: '$duration',
                subtitle: '$trainingLevel, $weights $unit',
                subtitle2: 'by ${routine.routineOwnerUserName}',
                imageUrl: routine.imageUrl,
                onTap: () => RoutineDetailScreen.show(
                  context,
                  routine: routine,
                  isRootNavigation: false,
                  tag: 'startShortcut-${routine.routineId}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
