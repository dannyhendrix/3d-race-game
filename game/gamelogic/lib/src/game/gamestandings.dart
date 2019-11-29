part of game;

class GameStandings {
  void collect(Player player, List<Player> rankings) {
    var position = player.position;
    while (position > 0) {
      var next = rankings[position - 1];
      if (next.pathProgress.progress >= player.pathProgress.progress) {
        return;
      }
      //swap
      rankings[position] = next;
      next.position = position;
      position--;
      rankings[position] = player;
      player.position = position;
    }
  }
}
