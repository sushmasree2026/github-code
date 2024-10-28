import 'dart:convert';
import 'consts.dart';
import 'package:http/http.dart' as http;
class UserApiController{
  Future<Map<String,dynamic>> getUserByPage(int page)async{
    try{
      String url = apiUrls.reqresBaseUrl + "users?page=1";
      final res = await http.get(Uri.parse(url));
      if(res.statusCode == 200){
        return jsonDecode(res.body);
      }
      return {};
    }
    catch(err){
      return {};
    }
  }
}