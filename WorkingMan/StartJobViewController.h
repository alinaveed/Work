//
//  StartJobViewController.h
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartCell.h"
#import "Database.h"
#import "InventoryViewController.h"
#import "InventoryClass.h"
#import "Trip.h"
#import "AppDelegate.h"
#import "ShowCateAndSubCate.h"
@interface StartJobViewController : UIViewController<InventorySelection,UITextFieldDelegate>
{

    IBOutlet UITableView *partsTable,*tripsTable;
    NSMutableArray *partsArray;
    Database *dbObj;
    IBOutlet UILabel *lbl_hours,*lbl_mins,*lbl_sec;
    InventoryViewController *getInventlist;
    UINavigationController *nav;
    UITextField *quantityField;
    InventoryClass *pickedInventory;
    
    NSTimer *ClockTimer;
    int hours,mins,sec;
    int CurrentTrip;
    IBOutlet UIButton *pauseResumebtn;
    NSMutableArray *tripsArray;
    IBOutlet UIScrollView *scroll;
    NSString *currentTripName;
    BOOL isExistingObj;
    
    AppDelegate *appDelegate;
    IBOutlet UIButton *backbtn;
    
    NSDateFormatter  *formatter;
    
    
    //stretch image
    IBOutlet UIView *buttonView;
    
    IBOutlet UIImageView *containerimageView;
    IBOutlet UIView *viewForcontainerimageView;
    
    IBOutlet UIImageView *tripBackImage;
    IBOutlet UIView *viewFortripBackImage;
    
    IBOutlet UIImageView *bckImge;
    IBOutlet UILabel *tablenNameLabel,*tableQuantityLabel;
    
    
    IBOutlet UILabel *tripNameLabel,*tripVisitTimeLabel;

}

@property (nonatomic,assign)int currentJobId;
@property (nonatomic,assign)BOOL iscalledFromJob;
-(IBAction)addParts;
-(void)AddPartToDB:(NSString*)quantity;
-(IBAction)pauseResumeJob;
-(IBAction)EndJob;

-(void)resetTimer;
@end
