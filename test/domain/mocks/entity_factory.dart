import 'package:faker/faker.dart';

import 'package:surveys/domain/entities/entities.dart';

class EntityFactory {
  static AccountEntity makeAccount() => AccountEntity(
        faker.guid.guid(),
      );

  static SurveyResultEntity makeSurveyResult() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            image: faker.internet.httpUrl(),
            answer: faker.lorem.sentence(),
            isCurrentAnswer: true,
            percent: 40,
          ),
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: false,
            percent: 60,
          ),
        ],
      );

  static List<SurveyEntity> makeSurveyList() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          date: DateTime.utc(2022, 2, 2),
          didAnswer: true,
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          date: DateTime.utc(2020, 12, 20),
          didAnswer: false,
        ),
      ];
}
