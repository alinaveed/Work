//
//  InventoryClass.h
//  WorkingMan
//
//  Created by Ali Naveed on 1/12/13.
//  Copyright (c) 2013 Umer Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InventoryClass : NSObject


@property(nonatomic,retain)NSString *Name,*Quantity,*Price,*Category,*SubCategory,*Inv_Id,*maintenanceLevel,*remainingQuantity,*MarkUp;
@property(nonatomic,assign)int Id;
@end
