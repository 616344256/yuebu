

#import <Foundation/Foundation.h>
#import "WXUtil.h"
#import "ApiXml.h"
/*
 // 签名实例
 // 更新时间：2015年3月3日
 // 负责人：李启波（marcyli）
 // 该Demo用于ios sdk 1.4
 
 //微信支付服务器签名支付请求请求类
 //============================================================================
 //api说明：
 //初始化商户参数，默认给一些参数赋值，如cmdno,date等。
 -(BOOL) init:(NSString *)app_id (NSString *)mch_id;
 
 //设置商户API密钥
 -(void) setKey:(NSString *)key;
 
 //生成签名
 -(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
 
 //获取XML格式的数据
 -(NSString *) genPackage:(NSMutableDictionary*)packageParams;
 
 //提交预支付交易，获取预支付交易会话标识
 -(NSString *) sendPrepay:(NSMutableDictionary *);
 
 //签名实例测试
 - ( NSMutableDictionary *)sendPay_demo;
 
 //获取debug信息日志
 -(NSString *) getDebugifo;
 
 //获取最后返回的错误代码
 -(long) getLasterrCode;
 //============================================================================
 */

//通知的名字及参数
#define WX_PAY_RESULT   @"weixin_pay_result_isSuccessed"
#define IS_SUCCESSED    @"wechat_pay_isSuccessed"
#define IS_FAILED       @"wechat_pay_isFailed"


#define APP_ID          @"wxa578caef273d2a00"               //微信APPID
#define APP_SECRET      @"d4866b72c4e0870a2644a84965a5ac8e" //微信appsecret
//商户号，填写商户对应参数（客户给）
#define MCH_ID          @"1482814232"
//商户API密钥，填写相应参数（客户给）
#define PARTNER_ID      @"2323aa8df2de6068638ea3cea7700d8c"


//#define APP_ID          @"wx6a5cf55dbfc8d0c8"               //微信APPID
//#define APP_SECRET      @"0f556419b95aa3b01e7ee85ce2f8dd0f" //微信appsecret
////商户号，填写商户对应参数（客户给）
//#define MCH_ID          @"1429472002"
////商户API密钥，填写相应参数（客户给）
//#define PARTNER_ID      @"zhankeweixinvideo2011qxdq0000000"


//支付结果回调页面（后台会给你）
#define NOTIFY_URL      @"http://yuebu.tcgqxx.com/api/hongbaozhifu/notify_url"

@interface payRequsestHandler : NSObject{
	//预支付网关url地址
    NSString *payUrl;

    //lash_errcode;
    long     last_errcode;
	//debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
}
//初始化函数
-(BOOL) init:(NSString *)app_id mch_id:(NSString *)mch_id;
-(NSString *) getDebugifo;
-(long) getLasterrCode;
//设置商户密钥
-(void) setKey:(NSString *)key;
//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
//获取package带参数的签名包
-(NSString *)genPackage:(NSMutableDictionary*)packageParams;
//提交预支付
-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams;
//签名实例测试
- ( NSMutableDictionary *)sendPay_demo;

@end
