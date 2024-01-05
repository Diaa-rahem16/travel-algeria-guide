class PlaceInfo {
  final String location;
  final String imageUrl;
  final String name;
  final String desc;

  PlaceInfo({
    required this.location,
    required this.imageUrl,
    required this.name,
    required this.desc,
  });
}

List<PlaceInfo> places = [
  PlaceInfo(
    location: "Constantine",
    imageUrl: "assets/constantine/ConstH3.jpg",
    name: "Emir Abdelkader Mosque",
    desc:
        "Immerse yourself in the serenity of the Emir Abdelkader Mosque, a masterpiece of Islamic art. Admire its intricate details and cultural significance.",
  ),

  PlaceInfo(
    location: "Constantine",
    imageUrl: "assets/constantine/ConO1.jpg",
    name: "Sidi Rached Bridge",
    desc:
        "Walk across the ancient Sidi Rached Bridge that spans the Rhumel River. Feel the history beneath your feet and enjoy panoramic river views.",
  ),
  PlaceInfo(
    location: "Constantine",
    imageUrl: "assets/constantine/ConM1.jpg",
    name: "Castle of Ahmed el Bey",
    desc:
        "Perched on a hill, the Castle of Ahmed el Bey offers breathtaking views of Constantine. Explore its historical significance and architectural charm.",
  ),
  PlaceInfo(
    location: "Constantine",
    imageUrl: "assets/constantine/ConR1.jpg",
    name: "Le Saint Regis",
    desc:
        "Le Saint Regis, nestled in Constantine, invites you to savor delectable French cuisine. The restaurant's ambiance complements its exquisite menu.",
  ),
  PlaceInfo(
    location: "Constantine",
    imageUrl: "assets/constantine/ConR2.jpg",
    name: "La Palmeraie",
    desc:
        "Experience the rich flavors of Algerian dishes at La Palmeraie. The restaurant's warm atmosphere and traditional cuisine make it a local favorite.",
  ),
  PlaceInfo(
    location: "Constantine",
    imageUrl: "assets/constantine/ConM2.jpg",
    name: "Cirta Museum",
    desc:
        "Step into the Cirta Museum to journey through Constantine's history. Discover artifacts, exhibitions, and the city's cultural heritage.",
  ),

  // Algiers
  PlaceInfo(
    location: "Algiers",
    imageUrl: "assets/algiers/AlgK1.jpg",
    name: "Kasbah of Algiers",
    desc:
        "Wander through the narrow streets of the Kasbah, a UNESCO World Heritage Site in Algiers. Explore its maze-like alleys and historical landmarks.",
  ),
  PlaceInfo(
    location: "Algiers",
    imageUrl: "assets/algiers/AlgM1.jpg",
    name: "Ketchaoua Mosque",
    desc:
        "Marvel at the grandeur of Ketchaoua Mosque, an iconic religious site overlooking Algiers. Admire its intricate architecture and spiritual aura.",
  ),
];
