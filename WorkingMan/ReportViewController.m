//
//  ReportViewController.m
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import "ReportViewController.h"
#import "ImageHelper.h"
#import "RecieveViewController.h"
@interface ReportViewController ()

@end

@implementation ReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    JobsArray=[[NSMutableArray alloc]init];
    dbObj=[[Database alloc]init];
    
    
    myBarForPerhourRate.hidden=YES;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            [bckImge setFrame:CGRectMake(0, 0, 320, 480)];
        }
        if(result.height == 568)
        {
            [bckImge setFrame:CGRectMake(0, 0, 320, 568)];
        }
    }
    
  
	// Do any additional setup after loading the view.
}
-(IBAction)hidePopUp{

    [self resetFieldAndHideKeyboard];
    [popView setHidden:YES];

}

-(IBAction)viewReport{

    
    if([receiverAddress.text length]==0 || [receiverCity.text length]==0 || [receiverName.text length]==0 || [perHourRate.text length]==0 || [receiverAddress.text length]==0 || [receiverState.text length]==0 || [receiverZip.text length]==0)
    {
    
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"All fields are required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        
    
    }
    else{
        
            InvoiceInformation *info=[[InvoiceInformation alloc] init];
            info.RName=receiverName.text;
            info.RAddress=receiverAddress.text;
            info.PerHourRate=perHourRate.text;
            info.RCity=receiverCity.text;
            info.RState=receiverState.text;
            info.RZip=receiverZip.text;
        
            
           coll = [self.storyboard instantiateViewControllerWithIdentifier:@"Invoice"];
            coll.JobForInvoice=obj;
            coll.InvoiceInformationObject=info;
            
            
        
            [popView setHidden:YES];
            [self resetFieldAndHideKeyboard];
           
            
            [dbObj pickInsertInvoiceData:obj.JobId andRecName:info.RName andRecAddress:info.RAddress andPerHourRate:info.PerHourRate andCity:info.RCity andState:info.RState andZip:info.RZip];
            
        jbsign=[[JBSignatureController alloc]init];
        jbsign.delegate=self;
        [self.view addSubview:jbsign.view];
        
    
    }

    
}
-(void)resetFieldAndHideKeyboard{


    receiverAddress.text=@"";
    receiverName.text=@"";
    perHourRate.text=@"";
    
        receiverCity.text=@"";
        receiverState.text=@"";
        receiverZip.text=@"";
    
    
    [receiverAddress resignFirstResponder];
    [receiverCity resignFirstResponder];
    [receiverName resignFirstResponder];
    [perHourRate resignFirstResponder];
    
    [receiverCity resignFirstResponder];
    [receiverState resignFirstResponder];
    [receiverZip resignFirstResponder];


}

-(void)viewWillAppear:(BOOL)animated{
    
    if([JobsArray count]>0)
    {
        
        [JobsArray removeAllObjects];
    }
    JobsArray=[dbObj getCompletedJobList];
    [reportTable reloadData];
    
}

-(IBAction)EmailInvoice
{
    emailView.hidden = NO;
}
-(IBAction)PrintInvoice
{
    UIActionSheet * act = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Print via USB",@"Print via Bluetooth", nil];
    
    [act showInView:self.view];
    //[act showFromTabBar:self.tabBarController.tabBar];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		NSLog(@"a");
	}
	else if(buttonIndex == 1)
	{
		NSLog(@"b");
    }
    else
    {
        
    }
}
#pragma mark - *** JBSignatureControllerDelegate ***

