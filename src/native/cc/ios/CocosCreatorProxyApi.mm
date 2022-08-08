//
//  CocosCreatorProxyApi.m
//  NewProject-mobile
//
//  Created by huangdiao on 2021/7/20.
//

#import "CocosCreatorProxyApi.h"
#import <ThinkingSDK/ThinkingAnalyticsSDK.h>

#if __has_include("cocos/bindings/jswrapper/SeApi.h")
#include "cocos/bindings/jswrapper/SeApi.h"
#endif
#if __has_include("cocos/scripting/js-bindings/jswrapper/SeApi.h")
#include "cocos/scripting/js-bindings/jswrapper/SeApi.h"
#endif
using namespace std;

@interface NSString (JSON)
- (NSDictionary *)jsonDictionary;
@end
@implementation NSString (JSON)
- (NSDictionary *)jsonDictionary {
    if (self == nil) {
        return @{};
    } else {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            return json;
        } else {
            #ifdef DEBUG
            NSLog(@"Json 解析错误：%@, Json=%@", error.description, self);
            #endif
            return @{};
        }
    }
}
@end

@interface NSDictionary (SafeMode)
- (id)smValueForKey:(NSString *)key;
@end
@implementation NSDictionary (SafeMode)
- (id)smValueForKey:(NSString *)key {
    if (key!=nil) {
        return [self valueForKey:key];
    } else {
        return nil;
    }
}
@end

static NSMutableArray *sAppIds;
static NSMutableDictionary *sInstances;
static NSMutableDictionary *sAutoTracks;
static NSMutableDictionary *sAccountIds;
static NSString *sConfig;

