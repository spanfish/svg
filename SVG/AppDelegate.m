//
//  AppDelegate.m
//  SVG
//
//  Created by xiangwei wang on 10/17/16.
//  Copyright © 2016 xiangwei wang. All rights reserved.
//

#import "AppDelegate.h"
#import <InMobiSDK/InMobiSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IMSdk initWithAccountID:@"7a16cd61264446cf98e43bbebd7c61ac"];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"didFinishLaunchingWithOptions"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"imagetag-layer2-sun" ofType:@"svg"];
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:[documentPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        
        path = [[NSBundle mainBundle] pathForResource:@"Lion" ofType:@"svg"];
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:[documentPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        
        path = [[NSBundle mainBundle] pathForResource:@"NewTux" ofType:@"svg"];
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:[documentPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        
        path = [[NSBundle mainBundle] pathForResource:@"Cycling_Lambie" ofType:@"svg"];
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:[documentPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"didFinishLaunchingWithOptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
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

-(BOOL) adEnabled {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    
    // 年月日をとりだす
    comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth| NSCalendarUnitDay)
                        fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    if(year >= 2016 && month >= 10 && day >= 21) {
        return YES;
    } else {
        return NO;
    }
}
@end