/**
 * Example usage of signatureConfirmed:signatureController:
 * @author Jesse Bunch
 **/
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(JBSignatureController *)sender {
	
	// get image and close signature controller
	
    //	// I replaced the view just to show it works...
    //	UIImageView *imageview = [[UIImageView alloc] initWithImage:signatureImage];
    //	[imageview setContentMode:UIViewContentModeCenter];
    //	[imageview sizeToFit];
    //	[imageview setTransform:sender.view.transform];
    //	sender.view = imageview;
	
    
    signatureImage=[ImageHelper image:signatureImage fitInSize:CGSizeMake(250, 100)];
	// Example saving the image in the app's application support directory
	NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
    
	[UIImagePNGRepresentation(signatureImage) writeToFile:[appSupportPath stringByAppendingPathComponent:@"signature.png"] atomically:YES];
	
    
    NSLog(@"path %@",[appSupportPath stringByAppendingPathComponent:@"signature.png"]);
    [jbsign clearSignature ];
    [jbsign.view removeFromSuperview];
    [self.navigationController pushViewController:coll animated:YES];
    
    
	
}

/**
 * Example usage of signatureCancelled:
 * @author Jesse Bunch
 **/
-(void)signatureCancelled:(JBSignatureController *)sender {
	
	// close signature controller
	
	// Clear the sig for now
	[sender clearSignature];
	
}


#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([JobsArray count]>0) {
        return  [JobsArray count];
        
    }
    else
        return 0;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSString *rid;
    rid = [NSString stringWithFormat: @"%d%d%@",indexPath.row,indexPath.section,JobsArray] ;
    
    UITableViewCell *cell ;
    JobCell *InvCell=(JobCell*)[tableView dequeueReusableCellWithIdentifier:rid];
    
    
    if (InvCell == nil) {
        InvCell = [[JobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid] ;
    }
    [InvCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [InvCell setBackgroundColor:[UIColor clearColor]];
    
    
    Job *obj_=[JobsArray objectAtIndex:indexPath.row];
    InvCell.lblName.text=obj_.Jobname;
    InvCell.lblStatus.text=obj_.Status;
    
    cell=InvCell;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    obj=[JobsArray objectAtIndex:indexPath.row];
    
    NSMutableDictionary *getDatafromDic = [dbObj pickInsertInvoiceData:obj.JobId];
    /*
    receiverName.text = [getDatafromDic valueForKey:@"receiverName"];
    receiverAddress.text = [getDatafromDic valueForKey:@"receiverAddress"];
    perHourRate.text = [getDatafromDic valueForKey:@"PerHourRate"];
    
    receiverCity.text = [getDatafromDic valueForKey:@"city"];
    receiverState.text = [getDatafromDic valueForKey:@"state"];
    receiverZip.text = [getDatafromDic valueForKey:@"zip"];
    

    [popView setHidden:NO];
     */
    
    RecieveViewController *coll3 = [self.storyboard instantiateViewControllerWithIdentifier:@"ReViewCon"];
    coll3.obj=obj;
    coll3.getDatafromDic = getDatafromDic;
    
    Job *obj2=[JobsArray objectAtIndex:indexPath.row];
    coll3.getName =obj2.Jobname;
    coll3.getDesc =obj2.JobDesc;

    [self.navigationController pushViewController:coll3 animated:YES];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField isEqual:perHourRate]){
        myBarForPerhourRate.hidden=NO;
        [perHourRate becomeFirstResponder];
	}
        if(   [textField isEqual:receiverCity]
           || [textField isEqual:receiverState]
           || [textField isEqual:receiverZip])
        {
    	[scroll setContentOffset:CGPointMake(0,60) animated:YES];
        }
        else
        {
            [scroll setContentOffset:CGPointMake(0,0) animated:YES];
        }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:receiverName]){
        [receiverAddress becomeFirstResponder];
        
	}
    if([textField isEqual:receiverAddress]){
        myBarForPerhourRate.hidden=NO;
        [perHourRate becomeFirstResponder];
	}
    
    if([textField isEqual:receiverCity]){
        [receiverState becomeFirstResponder];
	}
    
    if([textField isEqual:receiverState]){
        [receiverZip becomeFirstResponder];
	}

    if([textField isEqual:receiverZip]){
        [receiverZip resignFirstResponder];
        [scroll setContentOffset:CGPointMake(0,0) animated:YES];
	}
    
   	return NO;
}


-(IBAction)toolBarDone
{
        myBarForPerhourRate.hidden = YES;
        [perHourRate resignFirstResponder];
        [receiverCity becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
