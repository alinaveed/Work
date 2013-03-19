//
//  AppDelegate.m
//  WorkingMan
//
//  Created by Umer Khan on 12/11/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import "AppDelegate.h"
#import "Database.h"

#include <sys/types.h>
#include <sys/sysctl.h>

@implementation AppDelegate
@synthesize IsJobInProgress;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    Database *db_obj=[[Database alloc]init];
    if( [db_obj CopyDatabaseIfNeeded])
    {
        
        NSLog(@"db hai");
              
    }
    else{
        NSLog(@"db  naheeee   hai");
        
    }
    IsJobInProgress=@"0";

    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isJobInProgress"];
    [defaults synchronize];
//    [self duntion];

  
    // Override point for customization after application launch.
    return YES;
}


//-(void)duntion
//{
//    
//    NSArray *array=[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:12.01],[NSNumber numberWithFloat:13.01],[NSNumber numberWithFloat:10.01],[NSNumber numberWithFloat:2.01],[NSNumber numberWithFloat:1.5],nil];
//    NSArray *sorted = [array sortedArrayUsingSelector:@selector(compare:)];
//    NSLog(@" sortedArray  %@",sorted);

//NSMutableArray *maxValueArray = [NSMutableArray array];
//       for (int i =0 ; i <[visits count]; i++) {
//               NSDictionary *data = [visits objectAtIndex:i];
//               [maxValueArray addObject:[NSNumber numberWithFloat: [[data stringForKey:@"Ammount"] floatValue]]] ;
//           }
//
//       NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
//       NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
//       NSArray *sortedArray = [maxValueArray sortedArrayUsingDescriptors:sortDescriptors];
//
//}
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
+ (BOOL)validateEmail:(NSString *)email {
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


 
- (void) MyiosDetails{
 
    NSLog(@"uniqueIdentifier: %@", [[UIDevice currentDevice] uniqueIdentifier]);
    NSLog(@"name: %@", [[UIDevice currentDevice] name]);
    NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);
    NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
    NSLog(@"model: %@", [[UIDevice currentDevice] model]);
    NSLog(@"localizedModel: %@", [[UIDevice currentDevice] localizedModel]);
}



@end
