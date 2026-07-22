class MascotAvatar {
  final String name;
  final String displayName;
  final String desc;
  final String path;

  const MascotAvatar({
    required this.name,
    required this.displayName,
    required this.desc,
    required this.path,
  });
}

class AvatarConstants {
  static const List<MascotAvatar> allAvatars = [
    MascotAvatar(
      name: "panda.svg",
      displayName: "Zen Panda",
      desc: "Peaceful strategist designing habits in absolute calm.",
      path: "assets/profile svg icons/panda.svg",
    ),
    MascotAvatar(
      name: "fox.svg",
      displayName: "Clever Fox",
      desc: "Agile speedster navigating challenges with sharp wit.",
      path: "assets/profile svg icons/fox.svg",
    ),
    MascotAvatar(
      name: "bear.svg",
      displayName: "Cyber Bear",
      desc: "Reinforced guardian built for brute physical & mental discipline.",
      path: "assets/profile svg icons/bear.svg",
    ),
    MascotAvatar(
      name: "bear br.svg",
      displayName: "Brown Bear",
      desc: "Stout warrior tracking progress across rugged terrain.",
      path: "assets/profile svg icons/bear br.svg",
    ),
    MascotAvatar(
      name: "cat.svg",
      displayName: "Discipline Cat",
      desc: "Nimble and focus-driven mind, locking in on target habits.",
      path: "assets/profile svg icons/cat.svg",
    ),
    MascotAvatar(
      name: "dog.svg",
      displayName: "Loyal Canine",
      desc: "Reliable partner executing daily routines with steady devotion.",
      path: "assets/profile svg icons/dog.svg",
    ),
    MascotAvatar(
      name: "elephant.svg",
      displayName: "Memory Elephant",
      desc: "Unwavering memory bank tracking vast historic streaks.",
      path: "assets/profile svg icons/elephant.svg",
    ),
    MascotAvatar(
      name: "kangaroo.svg",
      displayName: "Tempo Kangaroo",
      desc: "Springing forward with energetic bounds of high momentum.",
      path: "assets/profile svg icons/kangaroo.svg",
    ),
    MascotAvatar(
      name: "lion.svg",
      displayName: "Pride Leader",
      desc: "Vanguard charting daily triumphs on majestic stellar paths.",
      path: "assets/profile svg icons/lion.svg",
    ),
    MascotAvatar(
      name: "penguin.svg",
      displayName: "Chilled Penguin",
      desc: "Analytical documenter maintaining cool composure under pressure.",
      path: "assets/profile svg icons/penguin.svg",
    ),
    MascotAvatar(
      name: "rabit.svg",
      displayName: "Agile Rabbit",
      desc: "Swift and dynamic action taker jumping over obstacles.",
      path: "assets/profile svg icons/rabit.svg",
    ),
  ];

  static String getDisplayName(String avatarName) {
    if (!avatarName.endsWith('.svg')) return avatarName;
    for (final avatar in allAvatars) {
      if (avatar.name == avatarName) {
        return avatar.displayName;
      }
    }
    return avatarName.replaceAll('.svg', '');
  }
}
