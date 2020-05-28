

import 'package:afvprepostoapi/afvprepostoapi.dart';

class IndexController extends ResourceController{

  @Operation.get()
  Future<Response> getIndex() async{
    final index = await File('index.html').readAsString();
    return Response.ok(index)..contentType=ContentType.html;
  }
  
}