import '../models/learning_unit_model.dart';

class DuolingoListViewModel {
  final List<LearningUnitModel> units = [
    LearningUnitModel(
      unit: 1,
      description: "Learn Korean Vowels",
      lessonAmount: 5,
      lessonContext: "Something about the Lesson",
    ),
    LearningUnitModel(
      unit: 2,
      description: "Learn Korean Consoants",
      lessonAmount: 5,
      lessonContext: "Something about the Lesson",
    ),
    LearningUnitModel(
      unit: 3,
      description: "Learn more consoants",
      lessonAmount: 5,
      lessonContext: "Something about the Lesson",
    ),
    LearningUnitModel(
      unit: 4,
      description: "Learn basic phrases",
      lessonAmount: 5,
      lessonContext: "Something about the Lesson",
    ),
    LearningUnitModel(
      unit: 5,
      description: "learn common objects",
      lessonAmount: 5,
      lessonContext: "Something about the Lesson",
    ),
  ];
}
