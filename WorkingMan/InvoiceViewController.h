//
//  InvoiceViewController.h
//  WorkingMan
//
//  Created by Umer Khan on 12/13/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Job.h"
#import "Database.h"
#import "PartCell.h"
#import "TripCell.h"
#import "InvoiceInformation.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PDFImageConverter.h"
#import "PRKGeneratorDataSource.h"
#import "PRKGeneratorDelegate.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"


@interface InvoiceViewController : UIViewController<UITextFieldDelegate,MFMailComposeViewControllerDelegate,UIPrintInteractionControllerDelegate,UIAlertViewDelegate,PRKGeneratorDataSource, PRKGeneratorDelegate>
{
    IBOutlet UIScrollView *myScroll;
    
    Job *JobForInvoice;
    
    IBOutlet UILabel *jobName,*jobHours,*jobStartDate;
     IBOutlet UITableView *partsTable,*tripsTable;
    
    NSMutableArray *partsArray,*tripsArray;
    Database *dbObj;
    IBOutlet UILabel *total;
    NSMutableDictionary *invoice_dict;
    
    NSDateFormatter *formatter;
    UIImage *received_image;

    IBOutlet UIImageView *bckImge;
    
    IBOutlet UIImageView *containerimageView;
    IBOutlet UIView *viewForcontainerimageView;
    
    IBOutlet UIImageView *tripBackImage;
    IBOutlet UIView *viewFortripBackImage;
    
    IBOutlet UILabel *Partlbl;
    IBOutlet UIView *viewForbuttonAndLabel;
    
    UITextField *textField;
    UITextField *textField2;
    
    NSString *saveSection;
    NSString *saveIndex;

    NSDictionary * defaultValues;
    IBOutlet UIImageView *mash;
    NSMutableArray * PartArrayForPdf;
    
    NSMutableArray * tripsArrayforPdf;
    UIWebView *webView;
    
    NSString *myJobName;
}
@property(nonatomic,strong) UIWebView *webView;

-(IBAction)EmailInvoice;
-(IBAction)PrintInvoice;
-(IBAction)GeneratePdf;
@property(nonatomic,strong)  Job *JobForInvoice;
@property(nonatomic,strong)  InvoiceInformation *InvoiceInformationObject;
-(IBAction)AddBuy_Price:(CustomButton*)sender;
-(IBAction) showActionSheet:(id)sender forEvent:(UIEvent*)event;
-(IBAction)BackButton;

@end
