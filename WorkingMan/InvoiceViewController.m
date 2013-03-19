//
//  InvoiceViewController.m
//  WorkingMan
//
//  Created by Umer Khan on 12/13/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import "InvoiceViewController.h"
#import "PRKGenerator.h"
#import "PRKRenderHtmlOperation.h"
#import "InvoiceItem.h"
#import "Database.h"
#import "TSActionSheet.h"
@interface InvoiceViewController ()

@end

@implementation InvoiceViewController
@synthesize JobForInvoice,InvoiceInformationObject;
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
    myScroll.contentSize = CGSizeMake(320, 650);
	myScroll.showsHorizontalScrollIndicator=NO;
    
    partsArray=[[NSMutableArray alloc]init];
    tripsArray=[[NSMutableArray alloc]init];
    dbObj=[[Database alloc]init];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    partsArray=[dbObj get_parts_for_specificJob:[JobForInvoice.JobId intValue]];
    tripsArray=[dbObj get_triplist_for_specificJob:[JobForInvoice.JobId intValue]];

    
    jobName.text = JobForInvoice.Jobname;

    myJobName = JobForInvoice.Jobname;
    
    jobStartDate.text=JobForInvoice.startTime;
    jobHours.text=[NSString stringWithFormat:@"%.2f hour",[Job TotalHoursForJobs:JobForInvoice.JobId]/3600.0];
    
    
    [self CalculateTotal];
    
//    [self CreateInvoiceImage];
    
    
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
            
            [myScroll setFrame:CGRectMake(0, 94, 320, 445)];

        }
    }
    
    [self FunctionForResizetheTableViewButton];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self PdfPreview];
    
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(callKro) userInfo:nil repeats:NO];
    

	// Do any additional setup after loading the view.
}
-(void)callKro
{

    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 43, 320, 369)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.scalesPageToFit = YES; //this enables the zooming**
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[self DirectoryPath]]];
    [webView loadRequest:request];
    [self.view addSubview:webView];

}
-(IBAction)BackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)CreateInvoiceImage{

    
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"InvoiceTemplate"    ofType:@"plist"];
    
  NSMutableArray  *contentArray = (NSMutableArray*)[[NSDictionary dictionaryWithContentsOfFile:sourcePath] objectForKey:@"All Template"];
    
    
    
    invoice_dict=[[NSMutableDictionary alloc]initWithDictionary:[contentArray objectAtIndex:0]
                  ];
    
 
    
//    NSLog(@"invoice dict %@",invoice_dict);
//    received_image=[self someImageMethod];

    


}

-(NSArray*)seperateString:(NSString*)string{
    
    NSArray *array=[string componentsSeparatedByString:@","];
    return array;
    
}

-(void)CalculateTotal{


    float partTotal = 0.0,TripTotal=0.0,GrandTotal;
    
    partTotal=[Job PartsTotal:partsArray];
    TripTotal=[Job tripTotal:tripsArray andPerhourRate:[InvoiceInformationObject.PerHourRate floatValue]];
    
    GrandTotal=partTotal+TripTotal;
    [total setText:[NSString stringWithFormat:@"%.2f",GrandTotal]];
    
    

}


-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error : (NSError*)error {
    
    [self dismissModalViewControllerAnimated:YES];
    
}

-(IBAction)EmailInvoice{
    [self PdfPreview];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Subject Goes Here."];
        

        NSData*pdfData = [NSData dataWithContentsOfFile:[self DirectoryPath]];

//         NSData*pdfData = [PDFImageConverter convertImageToPDF: received_image
//                              withHorizontalResolution: 5000 verticalResolution: 5000];

           // NSData *imageData = UIImageJPEGRepresentation(received_image, 1);
        NSString *InvoiceName =[NSString stringWithFormat:@"%@.pdf",myJobName];

        [mailViewController addAttachmentData:pdfData mimeType:@"application/pdf" fileName:InvoiceName];
        [mailViewController setMessageBody:@"Message" isHTML:YES];
        
        
        [self presentModalViewController:mailViewController animated:YES];
        
    }
    
    else {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ALERT" message:@"Device isnot configured for email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
      
        
        NSLog(@"device cannot send email");
        
    }
}
-(IBAction)PrintInvoice{
    //convertImageToPDF
    
    [self PdfPreview];
     NSData*pdfData = [NSData dataWithContentsOfFile:[self DirectoryPath]];
//      NSData *imageData = pdfData;
//    
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",InvoiceInformationObject.RName]];
//
//    
//    NSError * error = nil;
//    [imageData writeToFile:[self DirectoryPath] options:NSDataWritingAtomic error:&error];
//    
//    if (error != nil)
//        NSLog(@"Error: %@", error);
//
    
    
    [self printInvoiceFunction:pdfData];

}
-(IBAction)GeneratePdf{
    [self PdfPreview];
//  NSData*pdfData = [NSData dataWithContentsOfFile:[self DirectoryPath]];
////    NSData *imageData = pdfData;
////    
////    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
////    
////    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",InvoiceInformationObject.RName]];
//    
//    NSError * error = nil;
//    [pdfData writeToFile:[self DirectoryPath] options:NSDataWritingAtomic error:&error];
//    
//    if (error != nil)
//        NSLog(@"Error: %@", error);

    [self AlertFunction:@"PDF Successfully Generated"];
    
}

