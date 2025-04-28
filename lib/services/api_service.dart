import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:leadvala/config.dart';
import 'package:http/http.dart' as http;
import 'environment.dart';
import 'error/exceptions.dart';

class ApiServices {
  static var client = http.Client();
  final dio = Dio();
  static List<Map<String, String>> conversationHistory = [];
  Response<dynamic>? response;

  //to get full path with paramiters
  static Future<String> getFullUrl(String apiName, List params) async {
    String url0 = "";
    if (params.isNotEmpty) {
      url0 = "$apiName?";
      for (int i = 0; i < params.length; i++) {
        url0 = '$url0${params[i]["key"]}=${params[i]["value"]}';
        if (i + 1 != params.length) url0 = "$url0&";
      }
    } else {
      url0 = apiName;
    }

    String url = '$apiUrl$url0';

    return url;
  }

  Future<APIDataClass> dioException(e) async {
    APIDataClass apiData =
        APIDataClass(message: 'No data', isSuccess: false, data: '0');
    if (e is DioException) {
      if (e.type == DioExceptionType.badResponse) {
        final response = e.response;
        if (response!.statusCode == 403) {
          apiData.message = response.data.toString();
          apiData.isSuccess = false;
          apiData.data = response.statusCode;

          return apiData;
        } else {
          if (response.data != null) {
            apiData.message = response.data['message'];
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          } else {
            apiData.message = response.data.toString();
            apiData.isSuccess = false;
            apiData.data = 0;
            return apiData;
          }
        }
      } else {
        final response = e.response;
        if (response != null && response.data != null) {
          final Map responseData = json.decode(response.data as String) as Map;
          apiData.message = responseData['message'] as String;
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        } else {
          apiData.message = response!.statusCode.toString();
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      }
    } else {
      apiData.message = "";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    }
  }

  Future<APIDataClass> getApi(String apiName, dynamic params,
      {bool isToken = false,
      bool isData = false,
      bool isMessage = true}) async {
    APIDataClass apiData = APIDataClass(
      message: 'No data',
      isSuccess: false,
      data: '0',
    );

    print('📌 Step 1: Initializing API Call to: $apiName');

    // ✅ Step 2: Check Internet Connection
    bool isInternet = await isNetworkConnection();
    if (!isInternet) {
      print("🚨 No Internet Access");
      apiData.message = "No Internet Access";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    }
    try {
      //dio.options.headers["authtoken"] = authtoken;
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);
      log("token : $token");
      print('showing to the token ???///$token');
      Response? response;

      response = await dio.request(apiName,
          options: Options(
            method: 'GET',
          ));
      print('main get api1${response.statusCode}');
      print('main get api2$apiName');
      print('main get api3${response.data}');
      log("STATUSS : ${response.statusCode}");
      if (response.statusCode == 200) {
        //get response
        var responseData = response.data;
        print('response data all of this data $responseData');
        log("$apiName Response: $responseData");
        print('datttatatatt$isData');
        //set data to class
        if (isData) {
          log("dskyghvjryb");
          apiData.message = isMessage
              ? apiName.contains("highest-ratings")
                  ? ""
                  : responseData["message"] ?? ""
              : "";
          apiData.isSuccess = true;
          apiData.data = responseData;
          return apiData;
        } else {
          apiData.message = responseData["message"] ?? "";
          apiData.isSuccess = true;
          apiData.data = apiName.contains("self")
              ? responseData['user']
              : responseData["data"];
          return apiData;
        }
      } else {
        apiData.message = "No Internet Access";
        apiData.isSuccess = false;
        apiData.data = 0;
        return apiData;
      }
    } catch (e) {
      apiData = await dioException(e);
      log("DDDD :${apiData.message}");
      return apiData;
    }
  }

