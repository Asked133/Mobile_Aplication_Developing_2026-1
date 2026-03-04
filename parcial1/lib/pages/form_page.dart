import 'package:flutter/material.dart';
import 'package:parcial1/widgets/background_widget.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

final TextEditingController fechaController = TextEditingController();

class _FormPageState extends State<FormPage> {
  final List<String> categorias = [
    "Alimentos",
    "Hogar",
    "Ropa",
    "Electronicos",
    "Deportes",
    "Juguetes",
    "Salud",
    "Otros",
  ];
  DateTime fechaSeleccionada = DateTime.now();

  String categoria = '';

  final formKey = GlobalKey<FormState>();

  seleccionarFecha(context) async {
    final DateTime? seleccionada = await showDatePicker(
      locale: Locale('es'),
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: ColorScheme.light(primary: Colors.indigo)),
        child: child!,
      ),
    );
    if (seleccionada != null) {
      setState(() {
        fechaSeleccionada = seleccionada;
        fechaController.text =
            "${seleccionada.day}/${seleccionada.month}/${seleccionada.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nuevo Producto",
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Nombre del Producto",
                    hintText: "Ejemplo: Oreo",
                    border: OutlineInputBorder(),
                    fillColor: Colors.indigo.shade100,
                    filled: true,
                    prefixIcon: Icon(Icons.abc),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es obligatorio';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Cantidad",
                    hintText: "Ejemplo: 10",
                    prefixIcon: Icon(Icons.onetwothree),
                    border: OutlineInputBorder(),
                    fillColor: Colors.indigo.shade100,
                    filled: true,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La cantidad es obligatoria';
                    } else if (int.tryParse(value) == null ||
                        int.parse(value) <= 0) {
                      return 'La cantidad debe ser un número positivo';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: "Categoría",
                    
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Colors.indigo.shade100,
                    filled: true,
                  ),
                  initialValue: categorias[0],
                  items: categorias.map((String categoria) {
                    return DropdownMenuItem(
                      value: categoria,
                      child: Text(categoria),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      categoria = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: fechaController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "",
                    fillColor: Colors.indigo.shade100,
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_month),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      
                    ),
                  ),
                  onTap: () => seleccionarFecha(context),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Formulario enviado correctamente",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Formulario no valido",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Guardar Producto",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
