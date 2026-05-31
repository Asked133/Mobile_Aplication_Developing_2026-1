import 'package:flutter/material.dart';
import 'package:parcial1/data/mock_data.dart';

class NuevaVentaPage extends StatefulWidget {
  const NuevaVentaPage({super.key});
  @override
  State<NuevaVentaPage> createState() => _NuevaVentaPageState();
}

class _NuevaVentaPageState extends State<NuevaVentaPage> {
  final _formKey = GlobalKey<FormState>();
  String? _productoSeleccionado;
  final _cantidadController = TextEditingController();
  String _metodoPago = 'Efectivo';

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva Venta')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Registrar Venta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Completa los campos del ticket', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 24),

              //selector de producto
              Text('Producto', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _productoSeleccionado,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.shopping_bag),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                items: MockData.productos.map((p) {
                  return DropdownMenuItem(value: p.nombre, child: Text(p.nombre));
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    _productoSeleccionado = valor;
                  });
                },
                validator: (valor) => valor == null ? 'Selecciona un producto' : null,
              ),
              SizedBox(height: 16),

              Text('Cantidad', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.numbers),
                  hintText: 'Ej: 3',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) return 'Ingresa la cantidad';
                  if (int.tryParse(valor) == null || int.parse(valor) <= 0) return 'Debe ser un número positivo';
                  return null;
                },
              ),
              SizedBox(height: 16),

              Text('Método de Pago', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                children: [
                  //boton de efectivo
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _metodoPago = 'Efectivo'),
                      child: Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _metodoPago == 'Efectivo' ? Color(0xFFE87722) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.payments, color: Colors.white),
                            SizedBox(height: 4),
                            Text('Efectivo', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  //boton de tarjeta
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _metodoPago = 'Tarjeta'),
                      child: Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _metodoPago == 'Tarjeta' ? Color(0xFFE87722) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.credit_card, color: Colors.white),
                            SizedBox(height: 4),
                            Text('Tarjeta', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Venta registrada correctamente'), backgroundColor: Colors.green),
                      );
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.check, color: Colors.white),
                  label: Text('Registrar Venta', style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE87722),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
