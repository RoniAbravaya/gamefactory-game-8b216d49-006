import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';

class Player extends SpriteAnimationComponent with HasGameRef, Hitbox, Collidable {
  final double _speed = 200;
  bool _isJumping = false;
  final double _gravity = 500;
  double _yVelocity = 0;
  final double _jumpStrength = -300;
  int health = 3;
  bool _isInvulnerable = false;
  final double _invulnerabilityTime = 2;
  double _invulnerabilityTimer = 0;

  Player()
      : super(size: Vector2(50, 50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('player_spritesheet.png'),
      srcSize: Vector2(50.0, 50.0),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 4);
    addHitbox(HitboxRectangle());
  }

  @override
  void update(double dt) {
    super.update(dt);
    handleMovement(dt);
    handleGravity(dt);
    handleInvulnerability(dt);
  }

  void handleMovement(double dt) {
    if (_isJumping) {
      return;
    }
    position.add(Vector2(0, _yVelocity * dt));
  }

  void handleGravity(double dt) {
    if (!isOnGround()) {
      _yVelocity += _gravity * dt;
    } else {
      _yVelocity = 0;
      _isJumping = false;
    }
  }

  bool isOnGround() {
    // This method should be replaced with actual collision detection with the ground
    return position.y >= gameRef.size.y - size.y / 2;
  }

  void jump() {
    if (_isJumping) {
      return;
    }
    _yVelocity = _jumpStrength;
    _isJumping = true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (_isInvulnerable) {
      return;
    }
    if (other is Obstacle) {
      takeDamage();
    } else if (other is Collectible) {
      collectItem(other);
    }
  }

  void takeDamage() {
    health -= 1;
    _isInvulnerable = true;
    _invulnerabilityTimer = _invulnerabilityTime;
    if (health <= 0) {
      // Handle player death
    }
  }

  void handleInvulnerability(double dt) {
    if (_isInvulnerable) {
      _invulnerabilityTimer -= dt;
      if (_invulnerabilityTimer <= 0) {
        _isInvulnerable = false;
      }
    }
  }

  void collectItem(Collectible item) {
    // Handle item collection
  }
}

class Obstacle extends SpriteComponent with Hitbox, Collidable {
  Obstacle(): super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    addHitbox(HitboxRectangle());
  }
}

class Collectible extends SpriteComponent with Hitbox, Collidable {
  Collectible(): super(size: Vector2(20, 20));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    addHitbox(HitboxCircle());
  }
}