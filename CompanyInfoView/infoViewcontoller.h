//
//  infoViewcontoller.h
//  invoiveBuddy
//
//  Created by imranhashmi on 1/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface infoViewcontoller : UIViewController
{
    IBOutlet UITabBarController *mytab;
    IBOutlet UITableView *table;
    IBOutlet UIScrollView *scroll_view;

    AppDelegate *appDelegate;
    NSUserDefaults *defaults;
    IBOutlet UITextField *name,*address;
    IBOutlet UITextField *city,*state,*zip;
}
-(IBAction)hide;
-(void)inser_into_db;
@end
