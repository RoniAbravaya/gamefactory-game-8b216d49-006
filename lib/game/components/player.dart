import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

/// The player character in the platformer game.
class Player extends SpriteAnimationComponent
    with HasGameRef<PlatformerGame>, CollisionCallbacks {
  /// The player's current horizontal speed.
  double xSpeed = 200;

  /// The player's current vertical speed.
  double ySpeed = 0;

  /// The player's maximum jump height.
  double maxJumpHeight = 300;

  /// The player's current health.
  int health = 3;

  /// The player's current score.
  int score = 0;

  /// Initializes the player with the given position and size.
  Player({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the player's animation sprites
    animation = await gameRef.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.15,
        textureSize: Vector2.all(32),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the player's position based on their speed
    position.x += xSpeed * dt;
    position.y += ySpeed * dt;

    // Apply gravity
    ySpeed += 1000 * dt;

    // Clamp the player's position to the screen bounds
    position.clamp(
      Vector2.zero() + size / 2,
      gameRef.size - size / 2,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Handle collisions with obstacles
    if (other is Obstacle) {
      // Reduce the player's health
      health--;

      // If the player has no health left, they have lost the game
      if (health <= 0) {
        gameRef.gameOver();
      }
    }
  }

  /// Handles the player's jump input.
  void jump() {
    // Reset the player's vertical speed
    ySpeed = -maxJumpHeight;
  }

  /// Increases the player's score by the given amount.
  void addScore(int amount) {
    score += amount;
  }
}