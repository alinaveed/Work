//
//  InventoryCell.m
//  MyTalk
//
//  Created by Samson Peter on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PickupCell.h"



@implementation PickupCell

@synthesize lblName,lblCategory,lblPrice,lblQuantity;
@synthesize pricebtn;
@synthesize buybtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		[[NSBundle mainBundle] loadNibNamed:@"PickupCell" owner:self options:nil];
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
}

@end
