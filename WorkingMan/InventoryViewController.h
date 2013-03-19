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
#import "ShowCateAndSubCate.h"


@protocol InventorySelection<NSObject>

- (void)InventoryDidSelect:(InventoryClass*)selectedInventory;
@end

@interface InventoryViewController : UIViewController<fromShowCate>
{
    
    Database *db_obj;
    NSMutableArray *InventoryArray;
    IBOutlet UITableView *inventoryTable;
    NSMutableArray *catarray;
    NSMutableDictionary *dict;
    NSMutableArray *array;

    BOOL isCalledFromJob;
    IBOutlet UIButton *addbtn,*searchCsvBtn;
    IBOutlet UIImageView *bgImg;
    
    IBOutlet UIButton *bckButtonFromJobs;
    
    IBOutlet UIImageView *bckImge;
    
    
    /**/
    
    id<InventorySelection> delegate;
    

}

-(IBAction)SearchInv;
-(IBAction)Edit_Inventory:(id)sender;
-(IBAction)DismissFunction;
@property(nonatomic,assign) BOOL isCalledFromJob;

@property(nonatomic,retain)   id<InventorySelection> delegate;
@end
