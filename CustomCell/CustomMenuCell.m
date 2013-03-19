//
//  CustomMenuCell.m
//  MyTalk
//
//  Created by Adeel on 10/26/12.
//
//

#import "CustomMenuCell.h"

@implementation CustomMenuCell

@synthesize editBtn,lblName,lblPrice,lblQuantity;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCategoryName:(NSString *)_name {
    


}

@end
