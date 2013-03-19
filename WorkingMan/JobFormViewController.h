//
//  JobFormViewController.h
//  WorkingMan
//
//  Created by Ali Naveed on 1/13/13.
//  Copyright (c) 2013 Umer Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "AppDelegate.h"
#import "Helper.h"

@interface JobFormViewController : UIViewController
{

       IBOutlet UITextField *jobNamefield;
       IBOutlet UITextView *jobDesc;
       IBOutlet UIToolbar *bar;
       Database *dbObj;
    
        AppDelegate *appDelegate;
    NSDateFormatter *formatter;
    
    IBOutlet UIImageView *bckImge;

}
-(IBAction)hideBar;
-(IBAction)startjob;
@end
