//
//  ReportViewController.h
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobCell.h"
#import "Job.h"
#import "Database.h"
#import "InvoiceViewController.h"
#import "AppDelegate.h"
#import "InvoiceInformation.h"
#import "JBSignatureController.h"
#import "NSFileManager+DirectoryLocations.h"

@interface ReportViewController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate,JBSignatureControllerDelegate>
{
    IBOutlet UITableView *reportTable;
    IBOutlet UIView *emailView, *PdfView;
    NSMutableArray *JobsArray;
    
    Database *dbObj;
    IBOutlet UIView *popView;
    IBOutlet UIScrollView *scroll;
    Job *obj;
    
    IBOutlet UITextField *receiverName,*receiverAddress,*receiverCity,*perHourRate,*receiverState,*receiverZip;
    IBOutlet UIImageView *bckImge;
    
    IBOutlet UIToolbar *myBarForPerhourRate;
    JBSignatureController *jbsign;
    InvoiceViewController *coll;

}
//popup work
-(IBAction)hidePopUp;
-(IBAction)viewReport;


-(IBAction)EmailInvoice;
-(IBAction)PrintInvoice;
-(IBAction)GeneratePdf;
-(IBAction)CancelEmail;
-(IBAction)CancelPDF;

@end
