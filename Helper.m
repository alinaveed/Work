//
//  Helper.m
//  WorkingMan
//
//  Created by Ali Naveed on 1/20/13.
//  Copyright (c) 2013 Umer Khan. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(void)ShowAlert{

  
   UIAlertView  *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"There is already a job running.End it First." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];


}

@end
