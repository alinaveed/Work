//
//  SearchInventoryViewController.h
//  WorkingMan
//
//  Created by Umer Khan on 12/13/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchInventoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    IBOutlet UITableView *TableforCsvListinDocDirectory;
    NSMutableArray *jpegFiles;
    
    
    NSIndexPath *indxPath;
	int Index;
    
    IBOutlet UIImageView *bckImge;
    
    IBOutlet UIButton *upDateBtn;
    
}
-(IBAction)BackButton;
-(IBAction)InsertDataFromCSVtoDataBase;

@end

