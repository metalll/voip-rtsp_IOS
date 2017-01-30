//
//  AppDelegate.m
//  kxmovieapp
//
//  Created by Kolyvan on 11.10.12.
//  Copyright (c) 2012 Konstantin Boukreev . All rights reserved.
//
//  https://github.com/kolyvan/kxmovie
//  this file is part of KxMovie
//  KxMovie is licenced under the LGPL v3, see lgpl-3.0.txt

#import "AppDelegate.h"
#import "MainViewController.h"
#import "../Gossip/PJSIP.h"
#import "../Gossip/Gossip.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    UIViewController *vc = [[MainViewController alloc] init];
//    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
//
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = navVc;
//    [self.window makeKeyAndVisible];
//
//    LoggerApp(1, @"Application didFinishLaunchingWithOptions");

    return YES;
}

- (void)keepAlive {
    if (!pj_thread_is_registered()) {
        static pj_thread_desc   thread_desc;
        static pj_thread_t     *thread;
        pj_thread_register("ipjsua", thread_desc, &thread);
    }
    pjsua_acc_set_registration(0, PJ_TRUE);
    NSLog(@"Keep Alive");
}



-(void)account:(GSAccount *)account didReceiveIncomingCall:(GSCall *)call{
    NSLog(@"incoming call");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /* Send keep alive manually at the beginning of background */
    
    
    [self performSelectorOnMainThread:@selector(keepAlive) withObject:nil waitUntilDone:YES];
    
    /* iOS requires that the minimum keep alive interval is 600s */
    [application setKeepAliveTimeout:600 handler: ^{
        [self performSelectorOnMainThread:@selector(keepAlive)
                               withObject:nil waitUntilDone:YES];
    }];

}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
