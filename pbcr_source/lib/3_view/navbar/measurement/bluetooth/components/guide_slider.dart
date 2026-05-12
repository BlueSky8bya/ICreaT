import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:icreat_dct/3_view/components/rounded_card.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

class GuideSlider extends StatefulWidget {
  final CarouselSliderController? sliderController;
  final List<String> imagePathList;
  final bool autoPlay;
  final Duration autoPlayInterval;

  final Color? activeColor;
  final Color? inactiveColor;

  final Function(int index)? onPageChanged;

  const GuideSlider({
    super.key,
    this.sliderController,
    required this.imagePathList,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.onPageChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  @override
  State<GuideSlider> createState() => _GuideSliderState();
}

class _GuideSliderState extends State<GuideSlider> {
  final RxDouble _dotsPosition = (0.0).obs;

  double get dotsPosition => _dotsPosition.value;

  DotsDecorator get defaultDotsDecorator => DotsDecorator(
        activeColor: widget.activeColor ?? context.bgBrand,
        color: widget.inactiveColor ?? context.bgBrandSubtitle,
        activeSize: const Size(18.0, 9.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, box) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: box.maxWidth,
                maxHeight: box.maxHeight - 50,
              ),
              child: NotificationListener<ScrollNotification>(
                onNotification: _onChangeScroll,
                child: CarouselSlider(
                  carouselController: widget.sliderController,
                  items: [
                    ...widget.imagePathList
                        .map((path) => GuidePage(imagePath: path)),
                  ],
                  options: CarouselOptions(
                    viewportFraction: 1,
                    scrollPhysics: const BouncingScrollPhysics(),
                    enableInfiniteScroll: false,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    enlargeCenterPage: true,
                    aspectRatio: 1,
                    autoPlay: widget.autoPlay,
                    autoPlayInterval: widget.autoPlayInterval,
                    onPageChanged: (index, reason) {
                      if (widget.onPageChanged != null) {
                        widget.onPageChanged!(index);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Obx(
              () => DotsIndicator(
                dotsCount: widget.imagePathList.length,
                position: dotsPosition,
                decorator: defaultDotsDecorator,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _onChangeScroll(ScrollNotification scrollNotification) {
    final metrics = scrollNotification.metrics;
    if (metrics is PageMetrics && metrics.page != null) {
      _dotsPosition.value = metrics.page!;
    }
    return false;
  }
}

class GuidePage extends StatelessWidget {
  const GuidePage({super.key, required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(imagePath, width: double.infinity),
      ),
    );
  }
}
