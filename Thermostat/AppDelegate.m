//
//  AppDelegate.m
//  Thermostat
//
//  Created by Keen on 2017/5/31.
//  Copyright © 2017年 GalaxyWind. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationPage.h"
#import "DeviceListPage.h"
#import "SideMenuPage.h"
#import <ViewDeck.h>

@interface AppDelegate ()

@property (nonatomic, strong) DeviceListPage *homePage;
@property (nonatomic, strong) SideMenuPage *menuPage;
@property (nonatomic, strong) IIViewDeckController *deckPage;

@end

@implementation AppDelegate

+ (AppDelegate *)instance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    // 首页
    self.homePage = [[DeviceListPage alloc] init];
    id navigationPage = [[BaseNavigationPage alloc] initWithRootViewController:self.homePage];

    // 菜单栏
    self.menuPage = [[SideMenuPage alloc] init];
    
    // 侧滑控件
    self.deckPage = [[IIViewDeckController alloc] initWithCenterViewController:navigationPage leftViewController:self.menuPage];
    
    
    self.window.rootViewController = self.deckPage;
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
