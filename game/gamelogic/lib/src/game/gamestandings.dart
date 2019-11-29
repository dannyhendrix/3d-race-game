part of game;

class GameStandings {
  void collect(Player player, List<Player> rankings) {
    if (player.position == 0) return;
    var position = player.position;
    while (position > 0) {
      var next = rankings[position - 1];
      if (next.pathProgress.progress >= player.pathProgress.progress) {
        return;
      }
      //swap
      rankings[position] = next;
      position--;
      rankings[position] = player;
    }
  }
}
