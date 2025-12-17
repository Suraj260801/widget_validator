import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_validator/widget_validator.dart';

main() {
  Widget wrapWithForm({required Widget child, GlobalKey<FormState>? formKey}) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: Column(
            children: [
              child,
              ElevatedButton(
                onPressed: () {
                  formKey?.currentState?.validate();
                  formKey?.currentState?.save();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('ChoiceChipGroup shows validation error when nothing selected', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      wrapWithForm(
        formKey: formKey,
        child: WidgetValidator<String>(
          validator: (v) => v == null ? 'Required' : null,
          inputBuilder: (value, onChanged) {
            return ChoiceChipGroup<String>(
              data: const ['A', 'B'],
              selected: value,
              onSelected: onChanged,
            );
          },
        ),
      ),
    );

    // Tap submit without selecting
    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets(
  'ChoiceChipGroup clears error after selection',
  (tester) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      wrapWithForm(
        formKey: formKey,
        child: WidgetValidator<String>(
          validator: (v) => v == null ? 'Required' : null,
          inputBuilder: (value, onChanged) {
            return ChoiceChipGroup<String>(
              data: const ['A', 'B'],
              selected: value,
              onSelected: onChanged,
            );
          },
        ),
      ),
    );

    // Trigger validation error
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);

    // Select a chip
    await tester.tap(find.text('A'));
    await tester.pump();

    // Error should disappear
    expect(find.text('Required'), findsNothing);
  },
);

testWidgets(
  'ChoiceChipGroup calls onSaved with selected value',
  (tester) async {
    final formKey = GlobalKey<FormState>();
    String? savedValue;

    await tester.pumpWidget(
      wrapWithForm(
        formKey: formKey,
        child: WidgetValidator<String>(
          validator: (v) => v == null ? 'Required' : null,
          onSaved: (v) => savedValue = v,
          inputBuilder: (value, onChanged) {
            return ChoiceChipGroup<String>(
              data: const ['A', 'B'],
              selected: value,
              onSelected: onChanged,
            );
          },
        ),
      ),
    );

    // Select chip
    await tester.tap(find.text('B'));
    await tester.pump();

    // Submit form
    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(savedValue, 'B');
  },
);

testWidgets(
  'Dropdown shows validation error when nothing selected',
  (tester) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      wrapWithForm(
        formKey: formKey,
        child: WidgetValidator<String>(
          validator: (v) => v == null ? 'Required' : null,
          inputBuilder: (value, onChanged) {
            return Dropdown<String>(
              items: const ['One', 'Two'],
              value: value,
              onChanged: onChanged,
              labelBuilder: (e) => e,
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(find.text('Required'), findsOneWidget);
  },
);
testWidgets(
  'Dropdown selects value and saves correctly',
  (tester) async {
    final formKey = GlobalKey<FormState>();
    String? savedValue;

    await tester.pumpWidget(
      wrapWithForm(
        formKey: formKey,
        child: WidgetValidator<String>(
          validator: (v) => v == null ? 'Required' : null,
          onSaved: (v) => savedValue = v,
          inputBuilder: (value, onChanged) {
            return Dropdown<String>(
              items: const ['One', 'Two'],
              value: value,
              onChanged: onChanged,
              labelBuilder: (e) => e,
            );
          },
        ),
      ),
    );

    // Open dropdown
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    // Select item
    await tester.tap(find.text('Two').last);
    await tester.pumpAndSettle();

    // Submit
    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(savedValue, 'Two');
    expect(find.text('Required'), findsNothing);
  },
);


}
