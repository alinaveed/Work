//
//  AppDelegate.h
//  WorkingMan
//
//  Created by Umer Khan on 12/11/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{    NSString *IsJobInProgress;}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong)NSString *IsJobInProgress;
+ (BOOL)validateEmail:(NSString *)email;

@end
