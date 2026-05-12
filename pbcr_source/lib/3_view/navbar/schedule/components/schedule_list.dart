import 'package:flutter/material.dart';

import 'package:icreat_dct/0_data/model/epro/epro_schedule_model.dart';
import 'package:icreat_dct/3_view/components/dialog/confirm_dialog.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

import 'schedule_item_title.dart';

class ScheduleListWidget extends StatelessWidget {
  final List<ScheduleItemModel> list;
  final void Function(ScheduleItemModel schedule) onTap;
  final VoidCallback? onRefresh;

  const ScheduleListWidget({
    super.key,
    required this.list,
    required this.onTap,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final height = constraints.maxHeight;
        return RefreshIndicator(
          onRefresh: () async => onRefresh?.call(),
          child: list.isEmpty
            ? SizedBox(
              height: height,
              child: Center(
                child: Text('일정이 없습니다.', style: TextStyles.body1.semiBold),
              ),
            )
            : ListView.separated(
              itemCount: list.length,
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => ScheduleItemTile(
                schedule: list[index],
                onTap: (schedule) {
                  if (schedule.isPending) {
                    showDialog<String>(
                      context: context,
                      barrierColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return ConfirmDialog(
                          title: "연구진이 확인 중입니다.",
                          message: "연구진이 확인 중인 수행 내역을 재수행시 예상치 못한 문제가 발생할 수 있습니다.",
                          ok: "재수행합니다.",
                          onOk: () => onTap(schedule),
                          onCancel: () => {},
                        );
                      });
                  } else {
                    onTap(schedule);
                  }
                },
              ),
            ));
      },
    );
  }
}
