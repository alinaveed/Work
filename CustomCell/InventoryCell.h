//
//  InventoryCell.h
//  MyTalk
//
//  Created by Samson Peter on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"



@interface InventoryCell : UITableViewCell {
	
	IBOutlet UIView			*subview;
    IBOutlet UILabel *lblName,*lblPrice,*lblQuantity,*lblCategory,*remainingQuantity;
    IBOutlet CustomButton *editBtn;
    
}


@property(nonatomic,retain)  IBOutlet UILabel *lblName,*lblPrice,*lblQuantity,*lblCategory,*remainingQuantity;
@property(nonatomic,retain)  IBOutlet CustomButton *editBtn;



@end
