//
//  RecieveViewController.h
//  WorkingMan
//
//  Created by AliNaveed on 3/5/13.
//  Copyright (c) 2013 Umer Khan. All rights reserved.
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
#import "ImageHelper.h"

@interface RecieveViewController : UIViewController<UITextFieldDelegate,JBSignatureControllerDelegate,UITableViewDataSource,UITableViewDataSource>
{
    IBOutlet UIScrollView *scroll;

    
    NSString *receiverName,*receiverAddress,*receiverCity,*perHourRate,*receiverState,*receiverZip;
    IBOutlet UIImageView *bckImge;
    IBOutlet UIToolbar *myBarForPerhourRate;

    JBSignatureController *jbsign;
    InvoiceViewController *coll;
    
    Database *dbObj;
    Job *obj;

    IBOutlet UIView *senderSign,*recSignature;

    NSMutableDictionary *getDatafromDic;
    NSMutableDictionary *getDataforSign;
    
    NSString *sendSign,*recSign;
    
    IBOutlet UIImageView *sendSignImage;
    IBOutlet UIImageView *sendRecImage;
    
    
    IBOutlet UIView *LoadView;
    
    NSOperationQueue *OperationQueue;
    
    
    int ValueUpDown;

    NSString*mystamp;
    
    NSString *senderImageName;
    NSString *recImageName;
    
    
    UIImage *forSender;
    UIImage *forReceiver;
    
    
    NSString *getName;
    NSString *getDesc;
    
    
    IBOutlet UITableView *myTableView;
    
    
    //----
    
    IBOutlet UIView *forJobName;
    IBOutlet UIView *forJobDesc;
    
    IBOutlet UIView *forJobSignature;
    
    IBOutlet UITextField *forjobNameField;
    IBOutlet UITextView *forjobNameDesc;
    
    
    NSArray *myRecInvoice;
    NSArray *mySenInvoice;
    
    NSMutableArray *cell1ForRec;
    NSMutableArray *cell1ForSen;
    
    IBOutlet UIButton *viewInvBtn;
    
}
@property(nonatomic,strong)  Job *obj;
@property(nonatomic,strong)  InvoiceInformation *InvoiceInformationObject;
@property(nonatomic,strong)    NSMutableDictionary *getDatafromDic;

@property(nonatomic,strong)NSString *getName;
@property(nonatomic,strong)NSString *getDesc;

-(IBAction)SenderSignFunction;
-(IBAction)ReciverSignFunction;
-(IBAction)toolBarDone;
-(IBAction)viewReport;
-(IBAction)BackButton;
- (void)uploadToImageShack:(NSString *)imgeName;
-(void)calltoNextClass;
@end
