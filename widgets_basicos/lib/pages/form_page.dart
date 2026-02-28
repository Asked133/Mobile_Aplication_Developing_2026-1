import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}


class _FormPageState extends State<FormPage> {

  final formkey = GlobalKey<FormState>();
  String nombre = '';
  double telefono = 0;
  final List<String> departamentos = ['Recursos Humanos', 'Finanzas', 'Ventas', 'Marketing', 'IT'];
  String departamento = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Odio a los negros"),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formkey,
          child: ListView(
            children: [
              Text("Registra tus datos"),
              SizedBox(height: 20,),
              TextFormField(
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'El nombre es obligatorio';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Nombre completo",
                  hintText: "Ingresa tu nombre",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              SizedBox(height: 20,),
              TextFormField(
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'El número de teléfono es obligatorio';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Número de teléfono",
                  prefixText: '+52',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20,),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Departamento",
                  prefixIcon: Icon(Icons.apartment),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                initialValue: departamentos[0],
                items: departamentos.map((String dep){
                  return DropdownMenuItem(
                    value: dep,
                    child: Text(dep),
                  );
                }).toList(), 
                onChanged: (value){
                  setState(() {
                    departamento = value!;
                  });
                },
              ),
              SizedBox(height: 60,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent
                ),
                onPressed: (){
                  if(formkey.currentState!.validate()){
                    formkey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Formulario enviado correctamente"))
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Formulario no valido"), backgroundColor: Colors.redAccent,)
                    );
                  }
                },
                child: Text("Enviar Formulario", style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold
                ),)
                )
            ],
          )
        ),
      ),
    );
  }
}