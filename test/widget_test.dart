import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tp4_dap/main.dart';

void main() {
  testWidgets('Flujo de registro y navegacion al catalogo', (WidgetTester tester) async {
    // Renderizamos la app completa dentro del ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Debe iniciar en la pantalla de Login por la redireccion de GoRouter
    expect(find.text('GameVault'), findsWidgets);
    expect(find.text('Iniciar Sesion'), findsWidgets);
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email y Password

    // 2. Navegar a la pantalla de registro
    final registerLink = find.text('Registrate');
    expect(registerLink, findsOneWidget);
    await tester.tap(registerLink);
    await tester.pumpAndSettle();

    // 3. Verificar que estamos en la pantalla de Registro
    expect(find.text('Crear Cuenta'), findsOneWidget);
    expect(find.text('Unete a GameVault'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4)); // Nombre, Email, Pass, ConfirmPass

    // 4. Completar el formulario de registro
    await tester.enterText(find.widgetWithText(TextFormField, 'Nombre completo'), 'Gamer Pro');
    await tester.enterText(find.widgetWithText(TextFormField, 'Correo electronico'), 'gamer@test.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Contrasena'), 'password123');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirmar contrasena'), 'password123');
    await tester.pumpAndSettle();

    // 5. Enviar el registro
    final submitButton = find.widgetWithText(ElevatedButton, 'Registrarse');
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // 6. Debe iniciar sesion y redirigir automaticamente a GamesListScreen (Catalogo)
    expect(find.textContaining('Hola, Gamer Pro'), findsOneWidget);
    expect(find.text('Nuevo Juego'), findsOneWidget);
    expect(find.text('The Witcher 3: Wild Hunt'), findsOneWidget);
  });
}
