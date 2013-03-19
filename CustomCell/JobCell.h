//
//  JobCell.h
//  MyTalk
//
//  Created by Samson Peter on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface JobCell : UITableViewCell {
	
	IBOutlet UIView			*subview;
    IBOutlet UILabel *lblName,*lblStatus;
   
    
}


@property(nonatomic,retain)  IBOutlet UILabel *lblName,*lblStatus;

@end
