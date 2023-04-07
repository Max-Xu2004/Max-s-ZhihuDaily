//
//  AppDelegate.m

//
//  Created by 许晋嘉 on 2023/4/1.
//

#import "AppDelegate.h"
#import "VC/ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = UIColor.whiteColor;
    ViewController *rootvc= [[ViewController alloc] init];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:rootvc];
    rootvc.navigationController.navigationBar.hidden = YES; //隐藏导航条，避免与上部按钮发生冲突及造成遮挡
    [self.window makeKeyAndVisible];
    return YES;
}



@end
