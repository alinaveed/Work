//
//  Company.h
//  invoiveBuddy
//
//  Created by Muneeba on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject{


    NSString *name,*add1,*add2,*country,*phone,*cell,*fax,*email,*tax,*tax_abbrev;

}
@property(nonatomic,retain)NSString *name,*add1,*add2,*country,*phone,*cell,*fax,*email,*tax,*tax_abbrev;

@end
