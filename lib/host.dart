class Host {
  String hostname;
  String ip;
  bool status;
  DateTime lastOnline;
  DateTime lastOffline;

  Host({
    required this.hostname,
    required this.ip,
    required this.lastOnline,
    required this.lastOffline,
    required this.status,
  });
}
