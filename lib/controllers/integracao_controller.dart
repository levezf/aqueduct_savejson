import 'dart:convert';

import 'package:afvprepostoapi/afvprepostoapi.dart';
import 'package:afvprepostoapi/utils/path_utils.dart';

class IntegracaoController extends ResourceController {

  IntegracaoController(this.directoryType);
  final DirectoryType directoryType;

  @Operation.get('cnpj', 'representante')
  Future<Response> getAllByRep(@Bind.path('cnpj') String cnpj,
      @Bind.path('representante') String representante) async {
    try {
      final Directory dirParent =
          getDirectory(cnpj, representante, directoryType);

      final Map<String, List<dynamic>> results = {};

      if (dirParent.existsSync()) {
        List<FileSystemEntity> prepostos = dirParent.listSync();
        prepostos = prepostos.whereType<Directory>().toList();

        prepostos.forEach((preposto) {
          final String codigoPreposto = nameFile(preposto.path);

          final Directory dirPreposto =
              Directory('${dirParent.path}/$codigoPreposto');

          if (dirPreposto.existsSync()) {
            var files = dirPreposto.listSync();
            files = files.whereType<File>().toList();
            if (files != null && files.isNotEmpty) {
              results.putIfAbsent(
                  codigoPreposto,
                  () => (files as List<File>)
                      .map((file) {
                        final jsonFile = json.decode(file.readAsStringSync());
                        moveToBackup(file);
                        return jsonFile;
                      })
                      .toList());
            }
          }
        });
      }
      return Response.ok(results);
    } catch (e) {
      print(e);
      return Response.serverError();
    }
  }

  @Operation.post('cnpj', 'representante', 'preposto', 'codigo')
  Future<Response> adicionarNovoItem(
      @Bind.path('cnpj') String cnpj,
      @Bind.path('representante') String representante,
      @Bind.path('preposto') String preposto,
      @Bind.path('codigo') String codigo,
      @Bind.body() Map<String, dynamic> novo) async {
    final Directory dirParent =
        getDirectory(cnpj, representante, directoryType);

    final result = json.encode(novo);

    try {
      writeFile('${dirParent.path}/$preposto/','$codigo', result);
    } catch (e) {
      print(e);
      return Response.serverError();
    }
    return Response.ok(novo);
  }


}
