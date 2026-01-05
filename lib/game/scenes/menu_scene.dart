import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// The main menu scene for the platformer game.
class MenuScene extends Component {
  final GameRef gameRef;
  final TextComponent _titleText;
  final ButtonComponent _playButton;
  final ButtonComponent _levelSelectButton;
  final ButtonComponent _settingsButton;
  final ParallaxComponent _backgroundAnimation;

  MenuScene(this.gameRef)
      : _titleText = TextComponent(
          text: 'test6-platformer-06',
          position: Vector2(gameRef.size.x / 2, gameRef.size.y * 0.2),
          anchor: Anchor.topCenter,
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _playButton = ButtonComponent(
          position: Vector2(gameRef.size.x / 2, gameRef.size.y * 0.5),
          size: Vector2(200, 60),
          anchor: Anchor.topCenter,
          button: RectangleComponent(
            paint: Paint()..color = Colors.green,
          ),
          text: TextComponent(
            text: 'Play',
            textRenderer: TextPaint(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            // Handle play button press
          },
        ),
        _levelSelectButton = ButtonComponent(
          position: Vector2(gameRef.size.x / 2, gameRef.size.y * 0.6),
          size: Vector2(200, 60),
          anchor: Anchor.topCenter,
          button: RectangleComponent(
            paint: Paint()..color = Colors.blue,
          ),
          text: TextComponent(
            text: 'Level Select',
            textRenderer: TextPaint(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            // Handle level select button press
          },
        ),
        _settingsButton = ButtonComponent(
          position: Vector2(gameRef.size.x / 2, gameRef.size.y * 0.7),
          size: Vector2(200, 60),
          anchor: Anchor.topCenter,
          button: RectangleComponent(
            paint: Paint()..color = Colors.grey,
          ),
          text: TextComponent(
            text: 'Settings',
            textRenderer: TextPaint(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            // Handle settings button press
          },
        ),
        _backgroundAnimation = ParallaxComponent(
          parallaxOptions: ParallaxOptions(
            baseVelocity: Vector2(20, 0),
            velocityMultiplierDelta: Vector2(1.2, 1.0),
          ),
          children: [
            SpriteComponent(
              sprite: Sprite('background_layer1.png'),
              size: gameRef.size,
            ),
            SpriteComponent(
              sprite: Sprite('background_layer2.png'),
              size: gameRef.size,
            ),
            SpriteComponent(
              sprite: Sprite('background_layer3.png'),
              size: gameRef.size,
            ),
          ],
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(_titleText);
    add(_playButton);
    add(_levelSelectButton);
    add(_settingsButton);
    add(_backgroundAnimation);
  }
}