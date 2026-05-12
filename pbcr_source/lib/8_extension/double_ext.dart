extension DoubleExt on double {
  double roundUp([int? fractionDigits]) => double.parse(toStringAsFixed(1));
}
