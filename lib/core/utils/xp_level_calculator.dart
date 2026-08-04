class XpLevelCalculator {
  static double getLevelProgress(int xp) {
    return (xp % 100) / 100;
  }

  static int calculateNewLevel(int xp, int currentLevel) {
    int level = currentLevel;
    while (xp >= level * 100) {
      level++;
    }
    return level;
  }
}