@implementation CocosCreatorProxyApi
+ (void)setCustomerLibInfoWithLibName:(NSString *)libName libVersion:(NSString *) libVersion {
    [ThinkingAnalyticsSDK setCustomerLibInfoWithLibName:libName libVersion:libVersion];
}
+ (NSString*)currentAppId:(NSString*)appId {
    NSString *token = @"";
    if ((appId == nil || appId.length == 0) && sAppIds.count > 0)
    {
        token = self.appIds[0];
    } else if (appId.length > 0){
        token = appId;
    }
    return token;
}
+ (ThinkingAnalyticsSDK *)currentInstance:(NSString *)appid {
    ThinkingAnalyticsSDK *instance;
    NSString *token = [self currentAppId:appid];
    if (token.length > 0) {
        instance = [self.instances objectForKey:token];
    }
    if (instance == nil) {
        NSLog(@"Instance does not exist");
    }
    return  instance;
}
+ (ThinkingAnalyticsAutoTrackEventType)currentAutoTrack:(NSString *)appid {
    ThinkingAnalyticsAutoTrackEventType type = ThinkingAnalyticsEventTypeNone;
    NSString *token = [self currentAppId:appid];
    if (token.length > 0) {
        type = [[self.autoTracks objectForKey:token] intValue];
    }
    if (type == ThinkingAnalyticsEventTypeNone) {
        NSLog(@"Auto Track type is None");
    }
    return  type;
}
+ (BOOL)isInit {
    return self.appIds.count > 0;
}
+ (NSMutableArray* )appIds {
    if(sAppIds == nil) {
        sAppIds = [NSMutableArray new];
    }
    return  sAppIds;
}
+ (NSMutableDictionary *)instances {
    if(sInstances == nil) {
        sInstances = [NSMutableDictionary new];
    }
    return sInstances;
}
+ (NSMutableDictionary *)autoTracks {
    if(sAutoTracks == nil) {
        sAutoTracks = [NSMutableDictionary new];
    }
    return sAutoTracks;
}
+ (NSMutableDictionary *)accountIds {
    if(sAccountIds == nil) {
        sAccountIds = [NSMutableDictionary new];
    }
    return sAccountIds;
}
+ (void)sharedInstance:(NSString *)appId server:(NSString *)serverUrl {
    TDConfig *tdConfig = [TDConfig defaultTDConfig];
    tdConfig.appid = appId;
    tdConfig.configureURL = serverUrl;
    [self _sharedInstance:tdConfig];
}
+ (void)sharedInstance:(NSString *)config {
    NSDictionary *configDic = config.jsonDictionary;
    NSString *appId = [configDic smValueForKey:@"appId"];
    NSString *serverUrl = [configDic smValueForKey:@"serverUrl"];
    NSString *debugMode = [configDic smValueForKey:@"debugMode"];
    NSString *enableLog = [configDic smValueForKey:@"enableLog"];
    TDConfig *tdConfig = [TDConfig defaultTDConfig];
    tdConfig.appid = appId;
    tdConfig.configureURL = serverUrl;
    if ([debugMode isEqualToString:@"debug"]) {
        tdConfig.debugMode = ThinkingAnalyticsDebug;
    } else if ([debugMode isEqualToString:@"debugOnly"]) {
        tdConfig.debugMode = ThinkingAnalyticsDebugOn;
    } else {
        tdConfig.debugMode = ThinkingAnalyticsDebugOff;
    }
    if ([enableLog boolValue]) {
        [ThinkingAnalyticsSDK setLogLevel:TDLoggingLevelDebug];
    } else {
        [ThinkingAnalyticsSDK setLogLevel:TDLoggingLevelNone];
    }
    NSDictionary *autoTrack = [configDic smValueForKey:@"autoTrack"];
    if (autoTrack != nil) {
        ThinkingAnalyticsAutoTrackEventType type = ThinkingAnalyticsEventTypeNone;
        if ([autoTrack smValueForKey:@"appShow"] != nil && [[autoTrack smValueForKey:@"appShow"] boolValue]) {
            type = type | ThinkingAnalyticsEventTypeAppStart;
        }
        if ([autoTrack smValueForKey:@"appHide"] != nil && [[autoTrack smValueForKey:@"appHide"] boolValue]) {
            type = type | ThinkingAnalyticsEventTypeAppEnd;
        }
        if ([autoTrack smValueForKey:@"appClick"] != nil && [[autoTrack smValueForKey:@"appClick"] boolValue]) {
            type = type | ThinkingAnalyticsEventTypeAppClick;
        }
        if ([autoTrack smValueForKey:@"appView"] != nil && [[autoTrack smValueForKey:@"appView"] boolValue]) {
            type = type | ThinkingAnalyticsEventTypeAppViewScreen;
        }
        if ([autoTrack smValueForKey:@"appCrash"] != nil && [[autoTrack smValueForKey:@"appCrash"] boolValue]) {
            type = type | ThinkingAnalyticsEventTypeAppViewCrash;
        }
        if ([autoTrack smValueForKey:@"appInstall"] != nil && [[autoTrack smValueForKey:@"appInstall"] boolValue]) {
            type = type | ThinkingAnalyticsEventTypeAppInstall;
        }
        [self.autoTracks setValue:@(type) forKey:appId];
    }
    [self _sharedInstance:tdConfig];
}
+ (void)_sharedInstance:(TDConfig *)config {
    NSString *appId = config.appid;
    ThinkingAnalyticsSDK *instance = self.instances[appId];
    if (instance == nil) {
        instance = [ThinkingAnalyticsSDK startWithConfig:config];
        [self.instances setValue:instance forKey:appId];
        [self.appIds addObject:appId];
    }
}
+ (void)startThinkingAnalytics:(NSString *)appId {
    ThinkingAnalyticsAutoTrackEventType type = [self currentAutoTrack:appId];
    [[self currentInstance:appId] enableAutoTrack:type];
}
+ (void)track:(NSString *)eventName appId:(NSString *)appId {
    [[self currentInstance:appId] track:eventName];
}
+ (void)track:(NSString *)eventName properties:(NSString *)properties appId:(NSString *)appId {
    [[self currentInstance:appId] track:eventName properties:properties.jsonDictionary];
}
+ (void)track:(NSString *)eventName properties:(NSString *)properties time:(NSString *)time appId:(NSString *)appId {
    if (eventName == nil) {
        return;
    }
    NSDate *date = [self ccDateFromString:time];
    if (date == nil) {
        date = [NSDate date];
    }
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [[self currentInstance:appId] track:eventName properties:properties.jsonDictionary time:date timeZone:timeZone];
}
+ (void)trackUpdate:(NSString *)options appId:(NSString *)appId {
    NSDictionary *jsonDic = options.jsonDictionary;
    NSString *eventName = [jsonDic smValueForKey:@"eventName"];
    NSString *eventId = [jsonDic smValueForKey:@"eventId"];
    TDUpdateEventModel *eventModel = [[TDUpdateEventModel alloc] initWithEventName:eventName eventID:eventId];
    if ([jsonDic smValueForKey:@"time"]) {
        NSDate *date = [self ccDateFromString:[jsonDic smValueForKey:@"time"]];
        [eventModel configTime:date timeZone:[NSTimeZone localTimeZone]];
    }
    if ([jsonDic smValueForKey:@"properties"]) {
        eventModel.properties = [jsonDic smValueForKey:@"properties"];
    }
    [[self currentInstance:appId] trackWithEventModel:eventModel];
}
+ (void)trackFirstEvent:(NSString *)options appId:(NSString *)appId {
    NSDictionary *jsonDic = options.jsonDictionary;
    NSString *eventName = [jsonDic smValueForKey:@"eventName"];
    NSString *firstCheckId = [jsonDic smValueForKey:@"firstCheckId"];
    TDFirstEventModel *eventModel = nil;
    if (firstCheckId != nil) {
        eventModel = [[TDFirstEventModel alloc] initWithEventName:eventName firstCheckID:firstCheckId];
    } else {
        eventModel = [[TDFirstEventModel alloc] initWithEventName:eventName];
    }
    if ([jsonDic smValueForKey:@"time"]) {
        NSDate *date = [self ccDateFromString:[jsonDic smValueForKey:@"time"]];
        [eventModel configTime:date timeZone:[NSTimeZone localTimeZone]];
    }
    if ([jsonDic smValueForKey:@"properties"]) {
        eventModel.properties = [jsonDic smValueForKey:@"properties"];
    }
    [[self currentInstance:appId] trackWithEventModel:eventModel];
}
+ (void)trackOverwrite:(NSString *)options appId:(NSString *)appId {
    NSDictionary *jsonDic = options.jsonDictionary;
    NSString *eventName = [jsonDic smValueForKey:@"eventName"];
    NSString *firstCheckId = [jsonDic smValueForKey:@"firstCheckId"];
    NSString *eventId = [jsonDic smValueForKey:@"eventId"];
    TDOverwriteEventModel *eventModel = [[TDOverwriteEventModel alloc] initWithEventName:eventName eventID:eventId];
    if ([jsonDic smValueForKey:@"time"]) {
        NSDate *date = [self ccDateFromString:[jsonDic smValueForKey:@"time"]];
        [eventModel configTime:date timeZone:[NSTimeZone localTimeZone]];
    }
    if ([jsonDic smValueForKey:@"properties"]) {
        eventModel.properties = [jsonDic smValueForKey:@"properties"];
    }
    [[self currentInstance:appId] trackWithEventModel:eventModel];
}
+ (void)timeEvent:(NSString *)eventName appId:(NSString *)appId {
    [[self currentInstance:appId] timeEvent:eventName];
}
+ (void)login:(NSString *)accoundId appId:(NSString *)appId {
    [[self accountIds] setObject:accoundId forKey:[self currentAppId:appId]];
    [[self currentInstance:appId] login:accoundId];
}
+ (void)logout:(NSString *)appId  {
    [[self accountIds] removeObjectForKey:[self currentAppId:appId]];
    [[self currentInstance:appId] logout];
}
+ (void)setSuperProperties:(NSString *)properties appId:(NSString *)appId {
    [[self currentInstance:appId] setSuperProperties:properties.jsonDictionary];
}
+ (void)unsetSuperProperty:(NSString *)property appId:(NSString *)appId {
    [[self currentInstance:appId] unsetSuperProperty:property];
}
+ (void)clearSuperProperties:(NSString *)appId  {
    [[self currentInstance:appId] clearSuperProperties];
}
+ (void)userSet:(NSString *)properties appId:(NSString *)appId {
    [[self currentInstance:appId] user_set:properties.jsonDictionary];
}
+ (void)userSetOnce:(NSString *)properties appId:(NSString *)appId {
    [[self currentInstance:appId] user_setOnce:properties.jsonDictionary];
}
+ (void)userAppend:(NSString *)properties appId:(NSString *)appId {
    [[self currentInstance:appId] user_append:properties.jsonDictionary];
}
+ (void)userAdd:(NSString *)properties appId:(NSString *)appId {
    [[self currentInstance:appId] user_add:properties.jsonDictionary];
}
+ (void)userUnset:(NSString *)property appId:(NSString *)appId {
    [[self currentInstance:appId] user_unset:property];
}
+ (void)userDel:(NSString *)appId  {
    [[self currentInstance:appId] user_delete];
}
+ (void)authorizeOpenID:(NSString *)distinctId appId:(NSString *)appId {
    [[self currentInstance:appId] identify:distinctId];
}
+ (void)identify:(NSString *)distinctId appId:(NSString *)appId {
    [[self currentInstance:appId] identify:distinctId];
}
+ (void)initInstance:(NSString *)name appId:(NSString *)appId {
    self.instances[name] = [self currentInstance:appId];
}
+ (void)initInstance:(NSString *)name config:(NSString *)config {
    [self sharedInstance:config];
    NSDictionary *configDic = config.jsonDictionary;
    NSString *appId = [configDic smValueForKey:@"appId"];
    self.instances[name] = [self currentInstance:appId];
}
+ (NSString *)lightInstance:(NSString *)name appId:(NSString *)appId {
    if([self currentInstance:appId] != nil) {
        ThinkingAnalyticsSDK *lightInstance =  [[self currentInstance:appId] createLightInstance];
        NSString *uuid = [NSUUID UUID].UUIDString;
        self.instances[uuid] = lightInstance;
        return uuid;
    } else {
        return @"";
    }
}
+ (void)setDynamicSuperProperties:(NSString *)callFromNative appId:(NSString *)appId {
    [[self currentInstance:appId] registerDynamicSuperProperties:^NSDictionary<NSString *, id> *(){
        const char *cstr = [CocosCreatorProxyApi callJSMethod:[callFromNative UTF8String]];
        NSString *dynamicProperties = [[NSString alloc] initWithCString:cstr encoding:NSUTF8StringEncoding];
        return dynamicProperties.jsonDictionary;
    }];
}
+ (NSString *)getDeviceId:(NSString *)appId  {
    return [[self currentInstance:appId] getDeviceId];
}
+ (NSString *)getDistinctId:(NSString *)appId {
    return [[self currentInstance:appId] getDistinctId];
}
+ (NSString *)getAccountId:(NSString *)appId {
    NSString *ret = [[self accountIds] objectForKey:[self currentAppId:appId]];
    if (ret == nil || ret.length<0) {
        ret = [[self currentInstance:appId] valueForKey:@"accountId"];
    }
    return ret?:@"";
}
+ (NSString *)getSuperProperties:(NSString *)appId {
    NSDictionary *jsonDict = [[self currentInstance:appId] currentSuperProperties];
    if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
        if (error == nil) {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return @"{}";
}
+ (NSString *)getPresetProperties:(NSString *)appId {
    TDPresetProperties *presetProperties = [[self currentInstance:appId] getPresetProperties];
    NSDictionary *jsonDict = [presetProperties toEventPresetProperties];
    if ([NSJSONSerialization isValidJSONObject:jsonDict]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
        if (error == nil) {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return @"{}";
}
+ (void)enableTracking:(NSString *)enabled appId:(NSString *)appId {
    [[self currentInstance:appId] enableTracking:enabled.boolValue];
}
+ (void)optOutTracking:(NSString *)appId {
    [[self currentInstance:appId] optOutTracking];
}
+ (void)optOutTrackingAndDeleteUser:(NSString *)appId {
    [[self currentInstance:appId] optOutTrackingAndDeleteUser];
}
+ (void)optInTracking:(NSString *)appId {
    [[self currentInstance:appId] optInTracking];
}

+ (NSDate *)ccDateFromString:(NSString *)time {
    static NSString *kDateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = kDateFormat;
    NSDate *dateTime = [dateFormatter dateFromString:time];
    return dateTime;
}
+ (const char *)callJSMethod:(const char *)selector {
    std::string s = "window.";
    s += selector;
    s += "('msg from oc')";
    se::Value *ret = new se::Value();
    BOOL result = se::ScriptEngine::getInstance()->evalString(s.c_str(), -1, ret);
    if (result) {
        const char *cstr = ret->toString().c_str();
        NSLog(@"jsCallStr succeed! ret = %s", ret->toString().c_str());
        return cstr;
    } else {
        NSLog(@"jsCallStr failed!");
        return "";
    }
}

@end
