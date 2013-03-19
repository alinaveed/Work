//
//  AddInventoryViewController.h
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryClass.h"

@interface AddInventoryViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{

    IBOutlet UITextField *nameField,*quantityField,*priceField,*maintenanceField,*markUpValue;
    InventoryClass *Inventory_ToEdit;
    BOOL isEdit;
    IBOutlet UIPickerView *picker;
    IBOutlet UIToolbar *bar;
    NSString *selectedCategory,*selectedSubCategory,*IDselectedCategory;
    NSMutableArray *pickerArray;
    
    IBOutlet UIButton *catBtn,*subCatBtn;
    UITextField *CattextField;
    
    
    IBOutlet UIBarButtonItem *mySelectCatbtn;
    
    BOOL forcatAndSubcategory;
    int moveHeight;
    BOOL isViewUp;
    IBOutlet UIScrollView *scroll;
    
    NSMutableArray *pickerArrayForSubCategories;
    
    IBOutlet UIButton *UpdatenSavebtn;
    
    IBOutlet UIImageView *bckImge;

    IBOutlet UIToolbar *barForMakupButton;

}
@property(nonatomic,assign) BOOL isEdit;
@property(nonatomic,retain)  InventoryClass *Inventory_ToEdit;
-(id)initWithInventoryObject:(InventoryClass*)inventoryObj;
-(IBAction)saveToDB;
-(IBAction)buttonClicked:(UIButton*)sender;
-(IBAction)hidepicker:(id)sender;

-(IBAction)hidemarkUpKeyboard;

@end
