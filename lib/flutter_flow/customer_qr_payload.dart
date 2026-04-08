class CustomerQrPayload {
  const CustomerQrPayload({
    required this.raw,
    required this.customerUuid,
    this.fiscalRfc,
    this.vehicleUuid,
    this.fleetUuid,
  });

  final String raw;
  final String customerUuid;
  final String? fiscalRfc;
  final String? vehicleUuid;
  final String? fleetUuid;

  bool get isValid => customerUuid.isNotEmpty && customerUuid != '-1';

  String get customerValueForLoad => raw.isNotEmpty ? raw : customerUuid;

  static CustomerQrPayload parse(String? source) {
    final rawValue = (source ?? '').trim();
    final segments = rawValue.split('|');

    final customerUuid = _segment(segments, 0) ?? '';

    return CustomerQrPayload(
      raw: rawValue,
      customerUuid: customerUuid,
      fiscalRfc: _segment(segments, 1),
      vehicleUuid: _segment(segments, 2),
      fleetUuid: _segment(segments, 3),
    );
  }

  static String? _segment(List<String> segments, int index) {
    if (index >= segments.length) {
      return null;
    }

    final value = segments[index].trim();

    if (value.isEmpty || value.toLowerCase() == 'none') {
      return null;
    }

    return value;
  }
}
