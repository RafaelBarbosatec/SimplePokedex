class PokemonType {
  String image;
  String name;
  String color;

  PokemonType({this.image, this.name, this.color});

  PokemonType.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['color'] = this.color;
    return data;
  }
}
