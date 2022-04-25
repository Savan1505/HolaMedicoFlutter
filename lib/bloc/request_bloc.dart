/* import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:odoo_api/odoo_api_connector.dart';
import 'package:pharmaaccess/models/request_model.dart';
import '../resources/repository.dart';
import '../resources/request_db_provider.dart';

class RequestBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<RequestModel>>>();
  final _itemsFetcher = PublishSubject<int>();
  String imagesPath;

  var client;
  List<RequestModel> requests = [];
  var requestCount = 0;
  // Getters to Streams
  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<RequestModel>>> get items => _itemsOutput.stream;

  RequestBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
    getApplicationDocumentsDirectory().then((dir) {
      imagesPath = join(dir.path, "images/");
      Directory(imagesPath).create();
    });
  }

  // Getters to Sinks
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  fetchIds() async {
    final ids = await _repository.fetchIds();
    _topIds.sink.add(ids);
  }

  Future<List<RequestModel>> fetchItems() async {
    AppSettingModel appSetting = await requestDbProvider.getAppSettingBy();
    if (appSetting != null) {
      if (appSetting.type == 1) {
        //Use Registered fetch logic
        OdooResponse result =
            await client.searchRead('maintenance.request', [], [
          "id",
          "name",
          "description",
          'service_location',
          "partner_id",
          "technician_user_id",
          'request_date',
          'close_date',
          'schedule_date',
          'priority',
          'maintenance_type',
          'makani_id'
        ]);
        //print(result);
        if (!result.hasError()) {
          Map<String, dynamic> records = result.getResult();
          requests = records['records'].map<RequestModel>((json) {
            return RequestModel.fromJson(json);
          }).toList();
          //print(requests);
          return requests;
          //return records['records'];
        } else {
          //print('error authenticating');
          //print(result.getError());
          return null;
        }
      } else {
        var requests = [];
        //Use Parner fetch logic
        //client.debugRPC(true);
        OdooResponse response = await client.callController(
            '/request/fetch_requests', {'token': appSetting.token});
        if (!response.hasError()) {
          var records = json.decode(response.getResult()["records"]);
          requests = records.map<RequestModel>((json) {
            return RequestModel.fromJson(json);
          }).toList();
          return requests;
        } else {
          //print(response.getError());
          return null;
        }
      }
    }
  }

  Future<int> saveImage(int requestId, File image) async {
    AppSettingModel appSetting = await requestDbProvider.getAppSettingBy();
    if (appSetting != null) {
      var _bytes = await image.readAsBytes();
      var _imageData = base64Encode(_bytes);
      final values = {
        "name": basename(image.path),
        "type": "binary",
        "mimetype": "image/jpeg",
        "res_id": requestId,
        "res_model": "maintenance.request",
        "res_name": image.path,
        "datas": _imageData,
      };

      if (appSetting.type == 1) {
        //Use Employee fetch logic

        var result = await client.create("ir.attachment", values);
        if (!result.hasError()) {
          return result.getResult();
        } else {
          //print(result.getError());
          return null;
        }
      } else {
        //Use Parner save logic
        values['token'] = appSetting.token;
        OdooResponse response =
            await client.callController('/request/save_image', values);
        if (!response.hasError()) {
          return response.getResult() as int;
        } else {
          //print(response.getError());
          return null;
        }
      }
    }
  }

  Future<int> saveItem(Map<String, Object> values) async {
    AppSettingModel appSetting = await requestDbProvider.getAppSettingBy();
    if (appSetting != null) {
      if (appSetting.type == 1) {
        //Use Employee fetch logic

        var result = await client.create("maintenance.request", values);
        if (!result.hasError()) {
          return result.getResult();
        } else {
          //print(result.getError());
          return null;
        }
      } else {
        //Use Parner save logic
        values['token'] = appSetting.token;
        OdooResponse response =
            await client.callController('/request/save_item', values);
        if (!response.hasError()) {
          return response.getResult() as int;
        } else {
          //print(response.getError());
          return null;
        }
      }
    }
  }

  Future<int> saveImagePath(int requestId, String imagePath) async {
    return await requestDbProvider.saveImagePath(requestId, imagePath);
  }

  Future<List<String>> getImagePath(int requestId) async {
    List<String> _images = await requestDbProvider.getImagePath(requestId);
    if (_images != null) {
      return _images;
    } else {
      //no images found fetch from server.
      Map<String, dynamic> values = {"request_id": requestId};
      AppSettingModel appSetting = await requestDbProvider.getAppSettingBy();
      if (appSetting != null) {
        //guest user
        if (appSetting.type != 1) {
          values['token'] = appSetting.token;
        }

        OdooResponse response = await client.callController('/request/get_attachments_name', values);
        if (!response.hasError()) {
          try {
            if (_images == null) {
              _images = [];
            }

            List paths = response.getResult();
            if (paths == null) {
              return _images;
            }
            for (int i = 0; i < paths.length; i++) {
              String filename = join(imagesPath, paths[i]['path']);
              _images.add(filename);
              File file = File(filename);
              if (!file.existsSync()) {
                //fetch file - save file - update local db
                values['image_name'] = paths[i]['path'];
                OdooResponse response = await client.callController(
                    '/request/get_attachments_data', values);
                file.writeAsBytesSync(
                    base64Decode(response.getResult()['data']));
                await saveImagePath(requestId, filename);
              }
            }
            return _images;
          } catch (e) {
            //print(e);
          }
        }
      }
    }
    return null;
  }

  clearCache() {
    return _repository.clearCache();
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<RequestModel>> cache, int id, index) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<RequestModel>>{},
    );
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
 */