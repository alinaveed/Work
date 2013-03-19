//
//  InventoryCell.m
//  MyTalk
//
//  Created by Samson Peter on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InventoryCell.h"



@implementation InventoryCell

@synthesize lblName,lblCategory,lblPrice,lblQuantity,editBtn,remainingQuantity;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		[[NSBundle mainBundle] loadNibNamed:@"InventoryCell" owner:self options:nil];
		[self.contentView addSubview:subview];
		subview.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


/*
-(void) setNrOfMembers:(NSInteger)nrOfMembers
{
	lbl_nrOfMembers.text = [NSString stringWithFormat:@"%d %@", nrOfMembers, nrOfMembers == 1 ? @"Member" : @"Members"];
}
 */


@end
