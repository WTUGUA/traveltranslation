import 'dart:io';

import 'package:umeng_plugin/umeng_plugin.dart';

class EventUtil {
  ///拍摄（首页）
  static final String photoTake = "photo_take";
  static final String batchButtonClick = "batch_button_click";
  static final String setButtonClick = "set_button_click";
  static final String recordButtonClick = "record_button_click";

  ///识别确认页面
  static final String aSureOcrClick = "asure_ocr_click";
  static final String aSureCutClick = "asure_cut_click";
  static final String aSurePopLoginPageView = "asure_pop_login_pageview";
  static final String aSurePopLoginClick = "asure_pop_login_click";
  static final String loginButtonClick = "login_button_click";

  ///识别结果页面
  static final String resultTransClick = "result_trans_click";
  static final String resultCopyClick = "result_copy_click";
  static final String resultCheckClick = "result_check_click";
  static final String resultShareClick = "result_share_click";

  ///翻译结果页面
  static final String transButtonClick = "trans_button_click";
  static final String transCopyOriClick = "trans_copy_ori_click";
  static final String transCopyClick = "trans_copy_click";
  static final String transShareClick = "trans_share_click";
  static final String transLanguageClick = "trans_language_click";

  ///会员页面
  static final String vipPopPageView = "vip_pop_pageview";
  static final String vipPopOkClick = "vip_pop_ok_click";
  static final String vipPayClick = "vip_pay_click";
  static final String oneMonthClick = "one_month_click";
  static final String threeMonthClick = "three_month_click";
  static final String lifetimeClick = "lifetime_click";

  static void onEvent(String eventId, {String label}) {
    print("onEvent$eventId");
    if (label == null) {
      UmengPlugin.event(eventId);
    } else {
      UmengPlugin.event(eventId, label: label);
    }
  }

  static void beginPageView(String viewTag) {
    UmengPlugin.beginLogPageView(viewTag);
  }

  static void endPageView(String viewTag) {
    UmengPlugin.endLogPageView(viewTag);
  }

  static void init() async{
    var channel;
    if(Platform.isAndroid){
       channel = await UmengPlugin.getChannel();
    }
    UmengPlugin.init(
      iOSAppKey: "5d84b18b4ca3576f48000bc8",
      androidAppKey: "5d5fbd46570df317b1000397",
      channel: channel
    );
  }
}
