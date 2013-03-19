//
//  CustomMenuCell.h
//  MyTalk
//
//  Created by Adeel on 10/26/12.
//
//

#import <UIKit/UIKit.h>




@interface CustomMenuCell : UITableViewCell
{
    IBOutlet UIImageView *placeholder;
    IBOutlet UILabel *lblName,*lblQuantity,*lblPrice;
     IBOutlet UIButton *editBtn;

}
@property(nonatomic,retain)  IBOutlet UIButton *editBtn;
@property (nonatomic, retain) IBOutlet UIImageView *cellImage;

@property (nonatomic, retain)     IBOutlet UILabel *lblName,*lblQuantity,*lblPrice;
@property (nonatomic, retain)     IBOutlet UIImageView *placeholder;
-(void) setBadgeNumber:(NSInteger)number;

@end
