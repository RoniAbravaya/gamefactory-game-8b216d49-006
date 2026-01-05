import 'package:flame/components.dart';
import 'package:flame/audio.dart';
import 'package:flutter/material.dart';

/// A collectible item that the player can pick up for points.
class Collectible extends SpriteComponent with CollisionCallbacks {
  final int scoreValue;
  final Audio _collectSound;

  /// Creates a new Collectible instance.
  ///
  /// [sprite] is the Sprite to be displayed for the collectible.
  /// [position] is the initial position of the collectible.
  /// [scoreValue] is the number of points the player receives for collecting this item.
  /// [collectSound] is the audio clip to be played when the collectible is collected.
  Collectible({
    required Sprite sprite,
    required Vector2 position,
    required this.scoreValue,
    required Audio collectSound,
  })  : _collectSound = collectSound,
        super(
          sprite: sprite,
          position: position,
          size: Vector2.all(32.0),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.center;
    addComponent(FloatingComponent(this));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      _collectSound.play();
      other.score += scoreValue;
      removeFromParent();
    }
  }
}

/// A component that makes the Collectible float up and down.
class FloatingComponent extends Component with HasGameRef {
  final Collectible _collectible;
  double _offset = 0.0;
  final double _amplitude = 2.0;
  final double _frequency = 2.0;

  FloatingComponent(this._collectible);

  @override
  void update(double dt) {
    super.update(dt);
    _offset += dt * _frequency;
    _collectible.position.y = _collectible.position.y + (_amplitude * sin(_offset));
  }
}