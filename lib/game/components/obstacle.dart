import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

/// Represents an obstacle in the platformer game.
class Obstacle extends PositionComponent with CollisionCallbacks {
  /// The speed at which the obstacle moves horizontally.
  final double _speed;

  /// The damage dealt to the player upon collision.
  final int _damage;

  /// The sprite or shape used to visually represent the obstacle.
  final SpriteComponent _sprite;

  /// Creates a new instance of the [Obstacle] class.
  ///
  /// [position]: The initial position of the obstacle.
  /// [size]: The size of the obstacle.
  /// [speed]: The speed at which the obstacle moves horizontally.
  /// [damage]: The damage dealt to the player upon collision.
  /// [sprite]: The sprite or shape used to visually represent the obstacle.
  Obstacle({
    required Vector2 position,
    required Vector2 size,
    required double speed,
    required int damage,
    required SpriteComponent sprite,
  })  : _speed = speed,
        _damage = damage,
        _sprite = sprite {
    this.position = position;
    this.size = size;
    addShape(HitboxShape.rectangle(size: size));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move the obstacle horizontally
    position.x -= _speed * dt;

    // Wrap around the screen if the obstacle goes off-screen
    if (position.x < -size.x) {
      position.x = parent!.size.x + size.x;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Deal damage to the player upon collision
    if (other is Player) {
      other.takeDamage(_damage);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Render the obstacle's sprite or shape
    _sprite.render(canvas);
  }
}