  Future<APIDataClass> postApi(String apiName, body,
      {isToken = false, isData = false}) async {
    print('post api data:: $body');
    //default data to class
    APIDataClass apiData = APIDataClass(
      message: 'No data',
      isSuccess: false,
      data: '0',
    );
    //Check For Internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      apiData.message = "No Internet Access";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    } else {
      print('check to the api url name $apiName');
      log("URL: $apiName");

      //dio.options.headers["authtoken"] = authtoken;
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);
      print('showing token $token');
      print('showing token ${headersToken(token)}');
      log("AUTH : $token");
      log("AUTH : ${headersToken(token)}");
      try {
        print('call trying');
        final response = await dio.post(
          apiName,
          data: body,
          options: Options(headers: isToken ? headersToken(token) : headers),
        );
        print('showing response:::$response');
        print('showing response:::${response.data}');
        print('showing body:::$body');
        var responseData = response.data;
        log("response : $response");
        if (response.statusCode == 200) {
          print('response data set to the acces token: $response');
          //get response

          if (apiName.contains("login") ||
              apiName.contains("register") ||
              apiName.contains("social/login") ||
              apiName.contains("social/verifyOtp")) {
            log("RESPONJSE : ${response.data}");
            await pref.setString(
                session.accessToken, responseData['access_token']);
            //set data to class
            apiData.message =
                apiName.contains("login") || apiName.contains("social/login")
                    ? "Login Successfully"
                    : "Register Successfully";
            apiData.isSuccess = true;
            apiData.data = "";
            return apiData;
          } else {
            if (isData) {
              apiData.message = responseData["message"] ?? "";
              apiData.isSuccess = true;
              apiData.data = responseData;
              return apiData;
            } else {
              apiData.message = responseData["message"] ?? "";
              apiData.isSuccess = true;
              apiData.data = responseData["data"];
              return apiData;
            }
          }
        } else {
          log("RESPONJSE 1: ${response.data}");
          apiData.message = responseData["message"];
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      } catch (e) {
        print('showing data$e');
        if (e is DioException) {
          if (e.type == DioExceptionType.badResponse) {
            final response = e.response;
            log("EEEEE : ${response!.data}");

            if (response.data != null) {
              apiData.message = response.data['message'];
              apiData.isSuccess = false;
              apiData.data = 0;
              return apiData;
            } else {
              apiData.message = response.data.toString();
              apiData.isSuccess = false;
              apiData.data = 0;
              return apiData;
            }
          } else {
            final response = e.response;
            if (response != null && response.data != null) {
              final Map responseData =
                  json.decode(response.data as String) as Map;
              apiData.message = responseData['message'] as String;
              apiData.isSuccess = false;
              apiData.data = 0;
              return apiData;
            } else {
              apiData.message = response!.statusCode.toString();
              apiData.isSuccess = false;
              apiData.data = 0;
              return apiData;
            }
          }
        } else {
          apiData.message = "";
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      }
    }
  }

  Future<APIDataClass> deleteApi(String apiName, body,
      {isToken = false}) async {
    //default data to class
    APIDataClass apiData = APIDataClass(
      message: 'No data',
      isSuccess: false,
      data: '0',
    );
    //Check For Internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      apiData.message = "No Internet Access";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    } else {
      log("URL: $apiName");

      //dio.options.headers["authtoken"] = authtoken;
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);
      log("AUTH : $token");
      log("AUTH : ${headersToken(token)}");
      try {
        final response = await dio.delete(
          apiName,
          data: body,
          options: Options(headers: isToken ? headersToken(token) : headers),
        );
        var responseData = response.data;
        log("response : $response");
        if (response.statusCode == 200) {
          //set data to class
          log("RESPONJSE :2 ${response.data}");
          apiData.message = responseData["message"] ?? "";
          apiData.isSuccess = true;
          apiData.data = responseData["data"];
          return apiData;
        } else {
          log("RESPONJSE 1: ${response.data}");
          apiData.message = responseData["message"];
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      } catch (e) {
        if (e is DioException) {
          if (e.type == DioExceptionType.badResponse) {
            final response = e.response;
            log("RESPONJSE 1: ${response!.data}");
            if (response.data != null) {
              apiData.message = response.data['message'];
              apiData.isSuccess = false;
              apiData.data = 0;
              return apiData;
            } else {
              apiData.message = response.data.toString();
              apiData.isSuccess = false;
              apiData.data = 0;
              return apiData;
            }
          } else {
            final response = e.response;
            if (response != null && response.data != null) {
              final Map responseData =
                  json.decode(response.data as String) as Map;
              apiData.message = responseData['message'] as String;
              apiData.isSuccess = false;
              apiData.data = 0;
              return apiData;
            } else {
              apiData.message = response!.statusCode.toString();
              apiData.isSuccess = false;
              apiData.data = 0;
              return apiData;
            }
          }
        } else {
          apiData.message = "";
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      }
    }
  }

