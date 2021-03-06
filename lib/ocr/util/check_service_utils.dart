import 'package:traveltranslation/ocr/entity/analysis_entity.dart';
import 'package:traveltranslation/ocr/entity/tryfree_entity.dart';
import 'package:traveltranslation/ocr/helpers/service_helpers.dart';
import 'package:traveltranslation/ocr/util/free_try_utils.dart';
import 'package:traveltranslation/ocr/util/navo_kv_utils.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';
import 'package:traveltranslation/utils/travelsp.dart';

class CheckServiceDelegate {
  ///后台kv和判断取一样的字符串，避免混淆
  //图像识别
  static final String ocrNum = "ocr_num";

  //检查service是否可用
  static Future<bool> checkService(String type) async {
//    return Future.value(true);
    //如果是非登录用户.则校验缓存记录文件
    if (UserDelegate.getUserState() == UserStatus.GUEST) {
      //手动编写
      var fileNum =
      await OnlineConfigUtils.getInstance().getConfigParams(ocrNum);
      int kvtime=int.parse(fileNum);
      print("KV后台值:$kvtime");
      int sptime=await TravelSP.getOcrTime();
      print("SP值:$sptime");
      if(sptime<=kvtime){
        sptime=sptime+1;
        TravelSP.saveOcrTime(sptime);
        return true;
      }else{
        return false;
      }
    }
    //登录状态
    else {
      String token = await SpUtils.getUserToken();
      if (token == null || token.isEmpty) {
        return Future.value(false);
      }
      //校验服务器状态
      AnalysisEntity result = await ServiceApi.analysis(token, type);
      //结果返回
      if (result.code != 0) {
        return Future.value(false);
      }
      //如果用户是vip                                                                                                                                                                       则返回true
      if (result.res.vip) {
        return Future.value(true);
      }
      if (type == ocrNum) {
        if (result.res.analysis.ocr) {
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      }
    }
    return Future.value(false);
  }
}
