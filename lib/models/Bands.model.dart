class Bands {
  int id;
  String name;
  int votes;

  Bands({this.name, this.id, this.votes});

  factory Bands.fromMap(Map<String, dynamic> json) =>
  Bands(
    name: json['name'],
    id: json['id'],
    votes: json['votes']
  );
}