-(void)AlertFunction:(NSString *)msg{
    
    NSString *errorFound = @"";
    NSString *Okbtn = @"OK";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:errorFound message:msg delegate:self cancelButtonTitle:Okbtn otherButtonTitles:nil];
    
    [alert show];
    
}

-(void)FunctionForResizetheTableViewButton{

    ///------------------------------TripStart
    float valueeeetrip=([tripsArray count]*40)+54;
    [tripsTable setFrame:CGRectMake(tripsTable.frame.origin.x, tripsTable.frame.origin.y, tripsTable.frame.size.width, valueeeetrip)];
    
    [viewFortripBackImage setFrame:CGRectMake(viewFortripBackImage.frame.origin.x, viewFortripBackImage.frame.origin.y, viewFortripBackImage.frame.size.width, valueeeetrip)];
    
    [Partlbl setFrame:CGRectMake(Partlbl.frame.origin.x, valueeeetrip+105, Partlbl.frame.size.width, Partlbl.frame.size.height)];
  
    ///------------------------------TripEnd
    ///------------------------------AddPartStart
    
    float valueeee=([partsArray count]*40)+54;
    
    if([tripsArray count]==0)
    {
        [partsTable setFrame:CGRectMake(partsTable.frame.origin.x, partsTable.frame.origin.y, partsTable.frame.size.width, 135)];
    }
    else
    {
        [partsTable setFrame:CGRectMake(partsTable.frame.origin.x, tripsTable.frame.origin.y, partsTable.frame.size.width, valueeee)];
        
    }
    [viewForcontainerimageView setFrame:CGRectMake(viewForcontainerimageView.frame.origin.x, viewFortripBackImage.frame.size.height+105+25, viewForcontainerimageView.frame.size.width, valueeee)];
    
    ///------------------------------AddPartEnd
    //Button And Label of Grand Totals
    
    float heightforscrollview = viewFortripBackImage.frame.size.height+ viewForcontainerimageView.frame.size.height+150;


    [viewForbuttonAndLabel setFrame:CGRectMake(viewForbuttonAndLabel.frame.origin.x, heightforscrollview, viewForbuttonAndLabel.frame.size.width, viewForbuttonAndLabel.frame.size.height)];
    heightforscrollview +=viewForbuttonAndLabel.frame.size.height;
    
    
    [myScroll setContentSize:CGSizeMake(320, heightforscrollview)];
    
    
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([partsArray count]>0)
    {
    }
    else{
        
    }
    if(tableView.tag==0)
        return [partsArray count];
    else if(tableView.tag==1)
        return [tripsArray count];
    else return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSString *rid;
    rid = [NSString stringWithFormat: @"%d%d%@",indexPath.row,indexPath.section,partsArray] ;
    
    UITableViewCell *cell ;

    if(tableView.tag==0)
    {
        PartCell*InvCell=(PartCell*)[tableView dequeueReusableCellWithIdentifier:rid];
        if (InvCell == nil) {
            InvCell = [[PartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid] ;
            
            [InvCell.lblName setFrame:CGRectMake(InvCell.lblName.frame.origin.x+15.0, InvCell.lblName.frame.origin.y, InvCell.lblName.frame.size.width, InvCell.lblName.frame.size.height)];
            
            [InvCell.lblQuantity setFrame:CGRectMake(InvCell.lblQuantity.frame.origin.x+15.0, InvCell.lblQuantity.frame.origin.y, InvCell.lblQuantity.frame.size.width, InvCell.lblQuantity.frame.size.height)];
        }
        
        [InvCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [InvCell setBackgroundColor:[UIColor clearColor]];
        
        Parts *obj=[partsArray objectAtIndex:indexPath.row];
        InvCell.lblName.text=obj.PartName;
        InvCell.lblQuantity.text=obj.Quantity;
        

        
        NSLog(@"part %@  job %@",[obj Id],[obj JobId]);
        
        InvCell.EditQuantity.indexPathvalues = indexPath;
        
        [InvCell.EditQuantity addTarget:self action:@selector(AddBuy_Price:) forControlEvents:UIControlEventTouchUpInside];

        [InvCell bringSubviewToFront:InvCell.EditQuantity];
        
        UIImageView *myimg2 = [[UIImageView alloc] initWithFrame:CGRectMake(128,15 , 15, 15)];
        [myimg2 setImage:[UIImage imageNamed:@"addbtn.png"]];
        [InvCell addSubview:myimg2];

        
        cell=InvCell;
    }
    else if(tableView.tag==1)
    {
        
        rid = [NSString stringWithFormat: @"%d%dabcedf",indexPath.row,indexPath.section] ;
        
        TripCell  *InvCell=(TripCell*)[tableView dequeueReusableCellWithIdentifier:rid];
        
        
        if (InvCell == nil) {
            InvCell = [[TripCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid] ;
        }
        
        //   [ InvCell.lblName setFrame:CGRectMake(InvCell.lblName.frame.origin.x+14.0, InvCell.lblName.frame.origin.y, InvCell.lblName.frame.size.width, InvCell.lblName.frame.size.height)];
        
        //  [ InvCell.lblQuantity setFrame:CGRectMake(InvCell.lblQuantity.frame.origin.x+7.0, InvCell.lblQuantity.frame.origin.y, InvCell.lblQuantity.frame.size.width, InvCell.lblQuantity.frame.size.height)];
        
        [InvCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [InvCell setBackgroundColor:[UIColor clearColor]];
        
        Trip *obj=[tripsArray objectAtIndex:indexPath.row];
        InvCell.lblName.text=obj.TripName;
        InvCell.lblQuantity.text=obj.startTime;
        
        
        cell=InvCell;
    }
    
    cell.backgroundColor  =[UIColor clearColor];
    tableView.separatorColor = [UIColor clearColor];
    
    return cell;
}


/**/
-(IBAction)AddBuy_Price:(CustomButton*)sender{
    
    
    CustomButton *btn = (CustomButton *)sender;
    NSIndexPath *getValue = btn.indexPathvalues;
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 63.0, 260.0, 25.0)];
    textField2 = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 103.0, 260.0, 25.0)];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField2.keyboardType = UIKeyboardTypeDecimalPad;
    
    saveSection = [NSString stringWithFormat:@"%d",getValue.section];
    saveIndex = [NSString stringWithFormat:@"%d",getValue.row];
    
    
    Parts *obj=[partsArray objectAtIndex:getValue.row];
    textField.text = obj.PartName;
    textField.enabled = NO;
    textField2.text = obj.Quantity;
    
    NSString *nameandEMail = @"Enter New Quantity ";
    NSString *Enterbtn = @"Done";
    NSString *Cancelbtn = @"Cancel";
    
    UIAlertView *prompt;
    
    
    prompt = [[UIAlertView alloc] initWithTitle:nameandEMail
                                        message:@"\n\n\n\n" // IMPORTANT
                                       delegate:nil
                              cancelButtonTitle:Enterbtn
                              otherButtonTitles:Cancelbtn, nil];
    
    prompt.tag = 8973;
    prompt.delegate = self;
    
    textField.tag = 6573;
    textField.delegate = self;
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setPlaceholder:@"Name"];
    
    [prompt addSubview:textField];
    
    textField2.tag = 6574;
    textField2.delegate = self;
    [textField2 setBackgroundColor:[UIColor whiteColor]];
    [textField2 setPlaceholder:@"Quantity"];
    [prompt addSubview:textField2];
    
    [prompt show];
    [textField2 becomeFirstResponder];
    
    
}

