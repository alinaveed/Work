//
//  PickupViewController.h


#import <UIKit/UIKit.h>
#import "Database.h"

@interface PickupViewController : UIViewController<UITextFieldDelegate>
{
    
    Database *db_obj;
    NSMutableArray *InventoryArray;
    IBOutlet UITableView *inventoryTable;
    NSMutableArray *catarray;
    NSMutableDictionary *dict;
    NSMutableArray *array;
    
    
    UITextField *textField;
    UITextField *textField2;

    
    NSMutableArray *buyValueArrayChild;
    NSMutableArray *buyValueArrayParent;
    
    
    NSString *saveSection;
    NSString *saveIndex;
    
    IBOutlet UIImageView *bckImge;
    
    IBOutlet UIButton *upDateBtn;

}
-(IBAction)SearchInv;
-(IBAction)AddBuy_Price:(UIButton*)sender;
@end

