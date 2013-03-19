//
//  CustomMenuCell.h
//  MyTalk
//
//  Created by Adeel on 10/26/12.
//
//
#import <UIKit/UIKit.h>
#import "CustomButton.h"



@interface PickupCell : UITableViewCell {
	
	IBOutlet UIView			*subview;
    IBOutlet UILabel *lblName,*lblPrice,*lblQuantity,*lblCategory;
    IBOutlet CustomButton *pricebtn;
    IBOutlet CustomButton *buybtn;
    
}


@property(nonatomic,retain)  IBOutlet UILabel *lblName,*lblPrice,*lblQuantity,*lblCategory;
@property(nonatomic,retain)  IBOutlet CustomButton *pricebtn;
@property(nonatomic,retain)  IBOutlet CustomButton *buybtn;

@end