/**/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 8973) {
        if (buttonIndex == 0) {
            
            Parts *obj=[partsArray objectAtIndex:[saveIndex intValue]];
            obj.PartName =textField.text;
            obj.Quantity =textField2.text;
            
            

            [partsArray replaceObjectAtIndex:[saveIndex intValue] withObject:obj];
            [dbObj updatePartQuantity:[textField2 text] andPartID:[[obj PartId] intValue] andJobId:[[obj JobId] intValue]];
            
            [self CalculateTotal];
            [partsTable reloadData];
            
         
        }
        
        
        
    }
    
}

/**/
- (void) tableView: (UITableView *) tableView willDisplayCell: (UITableViewCell *) cell forRowAtIndexPath: (NSIndexPath *) indexPath{
    
    UIView * yourView ;
    UIImage * targetImage;
    
    if([partsArray count]>0 || [tripsArray count]>0)
    {
        
        // if ([cell tag] != 55555) {
        yourView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
        if(tableView.tag==0)
        {
            targetImage = [UIImage imageNamed:@"Middle.png"];
        }
        
        else if(tableView.tag==1)
        {
            targetImage = [UIImage imageNamed:@"trip-middle.png"];
            
        }
        
        UIGraphicsBeginImageContextWithOptions(yourView.frame.size, NO, 0.f);
        [targetImage drawInRect:CGRectMake(0.f, 0.f, yourView.frame.size.width, yourView.frame.size.height)];
        UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.backgroundColor = [UIColor colorWithPatternImage:resultImage];
        //   }
    }
    
    
    
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *view = nil;
    
	if([partsArray count]>0 || [tripsArray count]>0)
    {
        if (view==nil)
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 22)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *mybottomimg =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 22)];
        [mybottomimg setImage:[UIImage imageNamed:@"Bottom.png"]];
        [view addSubview:mybottomimg];
        
        
    }
    
    return view;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = nil;
	if([partsArray count]>0 || [tripsArray count]>0)
    {
        if (view==nil)
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 22)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *mybottomimg =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 22)];
        [mybottomimg setImage:[UIImage imageNamed:@"Top.png"]];
        [view addSubview:mybottomimg];
        
        
    }
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if([partsArray count]>0 || [tripsArray count]>0)
    {
        return 22;
    }
    else return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if([partsArray count]>0 || [tripsArray count]>0)
    {
        
        return 22;
    }
    else return 0;
}

