import 'package:responsive_framework/responsive_framework.dart';

enum BreakpointEnum {
  mobile(0, 450), // Slightly wider mobile range
  tablet(451, 850), // Adjusted for modern tablets
  desktop(851, double.infinity);

  const BreakpointEnum(this.start, this.end);

  final double start;
  final double end;

  Breakpoint get point => Breakpoint(start: start, end: end, name: name);

  static BreakpointEnum fromWidth(double width) {
    for (var bp in BreakpointEnum.values) {
      if (width >= bp.start && width <= bp.end) return bp;
    }
    return BreakpointEnum.mobile; // Fallback
  }
}