//
//  TagCellWithField.m
//  ThreadShare
//
//  Created by iMac on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TagCellWithField.h"

@implementation TagCellWithField
@synthesize captionLabel, valueField, bgView ;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self awakeFromNib];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib {
    [super awakeFromNib];
    valueField.delegate = self ;
    valueField.returnKeyType = UIReturnKeyDone ;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO ;
}

@end
