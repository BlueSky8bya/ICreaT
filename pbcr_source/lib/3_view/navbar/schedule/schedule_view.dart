import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:icreat_dct/3_view/components/layout/safe_scaffold.dart';
import 'package:icreat_dct/3_view/components/chip/select_chip_list.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

import 'components/calendar_section_widget.dart';
import 'components/loading_status_widget.dart';
import 'components/schedule_list.dart';
import 'schedule_view_model.dart';

class ScheduleView extends GetView<ScheduleViewModel> {
  const ScheduleView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      backgroundColor: context.bgPrimaryHoverPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CalendarSectionWidget(controller: controller),
          Expanded(
            child: PageView.builder(
              key: controller.pageStorageKey,
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged, // call after page update
              itemCount: controller.pageCount,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    const SizedBox.shrink(),
                    SelectChipList<ScheduleFilter>(
                      data: [
                        (ScheduleFilter.all, '전체'),
                        (ScheduleFilter.notSubmitted, '미제출'),
                        (ScheduleFilter.pending, '검토중'),
                        (ScheduleFilter.submitted, '제출'),
                        (ScheduleFilter.redo, '재수행'),
                      ],
                      selectedData: {controller.selectedFilter},
                      onSelected: controller.onSelectScheduleFilter,
                    ),
                    Expanded(
                      child: Obx(() => LoadingStatusWidget(
                        key: Key(controller.scheduleListUpdateKey),
                        status: controller.loadingStatus,
                        onRefresh: controller.onRefresh,
                        child: ScheduleListWidget(
                          list: controller.getScheduleListInPage(index),
                          onTap: (schedule) => controller.onTapSchedule(context, schedule: schedule),
                          onRefresh: controller.onRefresh,
                        ))),
                    ),
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
