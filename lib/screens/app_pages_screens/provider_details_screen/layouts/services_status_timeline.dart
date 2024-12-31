import 'package:flutter/material.dart';

class ServicesStatusTimeline extends StatelessWidget {
  final List<Map<String, String>> statusTimeline;

  const ServicesStatusTimeline({super.key, required this.statusTimeline});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: statusTimeline.length,
      itemBuilder: (context, index) {
        final status = statusTimeline[index];
        return TimelineTile(
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: Colors.green,
            padding: EdgeInsets.all(6),
          ),
          beforeLineStyle: LineStyle(
            color: Colors.green,
            thickness: 2,
          ),
          afterLineStyle: LineStyle(
            color: Colors.green,
            thickness: 2,
          ),
          endChild: Container(
            constraints: BoxConstraints(
              minHeight: 80,
            ),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status['status']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  status['date']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TimelineTile extends StatelessWidget {
  final IndicatorStyle indicatorStyle;
  final LineStyle beforeLineStyle;
  final LineStyle afterLineStyle;
  final Widget endChild;

  const TimelineTile({
    required this.indicatorStyle,
    required this.beforeLineStyle,
    required this.afterLineStyle,
    required this.endChild,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: indicatorStyle.width,
              height: indicatorStyle.width,
              decoration: BoxDecoration(
                color: indicatorStyle.color,
                shape: BoxShape.circle,
              ),
              padding: indicatorStyle.padding,
            ),
            Container(
              width: beforeLineStyle.thickness,
              height: 50,
              color: beforeLineStyle.color,
            ),
            Container(
              width: afterLineStyle.thickness,
              height: 50,
              color: afterLineStyle.color,
            ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(child: endChild),
      ],
    );
  }
}

class IndicatorStyle {
  final double width;
  final Color color;
  final EdgeInsets padding;

  IndicatorStyle({
    required this.width,
    required this.color,
    required this.padding,
  });
}

class LineStyle {
  final Color color;
  final double thickness;

  LineStyle({
    required this.color,
    required this.thickness,
  });
}
