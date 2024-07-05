class AbstractService{
  final String apiRest = 'http://127.0.0.1:8000/';
  Map<String, String> headers = <String,String>{
    'Content-type':'application/json'
  };
}