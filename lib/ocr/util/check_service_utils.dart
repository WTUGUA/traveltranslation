import 'package:traveltranslation/ocr/entity/analysis_entity.dart';
import 'package:traveltranslation/ocr/entity/tryfree_entity.dart';
import 'package:traveltranslation/ocr/helpers/service_helpers.dart';
import 'package:traveltranslation/ocr/util/free_try_utils.dart';
import 'package:traveltranslation/ocr/util/navo_kv_utils.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';
import 'package:traveltranslation/ocr/util/user_utils.dart';

class CheckServiceDelegate {
  ///后台kv和判断取一样的字符串，避免混淆
  //图像识别
  static final String ocrNum = "ocr_num";

  //批量图像识别
  static final String batchNum = "batch_num";

  //翻译
  static final String translateNum = "translate_num";

  //检查service是否可用
  static Future<bool> checkService(String type) async {
//    return Future.value(true);
    //如果是非登录用户.则校验缓存记录文件
    if (UserDelegate.getUserState() == UserStatus.GUEST) {
      TryFreeEntity tryFreeEntity = TryUtils.tryFreeEntity;

      if (tryFreeEntity == null) {
        return Future.value(false);
      }

      if (type == ocrNum) {
        var fileNum =
            await OnlineConfigUtils.getInstance().getConfigParams(ocrNum);
        print("ocrNum=$fileNum");
        if(fileNum.isNotEmpty){
          if (tryFreeEntity.ocrNum < int.parse(fileNum)) {
            tryFreeEntity.ocrNum = tryFreeEntity.ocrNum + 1;
            //更新次数
            await TryUtils.writTryFileContent(tryFreeEntity);
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        }else{
          return Future.value(false);
        }

      }
      if (type == batchNum) {
        var fileNum =
            await OnlineConfigUtils.getInstance().getConfigParams(batchNum);
        if (tryFreeEntity.batchNum < int.parse(fileNum)) {
          tryFreeEntity.batchNum = tryFreeEntity.batchNum + 1;
          //更新次数
          await TryUtils.writTryFileContent(tryFreeEntity);
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      }

      if (type == translateNum) {
        var fileOcrNum =
            await OnlineConfigUtils.getInstance().getConfigParams(translateNum);
        if (tryFreeEntity.translateNum < int.parse(fileOcrNum)) {
          tryFreeEntity.translateNum = tryFreeEntity.translateNum + 1;
          //更新次数
          await TryUtils.writTryFileContent(tryFreeEntity);
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      }
    } else {
      String token = await SpUtils.getUserToken();
      if (token == null || token.isEmpty) {
        return Future.value(false);
      }
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

      if (type == batchNum) {
        if (result.res.analysis.batch) {
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      }

      if (type == translateNum) {
        if (result.res.analysis.translate) {
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      }
    }
    return Future.value(false);
  }
}
