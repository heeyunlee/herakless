import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/food_item.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/utils/formatter.dart';

class NutritionsDetailScreenModel with ChangeNotifier {
  void delete(BuildContext context) {}

  /// VIEW MODEL
  static String title(Nutrition nutrition) {
    if (nutrition.description != null) {
      if (nutrition.description!.isNotEmpty) {
        return nutrition.description!;
      } else {
        return S.current.addDescription;
      }
    } else {
      return S.current.addDescription;
    }
  }

  static String foodItemProtein(FoodItem foodItem) {
    final protein = Formatter.numWithOrWithoutDecimal(foodItem.proteins);
    final unit = Formatter.unitOfMassGram(null, foodItem.unitOfMass);

    return '$protein $unit';
  }

  static String foodItemCalories(FoodItem foodItem) {
    final calorie = Formatter.numWithOrWithoutDecimal(foodItem.calories);

    return '$calorie Kcal';
  }

  static String merchantName(Nutrition nutrition) {
    final name = nutrition.merchantName;

    if (name != null) {
      return name;
    } else {
      return '';
    }
  }

  static String mealType(Nutrition nutrition) {
    final type = EnumToString.convertToString(nutrition.type, camelCase: true);

    return type;
  }

  static String totalCalories(Nutrition nutrition) {
    final calorie = Formatter.numWithOrWithoutDecimal(nutrition.calories);

    return '$calorie Kcal';
  }

  static String totalFat(Nutrition nutrition) {
    final fat = Formatter.numWithOrWithoutDecimal(nutrition.fat);
    final unit = Formatter.unitOfMassGram(null, nutrition.unitOfMass);

    return '$fat $unit';
  }

  static String totalCarbs(Nutrition nutrition) {
    final carbs = Formatter.numWithOrWithoutDecimal(nutrition.carbs);
    final unit = Formatter.unitOfMassGram(null, nutrition.unitOfMass);

    return '$carbs $unit';
  }

  static String totalProtein(Nutrition nutrition) {
    final protein = Formatter.numWithOrWithoutDecimal(nutrition.proteinAmount);
    final unit = Formatter.unitOfMassGram(null, nutrition.unitOfMass);

    return '$protein $unit';
  }

  static String notes(Nutrition nutrition) {
    if (nutrition.notes != null) {
      if (nutrition.notes!.isNotEmpty) {
        return nutrition.notes!;
      } else {
        return S.current.addNotes;
      }
    } else {
      return S.current.addNotes;
    }
  }
}
