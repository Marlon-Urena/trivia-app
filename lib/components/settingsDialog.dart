import 'package:flutter/material.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog(
      {Key? key,
      required this.title,
      required this.value,
      required this.onChange,
      required this.optionsMapping})
      : super(key: key);

  final String title;
  final Object value;
  final Function onChange;
  final List<String> optionsMapping;

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  Object? _value;
  late Function _onChange;

  @override
  void initState() {
    super.initState();
    setState(() {
      _value = widget.value;
      _onChange = widget.onChange;
    });
  }

  void _handleChange(Object? value) {
    _onChange(value);
    setState(() {
      _value = value;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      children: <Widget>[
        ...widget.optionsMapping.map((option) => RadioListTile(
            title: Text(option),
            value: option,
            groupValue: _value,
            onChanged: _handleChange))
      ],
    );
  }
}
