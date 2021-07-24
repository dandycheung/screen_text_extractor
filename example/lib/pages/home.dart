import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:screen_text_extractor/screen_text_extractor.dart';

class _ListItem extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ListItem({
    Key? key,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: BoxConstraints(minHeight: 48),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: 8,
        ),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Row(
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  child: title!,
                ),
                Expanded(child: Container()),
                if (trailing != null) SizedBox(height: 34, child: trailing),
              ],
            ),
            if (subtitle != null) Container(child: subtitle),
          ],
        ),
      ),
      onTap: this.onTap,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    // ⌥ + w
    HotKey _hotKey = HotKey(
      KeyCode.keyW,
      modifiers: [KeyModifier.alt],
    );

    await HotKeyManager.instance.register(
      _hotKey,
      keyDownHandler: () async {
        ExtractedResult result = await ScreenTextExtractor.instance.extract();
        BotToast.showText(text: 'result: ${result.toJson()}');
      },
      keyUpHandler: () async {
        // ExtractedResult result = await ScreenTextExtractor.instance.extract();
        // BotToast.showText(text: 'result: ${result.toJson()}');
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        _ListItem(
          title: Text('requestEnable'),
          onTap: () async {
            await ScreenTextExtractor.instance.requestEnable();
          },
        ),
        _ListItem(
          title: Text('isEnabled'),
          onTap: () async {
            bool _isEnabled = await ScreenTextExtractor.instance.isEnabled();
            BotToast.showText(text: '_isEnabled: $_isEnabled');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: _buildBody(context),
    );
  }
}
