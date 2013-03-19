//
//  CustomButton.h
//  BackToGrass
//
//  Created by Soulzer's Mac on 11/20/11.
//  Copyright 2011 Laptop Zone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomButton : UIButton {
    int section;
    int indexPath;
}
@property (nonatomic, assign) int section;
@property (nonatomic, assign) int indexPath;
@end
