//
//  InventoryViewController.h
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "InventoryClass.h"

@protocol fromShowCate<NSObject>

- (void)fromShowCateFunc:(InventoryClass*)selectedInventory;
@end

@interface ShowCateAndSubCate : UIViewController
{
    
    Database *db_obj;
    NSMutableArray *InventoryArray;
    IBOutlet UITableView *inventoryTable;
    NSMutableArray *catarray;
    NSMutableDictionary *dict;
    NSMutableArray *array;
    id<fromShowCate> delegate;
    BOOL isCalledFromJob;
    IBOutlet UIButton *addbtn,*searchCsvBtn;
    IBOutlet UIImageView *bgImg;
    
    IBOutlet UIButton *bckButtonFromJobs;
    
    IBOutlet UIImageView *bckImge;
    NSString *catValue,*SubCatValue;
    IBOutlet UIButton *bckButtonFromInventory;
    
}

-(IBAction)SearchInv;
-(IBAction)Edit_Inventory:(id)sender;
-(IBAction)DismissFunction;
@property(nonatomic,retain)   id<fromShowCate> delegate;
@property(nonatomic,assign) BOOL isCalledFromJob;
@property(nonatomic,retain) NSString *catValue,*SubCatValue;
@end