  Future<APIDataClass> putApi(String apiName, body,
      {isToken = false, isData = false}) async {
    //default data to class
    APIDataClass apiData = APIDataClass(
      message: 'No data',
      isSuccess: false,
      data: '0',
    );
    //Check For Internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      apiData.message = "No Internet Access";
      apiData.isSuccess = false;
      apiData.data = 0;
      return apiData;
    } else {
      log("URL: $apiName");

      //dio.options.headers["authtoken"] = authtoken;
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);
      log("AUTH : $token");
      log("AUTH : ${headersToken(token)}");
      try {
        final response = await dio.put(
          apiName,
          data: jsonEncode(body),
          options: Options(headers: isToken ? headersToken(token) : headers),
        );
        var responseData = response.data;
        log("response : $response");
        if (response.statusCode == 200) {
          //get response

          if (isData) {
            log("RESPONJSE : ${response.data}");
            /*  await pref.setString(
                session.accessToken, responseData['access_token']);*/
            //set data to class
            apiData.message = "";
            apiData.isSuccess = true;
            apiData.data = responseData;
            return apiData;
          } else {
            //set data to class
            log("RESPONJSE :2 ${response.data}");
            apiData.message = responseData["message"] ?? "";
            apiData.isSuccess = true;
            apiData.data = responseData["data"];
            return apiData;
          }
        } else {
          log("RESPONJSE 1: ${response.data}");
          apiData.message = responseData["message"];
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      } catch (e) {
        if (e is DioException) {
          if (e.type == DioExceptionType.badResponse) {
            final response = e.response;
            if (response != null && response.data != null) {
              apiData.message = response.data['message'];
              apiData.isSuccess = false;
              apiData.data = 0;
              return apiData;
            } else {
              apiData.message = response!.data.toString();
              apiData.isSuccess = false;
              apiData.data = 0;
              return apiData;
            }
          } else {
            final response = e.response;
            if (response != null && response.data != null) {
              final Map responseData =
                  json.decode(response.data as String) as Map;
              apiData.message = responseData['message'] as String;
              apiData.isSuccess = false;
              apiData.data = 0;
              return apiData;
            } else {
              apiData.message = response!.statusCode.toString();
              apiData.isSuccess = false;
              apiData.data = 0;
              return apiData;
            }
          }
        } else {
          apiData.message = "";
          apiData.isSuccess = false;
          apiData.data = 0;
          return apiData;
        }
      }
    }
  }
}

Exception handleErrorResponse(http.Response response) {
  var data = jsonDecode(response.body);

  return RemoteException(
    statusCode: response.statusCode,
    message: data['message'] ?? response.statusCode == 422
        ? 'Validation failed'
        : 'Server exception',
  );
}



//  dad code 
//  try {
//       // ✅ Step 3: Retrieve Token if Required
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       String? token = pref.getString(session.accessToken) ?? "";

//       print("🔑 Access Token: $token");
//       print("🔑 Access Token: ${headersToken(token)}");

