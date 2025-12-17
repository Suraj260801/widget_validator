# widget_validator

`widget_validator` A flexible Flutter form validator that adds validation and error handling to any custom input widget.


## Features

 - Validation for any custom widget
 - Widget-agnostic design
 - Built-in error handling
 - Flutter-idiomatic API
 - Pluggable input widgets

## Getting started

To use this package, add widget_validator as a dependency in your pubspec.yaml file.

## Usage

Minimal example:

```dart
      WidgetValidator<String>(
                  validator: (v) =>
                      v == null || v.isEmpty ? 'This field is required' : null,
                  inputBuilder: (value, onChanged) {
                    return ChoiceChipGroup(
                      data: ['A', 'B', 'C', 'D'],
                      selected: value,
                      onSelected: onChanged,
                    );
                  },
                )
```

Custom settings:

```dart
       WidgetValidator<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: 'B',
                  errorStyle: TextStyle(),
                  spacing: 8,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'This field is required' : null,
                  onSaved: (value) => _selectedChipValue = value,
                  inputBuilder: (value, onChanged) {
                    return ChoiceChipGroup(
                      data: ['A', 'B', 'C', 'D'],
                      selected: value,
                      onSelected: onChanged,
                    );
                  },
                ),
```

A Complete Example:

```dart
   class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _selectedFieldValue;
  double? _selectedSliderValue;
  String? _selectedChipValue;
  String? _selectedRadioValue;
  String? _selectedDropDownValue;

  @override
  void initState() {
    super.initState();
    _selectedFieldValue = TextEditingController();
  }

  @override
  void dispose() {
    _selectedFieldValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Widget Validator')),
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(border: Border.all()),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: SizedBox(
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                TextFormField(
                  controller: _selectedFieldValue,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                  decoration: InputDecoration(
                    label: Text('Enter name'),
                    border: OutlineInputBorder(),
                  ),
                ),
                WidgetValidator<double>(
                  validator: (value) => value == null ? 'Required' : null,
                  onSaved: (value) => _selectedSliderValue = value,
                  inputBuilder: (value, onChanged) {
                    return Slider(
                      value: value ?? 0,
                      onChanged: onChanged,
                      min: 0,
                      max: 100,
                    );
                  },
                ),

                WidgetValidator<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: 'Friend',
                  errorStyle: TextStyle(),
                  spacing: 8,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'This field is required' : null,
                  onSaved: (value) => _selectedChipValue = value,
                  inputBuilder: (value, onChanged) {
                    return ChoiceChipGroup(
                      data: ['Father', 'Mother', 'Sibling', 'Friend'],
                      selected: value,
                      onSelected: onChanged,
                    );
                  },
                ),

                WidgetValidator<String>(
                  validator: (v) => v == null ? 'Please select one' : null,
                  onSaved: (value) => _selectedRadioValue = value,
                  inputBuilder: (value, onChanged) {
                    return Column(
                      children: ['A', 'B', 'C']
                          .map(
                            (e) => RadioListTile(
                              value: e,
                              groupValue: value,
                              onChanged: onChanged,
                              title: Text(e),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),

                WidgetValidator<String>(
                  validator: (v) => v == null ? 'Please select relation' : null,
                  onSaved: (value) => _selectedDropDownValue = value,
                  inputBuilder: (value, onChanged) {
                    return Dropdown<String>(
                      hint: 'Select relation',
                      items: const ['Father', 'Mother', 'Sibling', 'Friend'],
                      value: value,
                      onChanged: onChanged,
                      labelBuilder: (e) => e,
                    );
                  },
                ),

                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      log(_selectedFieldValue.text);
                      log(_selectedSliderValue.toString());
                      log(_selectedChipValue.toString());
                      log(_selectedRadioValue.toString());
                      log(_selectedDropDownValue.toString());
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```