/**/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)printInvoiceFunction:(NSData *)myPdfforPrint{
	
    //	NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"png"];
	NSData *dataFromPath = myPdfforPrint;
	
	UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
	
	if(printController) {
		
		printController.delegate = self;
		
		UIPrintInfo *printInfo = [UIPrintInfo printInfo];
		printInfo.outputType = UIPrintInfoOutputGeneral;
		printInfo.jobName = @"Invoice";
		printInfo.duplex = UIPrintInfoDuplexLongEdge;
		printController.printInfo = printInfo;
		printController.showsPageRange = YES;
		printController.printingItem = dataFromPath;
		
		void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
			if (!completed && error) {
				NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
			}
		};
		
		[printController presentAnimated:YES completionHandler:completionHandler];
		
	}
}


///
-(void)PdfPreview{
    
    tripsArrayforPdf = [NSMutableArray array];
    PartArrayForPdf = [NSMutableArray array];
    int GetTotalValuesForParts = 0;
    
    //For show the list of all Part in Job
    for (int i = 0; i < [partsArray count]; i++) {

        Parts *obj=[partsArray objectAtIndex:i];
        obj.addValues = [NSString stringWithFormat:@"%d",[obj.Quantity intValue] * [obj.unitPrice intValue]];
        GetTotalValuesForParts += [obj.Quantity intValue] * [obj.unitPrice intValue];
        
        [PartArrayForPdf addObject:obj];
    }
    
    //For show the list of all Trips in Job
    for (int i = 0; i < [tripsArray count]; i++) {
        Trip *obj=[tripsArray objectAtIndex:i];
        obj.tNumberOfHour = [self TotalTimebetween2Date:obj.startTime andDateEnd:obj.EndTime];
        [tripsArrayforPdf addObject:obj];
        
    }
    
    //the below condition for showing the proper invoice that why if the part is less than 3 or equal to 0 add 
    if ([partsArray count]==0 || [partsArray count]<=3) {
        Parts *obj = [[Parts alloc] init];
        obj.PartName = @"-";
        obj.Quantity = @"0";
        obj.unitPrice = @"0";
        obj.addValues = @"0";
        
        obj.Id = @"0";
        obj.JobId = @"0";
        obj.PartId = @"0";
        obj.markup = @"0";
        
        [PartArrayForPdf addObject:obj];
        if ([partsArray count]==0) {
        [PartArrayForPdf addObject:obj];    
        }

        
    }
    
    
    //For show the total Amount
    float partTotal = 0.0,TripTotal=0.0,GrandTotal=0.0;
    
    partTotal=[Job PartsTotal:partsArray];
    TripTotal=[Job tripTotal:tripsArray andPerhourRate:[InvoiceInformationObject.PerHourRate floatValue]];
    GrandTotal=partTotal+TripTotal;

    
    // name    == name
    // address == add1
    // city    == fax
    // state   == phone
    // zip     == email

    Company *mycmp =  [[Company alloc] init];
    mycmp =[dbObj GetCompany];
    


    //GetCompany
    defaultValues = @{
                      @"tripsarray"       : tripsArrayforPdf,
                      @"partsarray"         : PartArrayForPdf,
                      
                      
                      @"khan"             : @"niceWorld",
                      
                      @"InvoiceNumber"    : [NSString stringWithFormat: @"%f", 2222.0],
                      
                      
                      @"companyName"      : mycmp.name,
                      @"companyAddress"   : mycmp.add1,
                      @"companyCity"      : mycmp.fax,
                      @"companyState"     : mycmp.phone,
                      @"companyZip"       : mycmp.email,
                      
                      
                      @"customerName"      : InvoiceInformationObject.RName,
                      @"customerAddress"   : InvoiceInformationObject.RAddress,
                      @"customerCity"      : InvoiceInformationObject.RCity,
                      @"customerState"     : InvoiceInformationObject.RState,
                      @"customerZip"       : InvoiceInformationObject.RZip,
                      
                      
                      @"partAmount"     : [NSString stringWithFormat: @"%f", partTotal],
                      @"TripsAmount"    : [NSString stringWithFormat: @"%f", TripTotal],
                      @"GrandTotal"     : [NSString stringWithFormat: @"%f", GrandTotal],
                      @"jobdesc"     : JobForInvoice.JobDesc,
                      
                      @"senderSignImage" : [[NSUserDefaults standardUserDefaults] valueForKey:@"senderSign"],
                      @"RecSignImage" : [[NSUserDefaults standardUserDefaults] valueForKey:@"recSign"]
                      

                      };
    
    NSLog(@" value %@",defaultValues);
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(CallForPDF) userInfo:nil repeats:NO];

    
    
}
-(void)CallForPDF
{
    int paperCount = PartArrayForPdf.count +  tripsArrayforPdf.count;
    

    NSLog(@"count %d",paperCount);
    
    NSError * error;
    NSString * templatePath = [[NSBundle mainBundle] pathForResource:@"template1" ofType:@"mustache"];
    [[PRKGenerator sharedGenerator] createReportWithName:@"template1" templateURLString:templatePath itemsPerPage:paperCount totalItems:paperCount pageOrientation:PRKPortraitPage dataSource:self delegate:self error:&error];

}
-(NSString *)TotalTimebetween2Date:(NSString *)dateStart andDateEnd:(NSString *)dateEnd{
    NSLog(@"stDa %@ ,enD %@",dateStart,dateEnd);
    
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init] ;
    NSDate *serDate;
    
    NSDate *endDate;
    
    [formatter3 setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    serDate = [formatter3 dateFromString:dateStart];
    endDate = [formatter3 dateFromString:dateEnd];
    
    NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:serDate];
    
    double minutes = timeDifference / 60;
    
    double hours = minutes / 60;
    
