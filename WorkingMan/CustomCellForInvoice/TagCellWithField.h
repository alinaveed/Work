//
//  TagCellWithField.h
//  ThreadShare
//
//  Created by iMac on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagCellWithField : UITableViewCell<UITextFieldDelegate> {
    IBOutlet UIImageView *bgView ;
    IBOutlet UILabel *captionLabel ;
    IBOutlet UITextField *valueField ;
}

@property(nonatomic, retain) UIImageView *bgView ;
@property(nonatomic, retain) UILabel *captionLabel ;
@property(nonatomic, retain) UITextField *valueField ;

@end
