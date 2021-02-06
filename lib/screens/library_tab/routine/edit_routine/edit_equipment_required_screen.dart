import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

class EditEquipmentRequiredScreen extends StatefulWidget {
  const EditEquipmentRequiredScreen({
    Key key,
    this.routine,
    this.database,
    this.user,
  }) : super(key: key);

  final Routine routine;
  final Database database;
  final User user;

  static Future<void> show(BuildContext context, {Routine routine}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EditEquipmentRequiredScreen(
          database: database,
          routine: routine,
          user: auth.currentUser,
        ),
      ),
    );
  }

  @override
  _EditEquipmentRequiredScreenState createState() =>
      _EditEquipmentRequiredScreenState();
}

class _EditEquipmentRequiredScreenState
    extends State<EditEquipmentRequiredScreen> {
  Map<String, bool> _equipmentRequired = {
    'Barbell': false,
    'Dumbbell': false,
    'Bodyweight': false,
    'Cable': false,
    'Machine': false,
    'EZ Bar': false,
    'Gym ball': false,
    'Bench': false,
  };
  List _selectedEquipmentRequired = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, bool> equipmentRequired = {
      'Barbell':
          (widget.routine.equipmentRequired.contains('Barbell')) ? true : false,
      'Dumbbell': (widget.routine.equipmentRequired.contains('Dumbbell'))
          ? true
          : false,
      'Bodyweight': (widget.routine.equipmentRequired.contains('Bodyweight'))
          ? true
          : false,
      'Cable':
          (widget.routine.equipmentRequired.contains('Cable')) ? true : false,
      'Machine':
          (widget.routine.equipmentRequired.contains('Machine')) ? true : false,
      'EZ Bar':
          (widget.routine.equipmentRequired.contains('EZ Bar')) ? true : false,
      'Gym ball': (widget.routine.equipmentRequired.contains('Gym ball'))
          ? true
          : false,
      'Bench':
          (widget.routine.equipmentRequired.contains('Bench')) ? true : false,
    };
    _equipmentRequired = equipmentRequired;
    _equipmentRequired.forEach((key, value) {
      if (_equipmentRequired[key]) {
        _selectedEquipmentRequired.add(key);
      } else {
        _selectedEquipmentRequired.remove(key);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _addOrRemoveEquipmentRquired(String key, bool value) async {
    setState(() {
      _equipmentRequired[key] = value;
    });
    if (_equipmentRequired[key]) {
      _selectedEquipmentRequired.add(key);
      final routine = {
        'equipmentRequired': _selectedEquipmentRequired,
      };
      await widget.database.updateRoutine(widget.routine, routine);
    } else {
      _selectedEquipmentRequired.remove(key);
      final routine = {
        'equipmentRequired': _selectedEquipmentRequired,
      };
      await widget.database.updateRoutine(widget.routine, routine);
    }
    debugPrint('$_selectedEquipmentRequired');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Equipment Required', style: Subtitle1),
        flexibleSpace: widget.routine == null ? null : AppbarBlurBG(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: _equipmentRequired.keys.map((String key) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: (_equipmentRequired[key]) ? PrimaryColor : Grey700,
                      child: CheckboxListTile(
                        selected: _equipmentRequired[key],
                        activeColor: Primary700Color,
                        title: Text(key, style: ButtonText),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: _equipmentRequired[key],
                        onChanged: (bool value) =>
                            _addOrRemoveEquipmentRquired(key, value),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
