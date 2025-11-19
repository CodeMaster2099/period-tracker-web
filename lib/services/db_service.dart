// Conditional export: use sqflite implementation on mobile/desktop, and a
// localStorage-backed fallback on web to avoid sqflite runtime errors in web builds.
export 'db_service_io.dart' if (dart.library.html) 'db_service_web.dart';
