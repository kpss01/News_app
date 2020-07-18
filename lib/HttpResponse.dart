
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class HttpResponse{


  static Future<String> postResponse({String service,Map body}){
    String url=""+service;
    print('Url==$url');
    return http.post(url,body: body).then((http.Response response){
      if(response.statusCode<200 || response.statusCode>400 || json==null){
        print('HttpResponse=='+response.body.toString());
        throw new Exception("Error while fetching============================");
      }
      return response.body.toString();
    });
  }

  static Future<String> getResponse({String service}) async{
    String url = "http://newsapi.org/v2/top-headlines?apiKey=1bb4f6d38d264d699cde0062a70e7c07&" + service;
    print('Url==$url');
    http.Response response= await http.get(url);
    if (response.statusCode < 200 || response.statusCode > 400 || json == null) {
      print("Error occur===============================");
      print('HttpResponse=='+response.body.toString());

      return throw new Exception("Error while fetching============================");
    }
    else
      return response.body.toString();
  }

}

