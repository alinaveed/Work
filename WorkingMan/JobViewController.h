//
//  JobViewController.h
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "Job.h"
#import "JobCell.h"
#import "AppDelegate.h"
#import "Helper.h"
#import "JBSignatureController.h"
#import "InvoiceViewController.h"
#import "NSFileManager+DirectoryLocations.h"
#import "ImageHelper.h"

@interface JobViewController : UIViewController<UITextFieldDelegate,JBSignatureControllerDelegate>
{
    
    IBOutlet UITableView *jobsTable;
    NSMutableArray *jobsArray;
    Database *dbObj;
    
    AppDelegate *appDelegate;
    
    IBOutlet UIView *popView;
    IBOutlet UIScrollView *scroll;
    Job *obj_;
    
    IBOutlet UITextField *receiverName,*receiverAddress,*receiverCity,*perHourRate,*receiverState,*receiverZip;
    IBOutlet UIImageView *bckImge;
    JBSignatureController *jbsign;
    InvoiceViewController *coll;

    
    IBOutlet UIToolbar *myBarForPerhourRate;

    
}
-(IBAction)IncompleteJob;
-(IBAction)EndJob;

-(IBAction)hidePopUp;
-(IBAction)viewReport;


@end
