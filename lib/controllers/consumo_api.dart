import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class Tienda extends StatefulWidget {
  const Tienda({super.key});

  @override
  State<Tienda> createState() => _TiendaState();
}

class _TiendaState extends State<Tienda> {
  List<Map<dynamic, dynamic>> datos = [];

  @override
  void initState() {
    super.initState();
    consumirApi();
  }

  Future<void> consumirApi() async {
    //Se maneja la URL como un String
    String url = "https://fakestoreapi.com/products";

    //Se generar una instancia de objeto de clase HTTP para hacer la peticion a la API
    final client = HttpClient();

    try {
      //Se genera la
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = response.transform(utf8.decoder).join();

        List<Map<dynamic, dynamic>> data =
            List<Map<dynamic, dynamic>>.from(jsonDecode(responseBody as String))
                .toList();

        setState(() {
          datos = data;
        });
      } else {
        print("Ha ocurrido un error al consumir APi");
      }
    } catch (e) {
      print("Ha ocurrido un error $e");
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tienda en linea"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: datos.length,
            itemBuilder: (context, index) {
              final producto = datos[index];
              return (ListTile(
                title: Text(producto['title']),
              ));
            },
          ))
        ],
      ),
    );
  }
}
