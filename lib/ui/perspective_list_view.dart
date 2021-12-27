import 'dart:ui';

import 'package:flutter/material.dart';

class PerspectiveListView extends StatefulWidget {
  const PerspectiveListView({
    Key? key,
    required this.children,
    required this.itemExtent,
    required this.visualizedItems,
    this.initialIndex = 0,
    this.padding = const EdgeInsets.all(0),
    this.onTapFrontItem,
    this.onChangeItem,
    this.backItemsShadowColor = Colors.black,
  }) : super(key: key);

  final List<Widget> children;
  final double itemExtent;
  final int visualizedItems;
  final int initialIndex;
  final EdgeInsetsGeometry padding;
  final ValueChanged<int>? onTapFrontItem;
  final ValueChanged<int>? onChangeItem;
  final Color backItemsShadowColor;

  @override
  State<PerspectiveListView> createState() => _PerspectiveListViewState();
}

class _PerspectiveListViewState extends State<PerspectiveListView> {
  late PageController _pageController;
  late double _pagePercent;
  late int _currentIndex;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initialIndex, viewportFraction: 1 / widget.visualizedItems);
    _currentIndex = widget.initialIndex;
    _pagePercent = 0.0;
    _pageController.addListener(_pageListener);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  void _pageListener() {
    _currentIndex = _pageController.page!.floor();
    _pagePercent = (_pageController.page! - _currentIndex).abs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      final height = constrains.maxHeight;
      return Stack(
        children: [
          // 예정된 페이지
          Padding(
            padding: widget.padding,
            child: _PerspectiveItems(
              heightItem: widget.itemExtent,
              currentIndex: _currentIndex,
              children: widget.children,
              // 보여지는 아이템 카드 1개 빼주기
              generateItems: widget.visualizedItems - 1,
              pagePercent: _pagePercent,
            ),
          ),
          // 뒤에있는 아이템 그림자
          Positioned.fill(
              child: DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
              widget.backItemsShadowColor.withOpacity(0.8),
              widget.backItemsShadowColor.withOpacity(0),
              widget.backItemsShadowColor.withOpacity(0),
              widget.backItemsShadowColor.withOpacity(0),
              widget.backItemsShadowColor.withOpacity(0),
            ])),
          )),

          // 비어있는 페이지
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (value) {
              if (widget.onChangeItem != null) {
                widget.onChangeItem!(value);
              }
            },
            itemBuilder: (context, index) {
              return const SizedBox();
            },
          ),
          // 아이템 탭하는 지역
          Positioned.fill(
            top: height - widget.itemExtent,
            child: GestureDetector(
              onTap: () {
                if (widget.onTapFrontItem != null) {
                  widget.onTapFrontItem!(_currentIndex);
                }
              },
            ),
          )
        ],
      );
    });
  }
}

class _PerspectiveItems extends StatelessWidget {
  const _PerspectiveItems({
    Key? key,
    required this.generateItems,
    required this.currentIndex,
    required this.heightItem,
    required this.pagePercent,
    required this.children,
  }) : super(key: key);

  final int generateItems;
  final int currentIndex;
  final double heightItem;
  final double pagePercent;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      final height = constrains.maxHeight;
      return Stack(
        fit: StackFit.expand,
        children: List.generate(generateItems, (index) {
          final invertedIndex = (generateItems - 2) - index;
          final indexPlus = index + 1;
          final positionPercent = indexPlus / generateItems;
          final endPositionPercent = index / generateItems;
          return (currentIndex > invertedIndex)
              ? _TransformedItem(
                  child: children[currentIndex - (invertedIndex + 1)],
                  heightItem: heightItem,
                  factorChange: pagePercent,
                  scale: lerpDouble(0.5, 1.0, positionPercent)!,
                  endScale: lerpDouble(0.5, 1.0, endPositionPercent)!,
                  translateY: (height - heightItem) * positionPercent,
                  endTranslateY: (height - heightItem) * endPositionPercent,
                )
              : const SizedBox();
        })
          // 아래 아이템 숨기기(그냥 빡 뜨는게 아니라 아래에서 자연스럽게 올라옴
          ..add((currentIndex < children.length + 1)
              ? _TransformedItem(
                  child: children[currentIndex + 1],
                  heightItem: heightItem,
                  factorChange: pagePercent,
                  translateY: height + 20,
                  endTranslateY: height - heightItem,
                )
              : const SizedBox())
          // 상단 카드 고정하기
          ..insert(
              0,
              currentIndex > generateItems - 1
                  ? _TransformedItem(
                      child: children[currentIndex - generateItems],
                      heightItem: heightItem,
                      factorChange: 1.0,
                      endScale: 0.5,
                    )
                  : const SizedBox()),
      );
    });
  }
}

class _TransformedItem extends StatelessWidget {
  const _TransformedItem({
    Key? key,
    required this.child,
    required this.heightItem,
    required this.factorChange,
    this.scale = 1.0,
    this.endScale = 1.0,
    this.translateY = 0.0,
    this.endTranslateY = 0.0,
  }) : super(key: key);

  final Widget child;
  final double heightItem;
  final double factorChange;
  final double scale;
  final double endScale;
  final double translateY;
  final double endTranslateY;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.topCenter,
      transform: Matrix4.identity()
        // 크기 점점 줄이기
        ..scale(lerpDouble(scale, endScale, factorChange))
        // y축 값 점점 줄이기
        ..translate(0.0, lerpDouble(translateY, endTranslateY, factorChange)!, 0.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: heightItem,
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
