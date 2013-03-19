//
//  HelpViewController.h
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MFMailComposeViewController.h>



@interface HelpViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet UIImageView *bckImge;

}
-(IBAction)EmailInvoice;
@end