//    double seconds = timeDifference;
//    double days = minutes / 1440;
    
    
    return [NSString stringWithFormat:@"%.2f",hours];
    
}

- (id)reportsGenerator:(PRKGenerator *)generator dataForReport:(NSString *)reportName withTag:(NSString *)tagName forPage:(NSUInteger)pageNumber{
    if ([tagName isEqualToString:@"articles"])
        return [[defaultValues valueForKey:tagName] subarrayWithRange:NSMakeRange((pageNumber - 1) * 1, 1)];
    
    return [defaultValues valueForKey:tagName];
}

- (void)reportsGenerator:(PRKGenerator *)generator didFinishRenderingWithData:(NSData *)data{
  
    
    [data writeToFile:[self DirectoryPath] atomically:YES];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 43, 320, 369)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.scalesPageToFit = YES; //this enables the zooming**
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[self DirectoryPath]]];
    [webView loadRequest:request];
    [self.view addSubview:webView];

    
   // NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[self DirectoryPath]]];
   // [self.webView loadRequest:request];
}
-(NSString*)DirectoryPath{


    NSString * basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * fileName = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",myJobName]];
    return fileName;
}


-(IBAction) showActionSheet:(id)sender forEvent:(UIEvent*)event{
    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@""];

    [actionSheet addButtonWithTitle:@"Email" block:^{
        NSLog(@"pushed hoge1 button");
        [self EmailInvoice];
    }];
    [actionSheet addButtonWithTitle:@"PrintInvoice" block:^{
        NSLog(@"pushed hoge2 button");
        [self PrintInvoice];
    }];
    [actionSheet cancelButtonWithTitle:@"Cancel" block:nil];
    actionSheet.cornerRadius = 5;
    
    [actionSheet showWithTouch:event];
}

@end
