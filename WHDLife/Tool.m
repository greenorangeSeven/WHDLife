//
//  Tool.m
//  oschina
//
//  Created by wangjun on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (UIAlertView *)getLoadingView:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *progressAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(121, 80, 37, 37);
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

+ (NSString *)getBBSIndex:(int)index
{
    if (index < 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%d楼", index+1];
}

+ (void)toTableViewBottom:(UITableView *)tableView isBottom:(BOOL)isBottom
{
    if (isBottom) {
        NSUInteger sectionCount = [tableView numberOfSections];
        if (sectionCount) {
            NSUInteger rowCount = [tableView numberOfRowsInSection:0];
            if (rowCount) {
                NSUInteger ii[2] = {0, rowCount - 1};
                NSIndexPath * indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:isBottom ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop animated:YES];
            }
        }
    }
    else
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

+ (NSString *)getCommentLoginNoticeByCatalog:(int)catalog
{
    switch (catalog) {
        case 1:
        case 3:
            return @"请先登录后发表评论";
        case 2:
            return @"请先登录后再回帖或评论";
        case 4:
            return @"请先登录后发留言";
    }
    return @"请先登录后发表评论";
}

+ (void)borderView:(UIView *)view
{
    view.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0] CGColor];
    view.layer.borderWidth = 1;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
}

+ (void)roundTextView:(UIView *)txtView andBorderWidth:(float)width andCornerRadius:(float)radius
{
    txtView.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0] CGColor];
    txtView.layer.borderWidth = width;
    txtView.layer.cornerRadius = radius;
    txtView.layer.masksToBounds = YES;
    txtView.clipsToBounds = YES;
}

+ (void)roundView:(UIView *)view andCornerRadius:(float)radius
{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
}

+ (void)playAudio:(BOOL)isAlert
{
    NSString * path = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath], isAlert ? @"/alertsound.wav" : @"/soundeffect.wav"];
    SystemSoundID soundID;
    NSURL * filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

+ (UIColor *)getColorForCell:(int)row
{
    return row % 2 ?
    [UIColor colorWithRed:235.0/255.0 green:242.0/255.0 blue:252.0/255.0 alpha:1.0]:
    [UIColor colorWithRed:248.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
}

+ (UIColor *)getColorForMain
{
    return [UIColor colorWithRed:227.0/255.0 green:49.0/255.0 blue:36.0/255.0 alpha:1.0];
}

+ (void)clearWebViewBackground:(UIWebView *)webView
{
    UIWebView *web = webView;
    for (id v in web.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            [v setBounces:NO];
        }
    }
}

+ (void)doSound:(id)sender
{
    NSError *err;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"soundeffect" ofType:@"wav"]] error:&err];
    player.volume = 1;
    player.numberOfLoops = 1;
    [player prepareToPlay];
    [player play];
}

+ (NSString *)getAppClientString:(int)appClient
{
    switch (appClient) {
        case 1:
            return @"";
        case 2:
            return @"来自手机";
        case 3:
            return @"来自手机";
        case 4:
            return @"来自iPhone";
        case 5:
            return @"来自手机";
        default:
            return @"";
    }
}

+ (void)ReleaseWebView:(UIWebView *)webView
{
    [webView stopLoading];
    [webView setDelegate:nil];
    webView = nil;
}

+ (void)noticeLogin:(UIView *)view andDelegate:(id)delegate andTitle:(NSString *)title
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请先登录或注册" delegate:delegate cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"登录", @"注册", nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}
+ (void)processLoginNotice:(UIActionSheet *)actionSheet andButtonIndex:(NSInteger)buttonIndex andNav:(UINavigationController *)nav andParent:(UIViewController *)parent
{
    //    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    //    if ([buttonTitle isEqualToString:@"登录"]) {
    //        LoginView *loginView = [[LoginView alloc] init];
    //        [nav pushViewController:loginView animated:YES];
    //    }
    //    else if([buttonTitle isEqualToString:@"注册"])
    //    {
    //        RegisterView *regView = [[RegisterView alloc] init];
    //        [nav pushViewController:regView animated:YES];
    //    }
}

+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    else if (cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    else
    {
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        NSArray *array = [theDate componentsSeparatedByString:@" "];
        //        return [array objectAtIndex:0];
        timeString = [array objectAtIndex:0];
    }
    return timeString;
}

