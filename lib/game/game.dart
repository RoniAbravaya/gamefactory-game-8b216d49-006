import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:test6_platformer_06/components/player.dart';
import 'package:test6_platformer_06/components/obstacle.dart';
import 'package:test6_platformer_06/components/collectible.dart';
import 'package:test6_platformer_06/services/analytics.dart';
import 'package:test6_platformer_06/services/ads.dart';
import 'package:test6_platformer_06/services/storage.dart';
import 'package:test6_platformer_06/ui/overlays.dart';

/// The main FlameGame class for the 'test6-platformer-06' game.
class Test6Platformer06Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState _gameState = GameState.playing;

  /// The player component.
  late Player _player;

  /// The list of obstacle components.
  final List<Obstacle> _obstacles = [];

  /// The list of collectible components.
  final List<Collectible> _collectibles = [];

  /// The current score.
  int _score = 0;

  /// The analytics service.
  final AnalyticsService _analyticsService = AnalyticsService();

  /// The ads service.
  final AdsService _adsService = AdsService();

  /// The storage service.
  final StorageService _storageService = StorageService();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the current level
    await _loadLevel();

    // Add the player, obstacles, and collectibles to the game
    add(_player);
    _obstacles.forEach(add);
    _collectibles.forEach(add);

    // Add the UI overlays
    await _addOverlays();
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    // Handle the tap input based on the current game state
    switch (_gameState) {
      case GameState.playing:
        _player.jump();
        break;
      case GameState.paused:
        // Resume the game
        _gameState = GameState.playing;
        break;
      case GameState.gameOver:
        // Restart the game
        _restartGame();
        break;
      case GameState.levelComplete:
        // Load the next level
        _loadNextLevel();
        break;
    }
  }

  /// Loads the current level.
  Future<void> _loadLevel() async {
    // Load the level data from storage or a level data file
    final levelData = await _storageService.loadLevelData();

    // Create the player, obstacles, and collectibles based on the level data
    _player = Player(levelData.playerStartPosition);
    _obstacles.addAll(levelData.obstacles.map((data) => Obstacle(data)));
    _collectibles.addAll(levelData.collectibles.map((data) => Collectible(data)));
  }

  /// Loads the next level.
  Future<void> _loadNextLevel() async {
    // Unload the current level
    _player.removeFromParent();
    _obstacles.forEach((obstacle) => obstacle.removeFromParent());
    _collectibles.forEach((collectible) => collectible.removeFromParent());

    // Load the next level
    await _loadLevel();

    // Add the player, obstacles, and collectibles to the game
    add(_player);
    _obstacles.forEach(add);
    _collectibles.forEach(add);

    // Update the game state
    _gameState = GameState.playing;
  }

  /// Restarts the game.
  void _restartGame() {
    // Unload the current level
    _player.removeFromParent();
    _obstacles.forEach((obstacle) => obstacle.removeFromParent());
    _collectibles.forEach((collectible) => collectible.removeFromParent());

    // Reset the score
    _score = 0;

    // Load the first level
    _loadLevel();

    // Add the player, obstacles, and collectibles to the game
    add(_player);
    _obstacles.forEach(add);
    _collectibles.forEach(add);

    // Update the game state
    _gameState = GameState.playing;
  }

  /// Adds the UI overlays to the game.
  Future<void> _addOverlays() async {
    // Add the pause, game over, and level complete overlays
    await overlays.add(PauseOverlay.id);
    await overlays.add(GameOverOverlay.id);
    await overlays.add(LevelCompleteOverlay.id);
  }

  /// Updates the game state and handles related logic.
  @override
  void update(double dt) {
    super.update(dt);

    // Update the game state based on the player's actions
    switch (_gameState) {
      case GameState.playing:
        // Check for collisions with obstacles and collectibles
        _handleCollisions();

        // Update the player and obstacle positions
        _player.update(dt);
        _obstacles.forEach((obstacle) => obstacle.update(dt));
        _collectibles.forEach((collectible) => collectible.update(dt));

        // Check if the level is complete
        if (_isLevelComplete()) {
          _gameState = GameState.levelComplete;
          _showLevelCompleteOverlay();
        }
        break;
      case GameState.paused:
        // Pause the game logic
        break;
      case GameState.gameOver:
        // Show the game over overlay
        _showGameOverOverlay();
        break;
      case GameState.levelComplete:
        // Show the level complete overlay
        break;
    }
  }

  /// Handles collisions between the player, obstacles, and collectibles.
  void _handleCollisions() {
    // Check for collisions with obstacles
    for (final obstacle in _obstacles) {
      if (_player.isColliding(obstacle)) {
        _gameState = GameState.gameOver;
        _showGameOverOverlay();
        return;
      }
    }

    // Check for collisions with collectibles
    for (final collectible in _collectibles) {
      if (_player.isColliding(collectible)) {
        _collectibles.remove(collectible);
        collectible.removeFromParent();
        _score += collectible.value;
        _analyticsService.logCollectibleCollected();
      }
    }
  }

  /// Checks if the current level is complete.
  bool _isLevelComplete() {
    // Check if the player has reached the end of the level
    return _player.position.x >= _obstacles.last.position.x;
  }

  /// Shows the game over overlay.
  void _showGameOverOverlay() {
    overlays.remove(PauseOverlay.id);
    overlays.add(GameOverOverlay.id);
    _analyticsService.logGameOver();
  }

  /// Shows the level complete overlay.
  void _showLevelCompleteOverlay() {
    overlays.remove(PauseOverlay.id);
    overlays.add(LevelCompleteOverlay.id);
    _analyticsService.logLevelComplete();
  }
}

/// The possible game states.
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}