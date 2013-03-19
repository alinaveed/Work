//
//  JobCell.h
//  MyTalk
//
//  Created by Samson Peter on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JobCell.h"



@implementation JobCell

@synthesize lblName,lblStatus;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		[[NSBundle mainBundle] loadNibNamed:@"JobCell" owner:self options:nil];
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