//       // ✅ Step 4: Define Headers **Before** Using Them
//       Map<String, String>? tokenHeaders = isToken ? headersToken(token) : null;
//       Map<String, String> headers =
//           tokenHeaders ?? {}; // ✅ Fix circular reference

//       print("📩 Headers: $headers");

//       // ✅ Step 5: Make API Request using Dio
//       // Response response = await dio.get(
//       //   apiName,
//       //   // queryParameters: params,
//       //   // options: Options(
//       //   //   headers: headers,
//       //   // ),
//       // );
//       var response = await dio.request(
//         apiName,
//         options: Options(
//           method: 'GET',
//         ),
//       );
//       print('////////>>>>${response.data}');
//       if (response.statusCode == 200) {
//         print("????????????${json.encode(response.data)}");
//       } else {
//         print(response.statusMessage);
//       }
//       print("✅ Response Received! Status Code: ${response.statusCode}");

//       // ✅ Step 6: Check Response Status
//       if (response.statusCode == 200) {
//         var responseData = response.data;
//         print("📝 Full Response Data: ${json.encode(responseData)}");

//         apiData.isSuccess = true;
//         apiData.data = apiName.contains("self")
//             ? responseData['user']
//             : responseData["data"];
//         apiData.message = responseData["message"] ?? "";
//       } else {
//         print("⚠️ API Error: ${response.statusMessage}");
//         apiData.message = "Server Error";
//         apiData.isSuccess = false;
//       }
//     } catch (e) {
//       print("❌ API Call Failed: $e");
//       apiData = await dioException(e);
//     }

//     return apiData;


 // Future<APIDataClass> getApi(String apiName, dynamic params,
  //     {isToken = false, isData = false, isMessage = true}) async {
  //   //default data to class
  //   APIDataClass apiData = APIDataClass(
  //     message: 'No data',
  //     isSuccess: false,
  //     data: '0',
  //   );
  //   print('api data value of show ${apiData}');
  //   //Check For Internet
  //   bool isInternet = await isNetworkConnection();
  //   if (!isInternet) {
  //     apiData.message = "No Internet Access";
  //     apiData.isSuccess = false;
  //     apiData.data = 0;
  //     return apiData;
  //   } else {
  //     log("URL: $apiName");
  //     print('check to url ${apiName}');
  //     try {
  //       //dio.options.headers["authtoken"] = authtoken;
  //       SharedPreferences pref = await SharedPreferences.getInstance();
  //       String? token = pref.getString(session.accessToken);
  //       log("token : $token");
  //       print('showing to the token ???///$token');
  //       Response? response;
  //       response = await dio.get(
  //         apiName,
  //         // data: params,
  //         // options: Options(headers: isToken ? headersToken(token) : headers),
  //       );
  //       print('response data showing this time${response.statusCode}');
  //       log("STATUSS : ${response.statusCode}");
  //       if (response.statusCode == 200) {
  //         //get response
  //         var responseData = response.data;
  //         print('response data all of this data ${responseData}');
  //         log("$apiName Response: $responseData");
  //         print('datttatatatt${isData}');
  //         //set data to class
  //         if (isData) {
  //           log("dskyghvjryb");
  //           apiData.message = isMessage
  //               ? apiName.contains("highest-ratings")
  //                   ? ""
  //                   : responseData["message"] ?? ""
  //               : "";
  //           apiData.isSuccess = true;
  //           apiData.data = responseData;
  //           return apiData;
  //         } else {
  //           apiData.message = responseData["message"] ?? "";
  //           apiData.isSuccess = true;
  //           apiData.data = apiName.contains("self")
  //               ? responseData['user']
  //               : responseData["data"];
  //           return apiData;
  //         }
  //       } else {
  //         apiData.message = "No Internet Access";
  //         apiData.isSuccess = false;
  //         apiData.data = 0;
  //         return apiData;
  //       }
  //     } catch (e) {
  //       // apiData = await dioException(e);
  //       // log("DDDD :${apiData.message}");
  //       return apiData;
  //     }
  //   }
  // }