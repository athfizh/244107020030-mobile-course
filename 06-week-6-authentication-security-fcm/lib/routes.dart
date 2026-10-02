class AppRoutes {
  static const login = '/login';
  static const home = '/';
  static const pengumuman = '/pengumuman/:id';
}

String routeFromMessage(Map<String, dynamic> data) {
  final route = data['route'] as String? ?? '/';
  return route.startsWith('/') ? route : '/$route';
}
