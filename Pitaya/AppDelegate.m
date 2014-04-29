//
//  AppDelegate.m
//  Pitaya
//
//  Created by 魏哲 on 14-1-20.
//  Copyright (c) 2014年 Guoku. All rights reserved.
//

#import "AppDelegate.h"
#import "SinaWeibo.h"

int ddLogLevel;

@implementation AppDelegate

#pragma mark - Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configLog];
    
    [self configCustomAppearance];
    
    _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.windowLevel = 100;
    UIViewController *vc = [[UIViewController alloc] init];
    self.alertWindow.rootViewController = vc;
    
    [GKDataManager getAllCategoryFromNetwork:YES result:nil];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.absoluteString hasPrefix:@"sinaweibosso"]) {
        SinaWeibo *weibo = [Passport sharedInstance].weiboInstance;
        return [weibo handleOpenURL:url];
    }
    
    return NO;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    SinaWeibo *weibo = [Passport sharedInstance].weiboInstance;
    weibo.userID = [Passport sharedInstance].sinaUserID;
    weibo.accessToken = [Passport sharedInstance].sinaToken;
    weibo.expirationDate = [Passport sharedInstance].sinaExpirationDate;
    [weibo applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private Method

- (void)configLog
{
    ddLogLevel = LOG_LEVEL_VERBOSE;
    
    // 控制台输出
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDTTYLogger sharedInstance].colorsEnabled = YES;
    // 设备输出
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    // 文件输出
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}

- (void)configCustomAppearance
{
    UIColor *navigationBarBackgroundColor = [UIColor clearColor];
    UIImage *navigationBarBackButtonImage = [UIImage imageNamed:@"nav_back_btn"];
    UIFont *navigationBarTitleFont = [UIFont appFontWithSize:20.f];
    UIColor *navigationBarTitleColor = UIColorFromRGB(0x555555);
    UIColor *navigationBarTitleShadowColor = [UIColor clearColor];
    CGFloat navigationBarTitleShadowOffset = 0.f;
    
    if (iOS7) {
        [UINavigationBar appearance].barTintColor = navigationBarBackgroundColor;
        [UINavigationBar appearance].backIndicatorImage = navigationBarBackButtonImage;
        [UINavigationBar appearance].backIndicatorTransitionMaskImage = navigationBarBackButtonImage;
    } else {
        [UINavigationBar appearance].tintColor = navigationBarBackgroundColor;
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        [UINavigationBar appearance].shadowImage = [UIImage imageWithColor:UIColorFromRGB(0xE9E9E9)];
    }
    
    [UINavigationBar appearance].titleTextAttributes = @{
                                                         UITextAttributeFont             : navigationBarTitleFont,
                                                         UITextAttributeTextColor        : navigationBarTitleColor,
                                                         UITextAttributeTextShadowColor  : navigationBarTitleShadowColor,
                                                         UITextAttributeTextShadowOffset : @(navigationBarTitleShadowOffset),
                                                         };
}

@end
