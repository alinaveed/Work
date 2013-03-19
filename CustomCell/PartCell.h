//
//  PartCell.h
//  MyTalk
//
//  Created by Samson Peter on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"



@interface PartCell : UITableViewCell {
	
	IBOutlet UIView			*subview;
    IBOutlet UILabel *lblName,*lblPrice,*lblQuantity;
 
    IBOutlet CustomButton *EditQuantity;
    
}


@property(nonatomic,retain)  IBOutlet CustomButton *EditQuantity;

@property(nonatomic,retain)  IBOutlet UILabel *lblName,*lblPrice,*lblQuantity,*lblCategory;




@end