+ (BOOL)isToday:(NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=now-late;
    
    if (cha/86400<1) {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(int)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt
{
    float fPadding = 16.0;
    CGSize constraint = CGSizeMake(txtView.contentSize.width - 10 - fPadding, CGFLOAT_MAX);
    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float fHeight = size.height + 16.0;
    return fHeight;
}

- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

+(int)getTextHeight:(int)width andUIFont:(UIFont *)font andText:(NSString *)txt
{
    float fPadding = 16.0;
    CGSize constraint = CGSizeMake(width - 10 - fPadding, CGFLOAT_MAX);
    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    float fHeight = size.height + 16.0;
    return fHeight;
}

/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width - 16, CGFLOAT_MAX) lineBreakMode:UILineBreakModeTailTruncation];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

+ (int)getDaysCount:(int)year andMonth:(int)month andDay:(int)day
{
    return year*365 + month * 31 + day;
}

+ (UIColor *)getBackgroundColor
{
    //    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"fb_bg.jpg"]];
    return [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
}
+ (UIColor *)getCellBackgroundColor
{
    return [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0];
}

+ (void)saveCache:(int)type andID:(int)_id andString:(NSString *)str
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    [setting setObject:str forKey:key];
    [setting synchronize];
}
+ (NSString *)getCache:(int)type andID:(int)_id
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"detail-%d-%d",type, _id];
    
    NSString *value = [settings objectForKey:key];
    return value;
}

+ (void)deleteAllCache
{
}

+ (NSString *)getHTMLString:(NSString *)html
{
    return html;
}
+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.labelText = text;
    //    hud.dimBackground = YES;
    hud.square = YES;
    [hud show:YES];
}

+ (void)showCustomHUD:(NSString *)text andView:(UIView *)view andImage:(NSString *)image andAfterDelay:(int)second
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]] ;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = text;
    [HUD show:YES];
    [HUD hide:YES afterDelay:second];
}

+ (UIImage *)scale:(UIImage *)sourceImg toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [sourceImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+ (CGSize)scaleSize:(CGSize)sourceSize
{
    float width = sourceSize.width;
    float height = sourceSize.height;
    if (width >= height) {
        return CGSizeMake(800, 800 * height / width);
    }
    else
    {
        return CGSizeMake(800 * width / height, 800);
    }
}

+ (NSString *)getOSVersion
{
    return [NSString stringWithFormat:@"GreenOrange.com/%@/%@/%@/%@",AppVersion,[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion, [UIDevice currentDevice].model];
}

//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (void)ToastNotification:(NSString *)text andView:(UIView *)view andLoading:(BOOL)isLoading andIsBottom:(BOOL)isBottom
{
    GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:text showActivity:isLoading inPresentationMode:isBottom?GCDiscreetNotificationViewPresentationModeBottom:GCDiscreetNotificationViewPresentationModeTop inView:view];
    [notificationView show:YES];
    [notificationView hideAnimatedAfter:2.6];
}
+ (void)CancelRequest:(ASIHTTPRequest *)request
{
    if (request != nil) {
        [request cancel];
        [request clearDelegatesAndCancel];
    }
}
+ (NSDate *)NSStringDateToNSDate:(NSString *)string
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * d = [f dateFromString:string];
    return d;
}

+ (NSString *)TimestampToDateStr:(NSString *)timestamp andFormatterStr:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]];
    return [dateFormatter stringFromDate:confromTimesp];
}

+ (NSString *)GenerateTags:(NSMutableArray *)tags
{
    if (tags == nil || tags.count == 0) {
        return @"";
    }
    else
    {
        NSString *result = @"";
        for (NSString *t in tags) {
            result = [NSString stringWithFormat:@"%@<a style='background-color: #BBD6F3;border-bottom: 1px solid #3E6D8E;border-right: 1px solid #7F9FB6;color: #284A7B;font-size: 12pt;-webkit-text-size-adjust: none;line-height: 2.4;margin: 2px 2px 2px 0;padding: 2px 4px;text-decoration: none;white-space: nowrap;' href='http://www.oschina.net/question/tag/%@' >&nbsp;%@&nbsp;</a>&nbsp;&nbsp;",result,t,t];
        }
        return result;
    }
}

+ (void)saveCache:(NSString *)catalog andType:(int)type andID:(int)_id andString:(NSString *)str
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"%@-%d-%d",catalog,type, _id];
    [setting setObject:str forKey:key];
    [setting synchronize];
}
+ (NSString *)getCache:(NSString *)catalog andType:(int)type andID:(int)_id
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@-%d-%d",catalog,type, _id];
    
    NSString *value = [settings objectForKey:key];
    return value;
}

+ (NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (BOOL)testAlipayInstall
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        NSLog(@"支付宝install--");
        return YES;
    }else{
        NSLog(@"支付宝no---");
        return NO;
    }
}

+ (BOOL)testWeiXinInstall
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        NSLog(@"微信install--");
        return YES;
    }else{
        NSLog(@"微信no---");
        return NO;
    }
}

