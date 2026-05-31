// validadores reutilizables para formularios — se usan en login, registro, gastos, etc.

// valida formato de email
String? validarEmail(String? value) {
  if (value == null || value.isEmpty) return 'Ingresa tu email';
  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!regex.hasMatch(value.trim())) return 'Email no válido';
  return null;
}

// valida contraseña (mínimo 6 caracteres)
String? validarContrasena(String? value) {
  if (value == null || value.isEmpty) return 'Ingresa una contraseña';
  if (value.length < 6) return 'Mínimo 6 caracteres';
  return null;
}

// valida nombre (mínimo 2 caracteres)
String? validarNombre(String? value) {
  if (value == null || value.trim().isEmpty) return 'El nombre es requerido';
  if (value.trim().length < 2) return 'Mínimo 2 caracteres';
  return null;
}

// valida monto numérico mayor a 0
String? validarMonto(String? value) {
  if (value == null || value.isEmpty) return 'Ingresa el monto';
  final n = double.tryParse(value.replaceAll(',', '.'));
  if (n == null || n <= 0) return 'Debe ser un número mayor a 0';
  return null;
}
