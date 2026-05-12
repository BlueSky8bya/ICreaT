/*
import 'package:collection/collection.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:icreat_dct/0_data/model/health/sleep_model.dart';
import 'package:icreat_dct/0_data/model/health/step_model.dart';
import 'package:icreat_dct/util/device_info.dart';
import 'package:icreat_dct/util/logger.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:icreat_dct/8_extension/int_ext.dart';

class AppleHealthRepository {
  AppleHealthRepository();

  void _observerQuery({
    required List<String> identifiers,
    required Predicate predicate,
    required Function(String) onUpdate,
  }) async {
    assert(predicate.startDate.isBefore(predicate.endDate),
        AssertionError("The start time must be before end time."));

    HealthKitReporter.observerQuery(identifiers, predicate, onUpdate: onUpdate);
    // FIX:
    // PlatformException(EnableBackgroundDelivery, Error in enableBackgroundDelivery, Optional(Error Domain=com.apple.healthkit Code=4 "Missing com.apple.developer.healthkit.background-delivery entitlement." UserInfo={NSLocalizedDescription=Missing com.apple.developer.healthkit.background-delivery entitlement.}), null)
    // for (final identifier in identifiers) {
    //   Logger.info(identifier);
    //   try {
    //     await HealthKitReporter.enableBackgroundDelivery(
    //         identifier, UpdateFrequency.immediate);
    //   } catch (e, s) {
    //     Logger.error(e.toString(), e: e, s: s);
    //   }
    // }
  }

  Future<void> requestHealthAuth() async {
    if (DeviceInfo.isIOS) {
      await HealthKitReporter.requestAuthorization([
        QuantityType.stepCount.identifier,
        CategoryType.sleepAnalysis.identifier
      ], []);
    }
  }

  void _observerQueryForQuantityQuery(
    List<QuantityType> identifiers,
    DateTime start,
    DateTime end,
    void Function(String) callback,
  ) {
    Predicate predicate = Predicate(start, end);

    _observerQuery(
      identifiers: identifiers.map((e) => e.identifier).toList(),
      predicate: predicate,
      onUpdate: callback,
    );
  }

  void observerStepCount(
      DateTime start, DateTime end, void Function(String) callback) {
    _observerQueryForQuantityQuery(
      [QuantityType.stepCount],
      DateTimeExt.getToday(),
      DateTime.now().withEndTime(),
      (identifier) => callback(identifier),
    );
  }

  Future<int> getStepCountForPeriod(
    DateTime from,
    DateTime to,
  ) async {
    int? stepCount;

    final preferredUnits =
        await HealthKitReporter.preferredUnits([QuantityType.stepCount]);
    final stepPreferredUnit = preferredUnits.firstWhereOrNull(
        (e) => e.identifier == QuantityType.stepCount.identifier);
    if (stepPreferredUnit == null) return 0;

    try {
      final stepStatistic = await HealthKitReporter.statisticsQuery(
        QuantityType.stepCount,
        stepPreferredUnit.unit,
        Predicate(from, to),
      );

      stepCount = stepStatistic.harmonized.summary?.toInt();
    } catch (e) {
      Logger.error(e.toString());
    }

    return stepCount ?? 0;
  }

  Future<List<StepModel>> getStepDataForPeriod(
    DateTime from,
    DateTime to,
  ) async {
    List<StepModel> stepDataList = [];

    final preferredUnits =
        await HealthKitReporter.preferredUnits([QuantityType.stepCount]);
    final stepPreferredUnit = preferredUnits.firstWhereOrNull(
        (e) => e.identifier == QuantityType.stepCount.identifier);
    if (stepPreferredUnit == null) return [];

    List<Quantity> stepQuantity = [];

    try {
      stepQuantity = await HealthKitReporter.quantityQuery(
        QuantityType.stepCount,
        stepPreferredUnit.unit,
        Predicate(from, to),
      );
    // ignore: empty_catches
    } catch (e) {}

    for (final quantity in stepQuantity) {
      final startAt = quantity.startTimestamp.toInt().toDateTime();
      final stepCount = quantity.harmonized.value.toInt();

      final stepData = StepModel(
        date: startAt,
        count: stepCount,
      );

      stepDataList.add(stepData);
    }

    return stepDataList;
  }

  // 취침시간이 from 이후에 속하며 기상시간이 to 이전에 속하는 수면데이터를 가져온다.
  Future<List<SleepModel>> getSleepDataForPeriod(
    DateTime from,
    DateTime to,
  ) async {
    List<SleepModel> sleepDataList = [];
    try {
      final sleepCategoryList = await HealthKitReporter.categoryQuery(
        CategoryType.sleepAnalysis,
        Predicate(from, to),
      );
      sleepDataList = sleepCategoryList
          .map(
            (e) => SleepModel(
              date: (e.startTimestamp as int).toDateTime(),
              startTime: (e.startTimestamp as int).toDateTime(),
              endTime: (e.endTimestamp as int).toDateTime(),
            ),
          )
          .toList();
    // ignore: empty_catches
    } catch (e) {}

    return sleepDataList;
  }
}
*/