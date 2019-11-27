#import "FlutterKbzPayPlugin.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import <KBZPayAPPPay/PaymentViewController.h>

@interface FlutterKbzPayPlugin () <FlutterStreamHandler>
@end

@implementation FlutterKbzPayPlugin {
    FlutterEventSink _eventSink;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_kbz_pay"
            binaryMessenger:[registrar messenger]];
  FlutterKbzPayPlugin* instance = [[FlutterKbzPayPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    FlutterEventChannel* chargingChannel =
        [FlutterEventChannel eventChannelWithName:@"flutter_kbz_pay/pay_status"
                                  binaryMessenger:[registrar messenger]];
    [chargingChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"startPay" isEqualToString:call.method]) {
    NSString *appId = call.arguments[@"appId"];
    NSString *prepayId = call.arguments[@"prepayId"];
    NSString *merchCode = call.arguments[@"merchCode"];
    NSString *signKey = call.arguments[@"signKey"];
    NSString *urlScheme = call.arguments[@"urlScheme"];
    NSNumber *data = [self startPay:appId :merchCode :prepayId :signKey :urlScheme];
    result((data));
  } else if([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSNumber *)startPay:(NSString*)appId :(NSString*)merchantCode :(NSString*)prepayId :(NSString*)signKey :(NSString*)urlScheme{

    NSString *nonceStrTF = [self getRandomStr];
    NSString *orderString = [NSString stringWithFormat:@"appid=%@&merch_code=%@&nonce_str=%@&prepay_id=%@&timestamp=%@",appId,merchantCode,nonceStrTF,prepayId,@"987654321"];

    NSString *signStr = [NSString stringWithFormat:@"%@&key=%@",orderString,signKey];
    NSString *sign = [self SHA256WithSignString:signStr];
    PaymentViewController *vc = [PaymentViewController new];
    [vc startPayWithOrderInfo:orderString signType:@"SHA256" sign:sign appScheme:urlScheme];
    return @0;
}

#pragma mark FlutterStreamHandler impl

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _eventSink = eventSink;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendPayStatus:) name:@"APPCallBack" object:nil];
  return nil;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _eventSink = nil;
    return nil;
}

- (void) sendPayStatus:(NSNotification *)noti {
    NSDictionary *infoDic = [noti object];
    NSString *extraResult = infoDic[@"EXTRA_RESULT"];
    if ([@"0" isEqualToString:extraResult]) {
        extraResult = @"1";
    }
    //0:success 3: cancel  目前只有两种状态返回
    _eventSink(extraResult);
}

-(NSString *)getRandomStr {
    char data[32];
    for (int x=0;x < 32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *randomStr = [[NSString alloc] initWithBytes:data length:6 encoding:NSUTF8StringEncoding];
    NSString *string = [NSString stringWithFormat:@"%@",randomStr];
    return string;
}

- (NSString*)SHA256WithSignString:(NSString*)signString {
    const char* str = [signString UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    ret = (NSMutableString *)[ret uppercaseString];
    return ret;
}

@end
