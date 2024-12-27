class Host {
  int id;
  String hostname;
  String ip;
  bool status;
  DateTime lastOnline;
  DateTime lastOffline;

  Host({
    required this.id,
    required this.hostname,
    required this.ip,
    required this.lastOnline,
    required this.lastOffline,
    required this.status,
  });
}
