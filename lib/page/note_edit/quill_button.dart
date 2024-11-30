import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuillToggleStyleButton extends StatefulWidget {
  const QuillToggleStyleButton({
    required this.attribute,
    required this.controller,
    this.skipRequestKeyboard,
    this.child,
    this.childBuild,
    this.width,
    this.height,
    this.borderRadius,
    this.selectedBorder,
    this.unselectedBorder,
    // this.icon,
    // this.iconSize = kDefaultIconSize,
    // this.iconSelectedColor = Colors.white70,
    // this.iconUnselectedColor = Colors.black87,
    // this.text,
    // this.textSelectedColor = Colors.white70,
    // this.textUnselectedColor = Colors.black87,
    // this.textSize = 13,
    // this.textWeight = FontWeight.normal,
    this.fillSelectedColor = const Color.fromARGB(255, 154, 203, 133),
    this.fillUnselectedColor = Colors.transparent,
    this.afterButtonPressed,
    this.tooltip,
    Key? key,
  }) : super(key: key);

  final Attribute attribute;

  final bool? skipRequestKeyboard;

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxBorder? selectedBorder;
  final BoxBorder? unselectedBorder;
  final Widget? child;
  final Widget Function(bool? isToggled)? childBuild;

  // final IconData? icon;
  // final Color iconSelectedColor;
  // final Color iconUnselectedColor;
  // final double iconSize;

  // final String? text;
  // final Color textSelectedColor;
  // final Color textUnselectedColor;
  // final FontWeight textWeight;
  // final double textSize;

  final Color fillSelectedColor;
  final Color fillUnselectedColor;

  final QuillController controller;

  final VoidCallback? afterButtonPressed;
  final String? tooltip;

  @override
  State<QuillToggleStyleButton> createState() => _QuillToggleStyleButtonState();
}

class _QuillToggleStyleButtonState extends State<QuillToggleStyleButton> {

  bool? _isToggled;

  Style get _selectionStyle => widget.controller.getSelectionStyle();

  @override
  void initState() {
    super.initState();
    _isToggled = _getIsToggled(_selectionStyle.attributes);
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  Widget build(BuildContext context) {
    Color fillColor = (_isToggled!=null && _isToggled==true) ? widget.fillSelectedColor : widget.fillUnselectedColor;
    // Color iconColor = (_isToggled!=null && _isToggled==true) ? widget.iconSelectedColor : widget.iconUnselectedColor;
    // Color textColor = (_isToggled!=null && _isToggled==true) ? widget.textSelectedColor : widget.textUnselectedColor;

    return UtilityWidgets.maybeTooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTap: () {
          _toggleAttribute();
          if (widget.afterButtonPressed!=null) {
            widget.afterButtonPressed!();
          }
        },
        child: ClipRRect(
          borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(0)),
          child: Container(
            alignment: Alignment.center,
            height: widget.height,
            width : widget.width,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(0)),
              border: (_isToggled!=null && _isToggled==true)?widget.selectedBorder:widget.unselectedBorder
            ),
            child: (widget.childBuild!=null)
              ? widget.childBuild!(_isToggled)
              : (widget.child ?? const SizedBox())
          )
        )
      )
    );
      // child: EasyButton.custom(
      //   height: widget.height,
      //   width : widget.width,
      //   fillColor: fillColor,
      //   textColor: textColor,
      //   iconColor: iconColor,
      //   icon: widget.icon,
      //   iconSize: widget.iconSize,
      //   text: widget.text,
      //   textSize: widget.textSize,
      //   borderRadius: widget.borderRadius,
      //   textStyle: TextStyle(fontSize: widget.textSize, fontWeight: widget.textWeight),
      //   onTap: () {
      //     _toggleAttribute();
      //     if (widget.afterButtonPressed!=null) {
      //       widget.afterButtonPressed!();
      //     }
      //   }
      // )
  }

  @override
  void didUpdateWidget(covariant QuillToggleStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _isToggled = _getIsToggled(_selectionStyle.attributes);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  void _didChangeEditingValue() {
    setState(() => _isToggled = _getIsToggled(_selectionStyle.attributes));
  }

  bool _getIsToggled(Map<String, Attribute> attrs) {
    if (widget.attribute.key == Attribute.list.key ||
        widget.attribute.key == Attribute.script.key ||
        widget.attribute.key == Attribute.header.key ||
        widget.attribute.key == Attribute.align.key ||
        widget.attribute.key == Attribute.color.key ||
        widget.attribute.key == Attribute.size.key ||
        widget.attribute.key == Attribute.background.key) {
      final attribute = attrs[widget.attribute.key];
      if (attribute == null) {
        return false;
      }
      // logger.t("widget.attribute.key ${widget.attribute.key}");
      if (widget.attribute==Attribute.unchecked) {
        return attribute==Attribute.unchecked || attribute==Attribute.checked;
      }

      // logger.t(attrs[widget.attribute.key]);
      return attribute.value == widget.attribute.value;
    }
    return attrs.containsKey(widget.attribute.key);
  }

  void _toggleAttribute() {
    widget.controller
      ..skipRequestKeyboard = widget.skipRequestKeyboard??true
      ..formatSelection(_isToggled!
        ? Attribute.clone(widget.attribute, null)
        : widget.attribute);
  }
}
