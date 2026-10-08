import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const HamsterGachaApp());
}

class HamsterGachaApp extends StatelessWidget {
  const HamsterGachaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const HamsterGacha(),
    );
  }
}

class GachaImage {
  const GachaImage(this.fileName, {this.isMiss = false});

  final String fileName;
  final bool isMiss;

  String get assetPath => 'assets/images/$fileName';
}

class HamsterGacha extends StatefulWidget {
  const HamsterGacha({super.key});

  @override
  State<HamsterGacha> createState() => _HamsterGachaState();
}

class _HamsterGachaState extends State<HamsterGacha> {
  static const _images = [
    GachaImage('Ramen Jiro 001.jpg'),
    GachaImage('Ramen Jiro 01.jpg'),
    GachaImage('Ramen Jiro 02.jpg'),
    GachaImage('Jiro with quail eggs.jpg'),
    GachaImage('Fuchu.Ramen.Jiro.jpg'),
    GachaImage('Jiro-Ikebukuro.jpg'),
    GachaImage("Ramen jiro's small ramen.jpg"),
    GachaImage('Ramenjiro.jpg'),
    GachaImage('Ramenjiro 2009.jpg'),
    GachaImage('8mujlo.jpg'),
    GachaImage('202308041629 IMG 7667.jpg'),
    GachaImage('202308041631 IMG 7669.jpg'),
    GachaImage('202308041631 IMG 7670.jpg'),
    GachaImage('202308041632 IMG 7671.jpg'),
    GachaImage('202309251812 IMG 6295.jpg'),
    GachaImage('202405201743 IMG 7905.jpg'),
    GachaImage('202405201744 IMG 7907.jpg'),
    GachaImage('202408261710 IMG 2955.jpg'),
    GachaImage('202408261712 IMG 2957.jpg'),
    GachaImage('二郎三田本店.jpg'),
    GachaImage('自家製麺いづみ 味噌ラーメン.jpg', isMiss: true),
  ];

  static const _loadingEmojis = ['🍜', '🐾', '🐱', '✨'];
  final _random = Random();

  GachaImage? _selectedImage;
  int _emojiIndex = 0;
  int _resultKey = 0;
  bool _isLoading = false;

  Future<void> _drawGacha() async {
    setState(() {
      _isLoading = true;
      _selectedImage = null;
    });

    for (var i = 0; i < 12; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 65));
      if (!mounted) return;
      setState(() => _emojiIndex = (_emojiIndex + 1) % _loadingEmojis.length);
    }

    if (!mounted) return;
    setState(() {
      _selectedImage = _images[_random.nextInt(_images.length)];
      _resultKey++;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedImage = _selectedImage;

    return Scaffold(
      appBar: AppBar(title: const Text('🍜 二郎ガチャ'), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 320,
                  height: 320,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: _isLoading
                        ? Center(
                            key: const ValueKey('loading'),
                            child: Text(
                              _loadingEmojis[_emojiIndex],
                              style: const TextStyle(fontSize: 100),
                            ),
                          )
                        : selectedImage == null
                        ? const Center(
                            key: ValueKey('ready'),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🍜', style: TextStyle(fontSize: 100)),
                                SizedBox(height: 12),
                                Text('ボタンを押してガチャ！'),
                              ],
                            ),
                          )
                        : _ResultImage(
                            key: ValueKey(_resultKey),
                            image: selectedImage,
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: selectedImage == null || _isLoading
                      ? const SizedBox(height: 56, key: ValueKey('empty'))
                      : _ResultMessage(
                          key: ValueKey('message-$_resultKey'),
                          isMiss: selectedImage.isMiss,
                        ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _isLoading ? null : _drawGacha,
                  icon: const Text('🎰', style: TextStyle(fontSize: 28)),
                  label: Text(_isLoading ? '抽選中…' : 'ガチャを回す！'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '二郎系20枚 ＋ ハズレ1枚',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultImage extends StatelessWidget {
  const _ResultImage({super.key, required this.image});

  final GachaImage image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(image.assetPath, fit: BoxFit.cover),
        if (image.isMiss)
          Container(
            color: Colors.black45,
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: -0.12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  border: Border.all(color: Colors.white, width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'ハズレ！',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ResultMessage extends StatelessWidget {
  const _ResultMessage({super.key, required this.isMiss});

  final bool isMiss;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Column(
        children: [
          Text(
            isMiss ? 'ざんねん！味噌ラーメンでした…' : '大当たり！二郎系ラーメン！',
            style: TextStyle(
              color: isMiss ? Colors.red.shade700 : Colors.orange.shade900,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isMiss)
            const Text('もう一度チャレンジ！', style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
