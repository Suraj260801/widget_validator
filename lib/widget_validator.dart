library;
import 'package:flutter/material.dart';

typedef InputBuilder<T> = Widget Function(
  T? value,
  void Function(T?) onChanged,
);

class WidgetValidator<T> extends FormField<T> {
  WidgetValidator({
    super.key,
    required InputBuilder<T> inputBuilder,
    super.validator,
    super.onSaved,
    super.initialValue,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.errorStyle,
    this.spacing = 8,
  }) : super(
          builder: (FormFieldState<T> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User-controlled input widget
                inputBuilder(
                  field.value,
                  field.didChange,
                ),

                // Plugin-controlled error UI
                if (field.hasError) SizedBox(height: spacing),

                if (field.hasError)
                  Text(
                    field.errorText!,
                    style: errorStyle ??
                        const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                  ),
              ],
            );
          },
        );

  final TextStyle? errorStyle;
  final double spacing;
}




class ChoiceChipGroup<T> extends StatefulWidget {
  final List<T> data;

  final void Function(T?) onSelected;

  final T? selected;

  final TextStyle? labelStyle;

  const ChoiceChipGroup({
    super.key,
    required this.data,
    required this.onSelected,
    this.selected,
    this.labelStyle,
  });

  @override
  State<ChoiceChipGroup> createState() => _ChoiceChipGroupState();
}

class _ChoiceChipGroupState extends State<ChoiceChipGroup> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 16,
      children: widget.data.map<Widget>((ele) {
        final bool isSelected = _selectedValue == ele;
        final Color labelColor = isSelected ? Colors.white : Colors.black;
        return ChoiceChip(
          label: Text(ele),
          selected: isSelected,
          padding: EdgeInsets.all(10),
          onSelected: (value) {
            setState(() {
              _selectedValue = ele;
              widget.onSelected(ele);
            });
          },
          labelStyle: widget.labelStyle?.copyWith(color: labelColor),
        );
      }).toList(),
    );
  }
}



class Dropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final void Function(T?) onChanged;
  final String Function(T) labelBuilder;
  final String hint;

  const Dropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.labelBuilder,
    this.hint = 'Select',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(hint),
      items: items
          .map(
            (e) => DropdownMenuItem<T>(value: e, child: Text(labelBuilder(e))),
          )
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}