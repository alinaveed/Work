//
//  HomeViewController.h
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Helper.h"
@interface HomeViewController : UIViewController
{
    IBOutlet UINavigationBar *navBar;
    AppDelegate *appdelegate;
    IBOutlet UIImageView *bckImge;

}
-(IBAction)job;
-(IBAction)report;
-(IBAction)inventory;
-(IBAction)pickup;
-(IBAction)help;
@end
