import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

Finder field(String label) {
  return find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.labelText == label,
  );
}

Future<void> enterField(WidgetTester tester, String label, String value) async {
  final input = field(label);
  await tester.ensureVisible(input);
  await tester.pumpAndSettle();
  await tester.enterText(input, value);
  await tester.pump();
}

Future<void> save(WidgetTester tester) async {
  final button = find.widgetWithText(ElevatedButton, 'Save');
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

Future<void> openDrawer(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Tambah Proyek pushes the form and system Back restores Home', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(
      find.text('Kamu telah menekan tombol Tambah Proyek!'),
      findsOneWidget,
    );
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    expect(navigator.canPop(), isTrue);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(ProjectFormPage), findsNothing);
    expect(find.text('Muhammad Akbar Rinaldy'), findsOneWidget);
    expect(navigator.canPop(), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Drawer replaces routes and closes on both destinations', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await openDrawer(tester);

    expect(find.text('My Portfolio'), findsOneWidget);
    expect(
      find.text('Explore personal projects and experiences!'),
      findsOneWidget,
    );
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(find.byType(MyHomePage), findsNothing);
    expect(navigator.canPop(), isFalse);
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );

    await openDrawer(tester);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(ProjectFormPage), findsNothing);
    expect(navigator.canPop(), isFalse);
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  for (final input in ['', '   ']) {
    testWidgets(
      'Save rejects empty or whitespace-only required fields: "$input"',
      (tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
        await enterField(tester, 'Nama Proyek', input);
        await enterField(tester, 'Deskripsi Proyek', input);
        await save(tester);

        expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
        expect(
          find.text('Deskripsi proyek tidak boleh kosong!'),
          findsOneWidget,
        );
        expect(find.byType(AlertDialog), findsNothing);

        await enterField(tester, 'Nama Proyek', 'Portfolio');
        await save(tester);

        expect(find.text('Nama proyek tidak boleh kosong!'), findsNothing);
        expect(
          find.text('Deskripsi proyek tidak boleh kosong!'),
          findsOneWidget,
        );
        expect(find.byType(AlertDialog), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('Save shows every value and OK resets fields and stored values', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await enterField(tester, 'Nama Proyek', 'MyPortfolio Mobile');
    await enterField(tester, 'Deskripsi Proyek', 'Portofolio pribadi saya.');
    await enterField(tester, 'Teknologi yang Digunakan', 'Flutter, Dart');
    await enterField(tester, 'Tautan Proyek', 'https://example.com/portfolio');

    final category = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(category);
    await tester.pumpAndSettle();
    await tester.tap(category);
    await tester.pumpAndSettle();

    for (final label in [
      'Web Development',
      'Mobile Development',
      'Machine Learning',
      'Data Science',
      'Other',
    ]) {
      expect(find.text(label).hitTestable(), findsOneWidget);
    }

    await tester.tap(find.text('Mobile Development').last);
    await tester.pumpAndSettle();
    await save(tester);

    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Nama Proyek: MyPortfolio Mobile'), findsOneWidget);
    expect(find.text('Deskripsi: Portofolio pribadi saya.'), findsOneWidget);
    expect(find.text('Kategori: Mobile Development'), findsOneWidget);
    expect(find.text('Teknologi: Flutter, Dart'), findsOneWidget);
    expect(find.text('Tautan: https://example.com/portfolio'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    for (final input in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(input.controller.text, isEmpty);
    }
    await tester.ensureVisible(category);
    await tester.pumpAndSettle();
    expect(find.text('Web Development').hitTestable(), findsOneWidget);

    await enterField(tester, 'Nama Proyek', 'Proyek kedua');
    await enterField(tester, 'Deskripsi Proyek', 'Tanpa isian opsional.');
    await save(tester);

    expect(find.text('Nama Proyek: Proyek kedua'), findsOneWidget);
    expect(find.text('Deskripsi: Tanpa isian opsional.'), findsOneWidget);
    expect(find.text('Kategori: Web Development'), findsOneWidget);
    expect(find.text('Teknologi: '), findsOneWidget);
    expect(find.text('Tautan: '), findsOneWidget);
    expect(find.text('Teknologi: Flutter, Dart'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final viewport in const [Size(360, 640), Size(754, 480)]) {
    testWidgets('Form and long confirmation stay usable at $viewport', (
      tester,
    ) async {
      tester.view.physicalSize = viewport;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
      await enterField(tester, 'Nama Proyek', 'Portfolio');
      await enterField(
        tester,
        'Deskripsi Proyek',
        List.filled(20, 'Deskripsi proyek yang panjang.').join('\n'),
      );
      await save(tester);

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
