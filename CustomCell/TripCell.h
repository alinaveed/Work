//
//  TripCell.h
//  MyTalk
//
//  Created by macbook on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface TripCell : UITableViewCell {
	
	IBOutlet UIView			*subview;
    IBOutlet UILabel *lblName,*lblPrice,*lblQuantity;
   
    
}


@property(nonatomic,retain)  IBOutlet UILabel *lblName,*lblPrice,*lblQuantity,*lblCategory;




@end