+ (NSDictionary*)getObjectData:(id)obj
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+(NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error
{
    
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData:obj] options:options error:error];
}



+(id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       ||
       [obj isKindOfClass:[NSNumber class]]
       ||
       [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr
             setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys)
        {
            [dic
             setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

//平台接口生成验签
+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            return nil;
        }
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

//平台接口生成验签
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params
{
    NSURL* parsedURL = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:[parsedURL query]]];
    if (params) {
        [paramsDic setValuesForKeysWithDictionary:params];
    }
    
    NSMutableString *signString = [NSMutableString stringWithString:[NSString stringWithFormat:@"accessId%@", AccessId]];
    NSMutableString *paramsString = [NSMutableString stringWithFormat:@"accessId=%@", AccessId];
    NSArray *sortedKeys = [[paramsDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    for (NSString *key in sortedKeys) {
        [signString appendFormat:@"%@%@", key, [paramsDic objectForKey:key]];
        [paramsString appendFormat:@"&%@=%@", key, [paramsDic objectForKey:key]];
    }
    [signString appendString:AccessKey];
    NSString *signStringUTF8 = [signString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    NSData *stringBytes = [signStringUTF8 dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_MD5([stringBytes bytes], [stringBytes length], digest)) {
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString *digestString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
        for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02X", aChar];
        }
        [paramsString appendFormat:@"&sign=%@", [digestString lowercaseString]];
        return [NSString stringWithFormat:@"%@://%@:%@%@?%@", [parsedURL scheme], [parsedURL host], [parsedURL port], [parsedURL path], [paramsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else {
        return nil;
    }
}

//平台接口生成验签Sign中文转UFT-8
+ (NSString *)serializeUFT8Sign:(NSString *)baseURL params:(NSDictionary *)params
{
    NSURL* parsedURL = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:[parsedURL query]]];
    if (params) {
        [paramsDic setValuesForKeysWithDictionary:params];
    }
    
    NSMutableString *signString = [NSMutableString stringWithString:[NSString stringWithFormat:@"accessId%@", AccessId]];
    NSArray *sortedKeys = [[paramsDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    for (NSString *key in sortedKeys) {
        [signString appendFormat:@"%@%@", key, [paramsDic objectForKey:key]];
    }
    [signString appendString:AccessKey];
    NSString *signStringUTF8 = [signString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    NSData *stringBytes = [signStringUTF8 dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_MD5([stringBytes bytes], [stringBytes length], digest)) {
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString *digestString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
        for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02X", aChar];
        }
        return [digestString lowercaseString];
    } else {
        return nil;
    }
}

//平台接口生成验签Sign中文
+ (NSString *)serializeSign:(NSString *)baseURL params:(NSDictionary *)params
{
    NSURL* parsedURL = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:[parsedURL query]]];
    if (params) {
        [paramsDic setValuesForKeysWithDictionary:params];
    }
    
    NSMutableString *signString = [NSMutableString stringWithString:[NSString stringWithFormat:@"accessId%@", AccessId]];
    NSArray *sortedKeys = [[paramsDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    for (NSString *key in sortedKeys) {
        [signString appendFormat:@"%@%@", key, [paramsDic objectForKey:key]];
    }
    [signString appendString:AccessKey];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    NSData *stringBytes = [signString dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_MD5([stringBytes bytes], [stringBytes length], digest)) {
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString *digestString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
        for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02X", aChar];
        }
        return [digestString lowercaseString];
    } else {
        return nil;
    }
}

+ (NSString* )databasePath
{
    NSString* path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dbPath=[path stringByAppendingPathComponent:@"dlife.db"];
    return dbPath;
}

//解析城市JSON
+ (NSMutableArray *)readJsonStrToCityArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *cityJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( cityJsonDic == nil || [cityJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[cityJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *cityArrayJson = [cityJsonDic objectForKey:@"data"];
        NSMutableArray *cityArray = [RMMapper mutableArrayOfClass:[City class] fromArrayOfDictionary:cityArrayJson];
        return cityArray;
    }
    else
    {
        return nil;
    }
}

//解析社区JSON（包含社区、区域）
+ (NSMutableArray *)readJsonStrToCommunityArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *communityJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( communityJsonDic == nil || [communityJsonDic count] <= 0) {
        return nil;
    }
    NSArray *communityArrayJson = [communityJsonDic objectForKey:@"data"];
    NSMutableArray *communityArray = [RMMapper mutableArrayOfClass:[Community class] fromArrayOfDictionary:communityArrayJson];
    for (Community *comu in communityArray) {
        NSArray *comuSubList = comu.subList;
        comu.regionList = [RMMapper mutableArrayOfClass:[Region class] fromArrayOfDictionary:comuSubList];
        for (Region *region in comu.regionList) {
            NSArray *regionSubList = region.subList;
            region.buildingList = [RMMapper mutableArrayOfClass:[Building class] fromArrayOfDictionary:regionSubList];
            for (Building *building in region.buildingList) {
                NSArray *buildingSubList = building.subList;
                building.unitList = [RMMapper mutableArrayOfClass:[Unit class] fromArrayOfDictionary:buildingSubList];
                for (Unit *unit in building.unitList) {
                    NSArray *unitSubList = unit.subList;
                    unit.houseNumList = [RMMapper mutableArrayOfClass:[HouseNum class] fromArrayOfDictionary:unitSubList];
                }
            }
        }
    }
    return communityArray;
}

//解析社区JSON（楼栋、门牌）
+ (NSMutableArray *)readJsonStrToUnitArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *unitJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( unitJsonDic == nil || [unitJsonDic count] <= 0) {
        return nil;
    }
    NSArray *unitArrayJson = [unitJsonDic objectForKey:@"data"];
    NSMutableArray *unitArray = [RMMapper mutableArrayOfClass:[Unit class] fromArrayOfDictionary:unitArrayJson];
    for (Unit *unit in unitArray) {
        NSArray *unitSubList = unit.subList;
        unit.houseNumList = [RMMapper mutableArrayOfClass:[HouseNum class] fromArrayOfDictionary:unitSubList];
    }
    return unitArray;
}

//解析登陆JSON
+ (UserInfo *)readJsonStrToLoginUserInfo:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *userJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( userJsonDic == nil || [userJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[userJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSDictionary *userInfoDic = [userJsonDic objectForKey:@"data"];
        UserInfo *userInfo = [RMMapper objectWithClass:[UserInfo class] fromDictionary:userInfoDic];
        NSMutableArray *rhUserHouseList = [RMMapper mutableArrayOfClass:[UserHouse class] fromArrayOfDictionary:[userInfoDic objectForKey:@"rhUserHouseList"]];
        userInfo.rhUserHouseList = rhUserHouseList;
        return userInfo;
    }
    else
    {
        return nil;
    }
}

//解析社区活动JSON
+ (NSMutableArray *)readJsonStrToActivityArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *activityJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( activityJsonDic == nil || [activityJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[activityJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *activityArrayJson = [[activityJsonDic objectForKey:@"data"] objectForKey:@"resultsList"];
        NSMutableArray *activityArray = [RMMapper mutableArrayOfClass:[Activity class] fromArrayOfDictionary:activityArrayJson];
        
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long int nowStamp = (long long int)time;
        
        for (Activity *info in activityArray) {
            info.starttime = [self TimestampToDateStr:[info.starttimeStamp stringValue] andFormatterStr:@"MM月dd日"];
            info.endtime = [self TimestampToDateStr:[info.endtimeStamp stringValue] andFormatterStr:@"MM月dd日"];
            info.cutoffTime = [self TimestampToDateStr:[info.cutoffTimeStamp stringValue] andFormatterStr:@"yyyy/MM/dd"];
            //进行中：介于开始时间与结束时间之间
            if( nowStamp < [info.cutoffTimeStamp longLongValue])
            {
                info.stateId = 1;
                info.stateName = @"报名中";
            }
            //进行中：介于开始时间与结束时间之间
            if( nowStamp > [info.starttimeStamp longLongValue] && nowStamp < [info.endtimeStamp longLongValue])
            {
                info.stateId = 2;
                info.stateName = @"进行中";
            }
            //已结束：当前时间大于结束时间
            if (nowStamp > [info.endtimeStamp longLongValue]) {
                info.stateId = 3;
                info.stateName = @"已结束";
            }
        }
        return activityArray;
    }
    else
    {
        return nil;
    }
}

//解析社区活动详情JSON
+ (Activity *)readJsonStrToActivityDetail:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *activityJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( activityJsonDic == nil || [activityJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[activityJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        Activity *activityDetail = [RMMapper objectWithClass:[Activity class] fromDictionary:[activityJsonDic objectForKey:@"data"]];
        
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long int nowStamp = (long long int)time;
        
        activityDetail.starttime = [self TimestampToDateStr:[activityDetail.starttimeStamp stringValue] andFormatterStr:@"MM月dd日"];
        activityDetail.endtime = [self TimestampToDateStr:[activityDetail.endtimeStamp stringValue] andFormatterStr:@"MM月dd日"];
        activityDetail.cutoffTime = [self TimestampToDateStr:[activityDetail.cutoffTimeStamp stringValue] andFormatterStr:@"MM月dd日"];
        //进行中：介于开始时间与结束时间之间
        if( nowStamp > [activityDetail.cutoffTimeStamp longLongValue])
        {
            activityDetail.stateId = 4;
            activityDetail.stateName = @"已截止";
        }
        else
        {
            activityDetail.stateId = 0;
        }
        
        return activityDetail;
    }
    else
    {
        return nil;
    }
}

//解析报修列表JSON
+ (NSMutableArray *)readJsonStrToRepairArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *repairJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( repairJsonDic == nil || [repairJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[repairJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *repairArrayJson = [[repairJsonDic objectForKey:@"data"] objectForKey:@"resultsList"];
        NSMutableArray *repairArray = [RMMapper mutableArrayOfClass:[Repair class] fromArrayOfDictionary:repairArrayJson];
        for (Repair *r in repairArray) {
            r.starttime = [self TimestampToDateStr:r.starttimeStamp andFormatterStr:@"yyyy年MM月dd日 HH:mm"];
        }
        return repairArray;
    }
    else
    {
        return nil;
    }
}

//解析报修详情JSON
+ (NSMutableArray *)readJsonStrToRepairItemArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *repairDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( repairDic == nil || [repairDic count] <= 0) {
        return nil;
    }
    NSString *state = [[repairDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        NSDictionary *repairDicJson = [repairDic objectForKey:@"data"];
        //        NSMutableArray *serviceArray = [RMMapper mutableArrayOfClass:[CallService class] fromArrayOfDictionary:repairDicJson];
        RepairBasic *basic = [RMMapper objectWithClass:[RepairBasic class] fromDictionary:repairDicJson];
        basic.starttime = [self TimestampToDateStr:[basic.starttimeStamp stringValue] andFormatterStr:@"yyyy年MM月dd日 HH:mm"];
        basic.contentHeight = [self getTextHeight:304 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14] andText:basic.repairContent];
        if (basic.contentHeight < 36)
        {
            basic.contentHeight = 36;
            basic.viewAddHeight = 0;
        }
        else
        {
            basic.viewAddHeight = basic.contentHeight - 36;
        }
        basic.fullImgList = [[NSMutableArray alloc] init];
        for (int i = 0; i < [basic.imgList count]; i++) {
            NSDictionary *imageDicJson = [basic.imgList objectAtIndex:i];
            [basic.fullImgList addObject:[imageDicJson objectForKey:@"imgUrlFull"]];
        }
        //添加报修基础数据
        [items addObject:basic];
        
        for (int l = 0; l < [basic.repairRunList count]; l++) {
            if (l == 0) {
                RepairDispatch *dispatch = [[RepairDispatch alloc] init];
                dispatch.repairmanId = basic.repairmanId;
                dispatch.repairmanName = basic.repairmanName;
                dispatch.mobileNo = basic.mobileNo;
                dispatch.starttimeStamp = [[basic.repairRunList objectAtIndex:l] objectForKey:@"starttimeStamp"];
                dispatch.starttime = [self TimestampToDateStr:[dispatch.starttimeStamp stringValue] andFormatterStr:@"yyyy年MM月dd日 HH:mm"];
                //添加报修派单数据
                [items addObject:dispatch];
            }
            if (l == 1) {
                RepairFinish *finish = [[RepairFinish alloc] init];
                finish.runContent = [[basic.repairRunList objectAtIndex:l] objectForKey:@"runContent"];
                finish.cost = basic.cost;
                finish.starttimeStamp = [[basic.repairRunList objectAtIndex:l] objectForKey:@"starttimeStamp"];
                finish.starttime = [self TimestampToDateStr:[finish.starttimeStamp stringValue] andFormatterStr:@"yyyy年MM月dd日 HH:mm"];
                
                finish.contentHeight = [self getTextHeight:304 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14] andText:finish.runContent];
                if (finish.contentHeight < 36)
                {
                    finish.contentHeight = 36;
                    finish.viewAddHeight = 0;
                }
                else
                {
                    finish.viewAddHeight = finish.contentHeight - 36;
                }
                
                //添加维修完成数据
                [items addObject:finish];
            }
        }
        if ([items count] >= 3 && basic.repairResult != nil) {
            RepairResult *result = basic.repairResult;
            result.contentHeight = [self getTextHeight:304 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14] andText:result.userRecontent];
            if (result.contentHeight < 36)
            {
                result.contentHeight = 36;
                result.viewAddHeight = 0;
            }
            else
            {
                result.viewAddHeight = result.contentHeight - 36;
            }
            //添加维修评论数据
            [items addObject:result];
        }
        
        return items;
    }
    else
    {
        return nil;
    }
}

//解析广告JSON
+ (NSMutableArray *)readJsonStrToAdinfoArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *adJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( adJsonDic == nil || [adJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[adJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *adArrayJson = [adJsonDic objectForKey:@"data"];
        NSMutableArray *adArray = [RMMapper mutableArrayOfClass:[ADInfo class] fromArrayOfDictionary:adArrayJson];
        return adArray;
    }
    else
    {
        return nil;
    }
}

//解析小区通知JSON
+ (NSMutableArray *)readJsonStrToNoticeArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *noticeJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( noticeJsonDic == nil || [noticeJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[noticeJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *noticeArrayJson = [[noticeJsonDic objectForKey:@"data"] objectForKey:@"resultsList"];
        NSMutableArray *noticeArray = [RMMapper mutableArrayOfClass:[Notice class] fromArrayOfDictionary:noticeArrayJson];
        for (Notice *n in noticeArray) {
            n.starttime = [self TimestampToDateStr:n.starttimeStamp andFormatterStr:@"yyyy年MM月dd日 HH:mm"];
        }
        return noticeArray;
    }
    else
    {
        return nil;
    }
}

//解析投诉列表JSON
+ (NSMutableArray *)readJsonStrToSuitArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *suitJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( suitJsonDic == nil || [suitJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[suitJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *suitArrayJson = [[suitJsonDic objectForKey:@"data"] objectForKey:@"resultsList"];
        NSMutableArray *suitArray = [RMMapper mutableArrayOfClass:[Suit class] fromArrayOfDictionary:suitArrayJson];
        for (Suit *s in suitArray) {
            s.starttime = [self TimestampToDateStr:[s.starttimeStamp stringValue] andFormatterStr:@"yyyy年MM月dd日 HH:mm"];
        }
        return suitArray;
    }
    else
    {
        return nil;
    }
}

//解析投诉详情JSON
+ (NSMutableArray *)readJsonStrToSuitItemArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *suitDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( suitDic == nil || [suitDic count] <= 0) {
        return nil;
    }
    NSString *state = [[suitDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        NSDictionary *suitDicJson = [suitDic objectForKey:@"data"];
        
        SuitBasic *basic = [RMMapper objectWithClass:[SuitBasic class] fromDictionary:suitDicJson];
        basic.starttime = [self TimestampToDateStr:[basic.starttimeStamp stringValue] andFormatterStr:@"yyyy年MM月dd日 HH:mm"];
        basic.contentHeight = [self getTextHeight:304 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14] andText:basic.suitContent];
        if (basic.contentHeight < 36)
        {
            basic.contentHeight = 36;
            basic.viewAddHeight = 0;
        }
        else
        {
            basic.viewAddHeight = basic.contentHeight - 36;
        }
        //将图片对象转图片数组
        basic.fullImgList = [[NSMutableArray alloc] init];
        for (int i = 0; i < [basic.imgList count]; i++) {
            NSDictionary *imageDicJson = [basic.imgList objectAtIndex:i];
            [basic.fullImgList addObject:[imageDicJson objectForKey:@"imgUrlFull"]];
        }
        //添加投诉基础数据
        [items addObject:basic];
        if (basic.suitReply != nil) {
            basic.suitReply.replyTime = [self TimestampToDateStr:[basic.suitReply.replyTimeStamp stringValue] andFormatterStr:@"yyyy年MM月dd日 HH:mm"];
            basic.suitReply.contentHeight = [self getTextHeight:304 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14] andText:basic.suitReply.replyContent];
            if (basic.suitReply.contentHeight < 36)
            {
                basic.suitReply.contentHeight = 36;
                basic.suitReply.viewAddHeight = 0;
            }
            else
            {
                basic.suitReply.viewAddHeight = basic.suitReply.contentHeight - 36;
            }
            //添加投诉反馈数据
            [items addObject:basic.suitReply];
        }
        if ([items count] >= 2 && basic.suitResult != nil) {
            SuitResult *result = basic.suitResult;
            result.contentHeight = [self getTextHeight:304 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14] andText:result.userRecontent];
            if (result.contentHeight < 36)
            {
                result.contentHeight = 36;
                result.addViewHeight = 0;
            }
            else
            {
                result.addViewHeight = result.contentHeight - 36;
            }
            //添加投诉评论数据
            [items addObject:result];
        }
        
        return items;
    }
    else
    {
        return nil;
    }
}

//解析收件列表列表JSON
+ (NSMutableArray *)readJsonStrToExpressArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *expressJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( expressJsonDic == nil || [expressJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[expressJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *expArrayJson = [[expressJsonDic objectForKey:@"data"] objectForKey:@"resultsList"];
        NSMutableArray *expArray = [RMMapper mutableArrayOfClass:[ExpressInfo class] fromArrayOfDictionary:expArrayJson];
        return expArray;
    }
    else
    {
        return nil;
    }
}

//解析快递公司列表JSON
+ (NSMutableArray *)readJsonStrToExpressCompanyArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *comJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( comJsonDic == nil || [comJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[comJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *comArrayJson = [comJsonDic objectForKey:@"data"];
        NSMutableArray *comArray = [RMMapper mutableArrayOfClass:[ExpressCompany class] fromArrayOfDictionary:comArrayJson];
        return comArray;
    }
    else
    {
        return nil;
    }
}

//解析商品分类JSON
+ (NSMutableArray *)readJsonStrToCommodityClassArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *classJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( classJsonDic == nil || [classJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[classJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *classArrayJson = [[classJsonDic objectForKey:@"data"] objectForKey:@"resultsList"];
        NSMutableArray *classArray = [RMMapper mutableArrayOfClass:[CommodityClass class] fromArrayOfDictionary:classArrayJson];
        return classArray;
    }
    else
    {
        return nil;
    }
}

//解析商品JSON
+ (NSMutableArray *)readJsonStrToCommodityArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *commodityJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( commodityJsonDic == nil || [commodityJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[commodityJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *commodityArrayJson = [[commodityJsonDic objectForKey:@"data"] objectForKey:@"resultsList"];
        NSMutableArray *commodityArray = [RMMapper mutableArrayOfClass:[Commodity class] fromArrayOfDictionary:commodityArrayJson];
        //将图片对象转图片数组
        for (Commodity *c in commodityArray) {
            c.imgStrList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [c.imgList count]; i++) {
                NSDictionary *imageDicJson = [c.imgList objectAtIndex:i];
                [c.imgStrList addObject:[imageDicJson objectForKey:@"imgUrlFull"]];
            }
        }
        
        return commodityArray;
    }
    else
    {
        return nil;
    }
}

//解析单个商品详情JSON
+ (Commodity *)readJsonStrToCommodityDetail:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *commodityJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( commodityJsonDic == nil || [commodityJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[commodityJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSDictionary *commodityDetailJson = [commodityJsonDic objectForKey:@"data"];
        Commodity *commodity = [RMMapper objectWithClass:[Commodity class] fromDictionary:commodityDetailJson];
        //将图片对象转图片数组
        commodity.imgStrList = [[NSMutableArray alloc] init];
        for (int i = 0; i < [commodity.imgList count]; i++) {
            NSDictionary *imageDicJson = [commodity.imgList objectAtIndex:i];
            [commodity.imgStrList addObject:[imageDicJson objectForKey:@"imgUrlFull"]];
        }
        
        //转化商品属性
        commodity.properyStrList = [RMMapper mutableArrayOfClass:[CommodityPropery class] fromArrayOfDictionary:commodity.properyList];
        for (CommodityPropery *p in commodity.properyStrList) {
            p.valueNameList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [p.valueList count]; i++) {
                NSDictionary *valueDicJson = [p.valueList objectAtIndex:i];
                [p.valueNameList addObject:[valueDicJson objectForKey:@"properyValueName"]];
            }
        }
        //        for (int i = 0; i < [commodity.properyStrList count]; i++) {
        //            NSDictionary valueDicJson = [commodity.imgList objectAtIndex:i];
        //            [commodity.imgStrList addObject:[valueDicJson objectForKey:@"imgUrlFull"]];
        //        }
        return commodity;
    }
    else
    {
        return nil;
    }
}

//解析账单列表JSON
+ (NSMutableArray *)readJsonStrToBillArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *billJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( billJsonDic == nil || [billJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[billJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *billArrayJson = [[billJsonDic objectForKey:@"data"] objectForKey:@"resultsList"];
        NSMutableArray *billArray = [RMMapper mutableArrayOfClass:[Bill class] fromArrayOfDictionary:billArrayJson];
        return billArray;
    }
    else
    {
        return nil;
    }
}

//解析积分列表JSON
+ (NSMutableArray *)readJsonStrToIntegralArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *integralJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( integralJsonDic == nil || [integralJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[integralJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *integralArrayJson = [[integralJsonDic objectForKey:@"data"] objectForKey:@"resultsList"];
        NSMutableArray *integralArray = [RMMapper mutableArrayOfClass:[Integral class] fromArrayOfDictionary:integralArrayJson];
        for (Integral *i in integralArray) {
            i.starttime = [self TimestampToDateStr:[i.starttimeStamp stringValue] andFormatterStr:@"yyyy年MM月dd日 HH:mm"];
        }
        return integralArray;
    }
    else
    {
        return nil;
    }
}

//解析周边商家JSON
+ (NSMutableArray *)readJsonStrToPeripheralShopArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *shopJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( shopJsonDic == nil || [shopJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[shopJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *shopArrayJson = [shopJsonDic objectForKey:@"data"];
        NSMutableArray *shopArray = [RMMapper mutableArrayOfClass:[PeripheralShop class] fromArrayOfDictionary:shopArrayJson];
        return shopArray;
    }
    else
    {
        return nil;
    }
}

//解析活动用户JSON
+ (NSMutableArray *)readJsonStrToActivityUsersArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *usersJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( usersJsonDic == nil || [usersJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[usersJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *usersArrayJson = [[usersJsonDic objectForKey:@"data"] objectForKey:@"resultsList"];
        NSMutableArray *usersArray = [RMMapper mutableArrayOfClass:[UserInfo class] fromArrayOfDictionary:usersArrayJson];
        return usersArray;
    }
    else
    {
        return nil;
    }
}

//解析订单列表JSON
+ (NSMutableArray *)readJsonStrToOrderArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *orderJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( orderJsonDic == nil || [orderJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[orderJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *orderArrayJson = [[orderJsonDic objectForKey:@"data"] objectForKey:@"resultsList"];
        NSMutableArray *orderArray = [RMMapper mutableArrayOfClass:[MyOrder class] fromArrayOfDictionary:orderArrayJson];
        for (MyOrder *order in orderArray) {
            order.commodityObjectList = [RMMapper mutableArrayOfClass:[MyOrderCommodity class] fromArrayOfDictionary:order.commodityList];
        }
        return orderArray;
    }
    else
    {
        return nil;
    }
}
//解析朋友圈列表JSON
+ (NSMutableArray *)readJsonStrToFriendsArray:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *classJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( classJsonDic == nil || [classJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[classJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES) {
        NSArray *classArrayJson = [[classJsonDic objectForKey:@"data"] objectForKey:@"resultsList"];
        NSMutableArray *classArray = [RMMapper mutableArrayOfClass:[FriendsList class] fromArrayOfDictionary:classArrayJson];
        for (FriendsList *fri in classArray)
        {
            NSMutableArray *imgList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [fri.imgList count]; i++)
            {
                NSDictionary *imageDicJson = [fri.imgList objectAtIndex:i];
                [imgList addObject:[RMMapper objectWithClass:[ImgList class] fromDictionary:imageDicJson]];
            }
            
            fri.contentHeight = [Tool getTextHeight:253 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12] andText:fri.content];
            fri.imgList = imgList;
        }
        return classArray;
    }
    else
    {
        return nil;
    }
}

+ (FriendsInfo *)readJsonStrToFriendsInfo:(NSString *)str
{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *classJsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if ( classJsonDic == nil || [classJsonDic count] <= 0) {
        return nil;
    }
    NSString *state = [[classJsonDic objectForKey:@"header"] objectForKey:@"state"];
    if ([state isEqualToString:@"0000"] == YES)
    {
        NSDictionary *infoJsonDic = [classJsonDic objectForKey:@"data"];
        FriendsInfo *friendsInfo = [RMMapper objectWithClass:[FriendsInfo class] fromDictionary:infoJsonDic];
        
        
        NSMutableArray *imgList = [[NSMutableArray alloc] init];
        for (int i = 0; i < [friendsInfo.imgList count]; i++)
        {
            NSDictionary *imageDicJson = [friendsInfo.imgList objectAtIndex:i];
            [imgList addObject:[RMMapper objectWithClass:[ImgList class] fromDictionary:imageDicJson]];
        }
        
        NSMutableArray *replyList = [[NSMutableArray alloc] init];
        for (int i = 0; i < [friendsInfo.replyList count]; i++)
        {
            NSDictionary *replyDicJson = [friendsInfo.replyList objectAtIndex:i];
            [replyList addObject:[RMMapper objectWithClass:[FriendsReply class] fromDictionary:replyDicJson]];
        }
        friendsInfo.contentHeight = [Tool getTextHeight:253 andUIFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12] andText:friendsInfo.content];
        friendsInfo.imgList = imgList;
        friendsInfo.replyList = replyList;
        return friendsInfo;
    }
    else
    {
        return nil;
    }
}

+ (NSString *)readOderSubmitVOToJson:(OderSubmitVO *)submit
{
    //    NSDictionary *orderDic = [self getObjectData:submit];
    NSData *jsonData = [self getJSON:submit options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonText;
}

+ (id) readJsonToObj:(NSString *)json andObjClass:(Class)objClass
{
    Jastor *obj = [[objClass alloc] initWithDictionary:[self dictionaryWithJsonString:json]];
    return obj;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
