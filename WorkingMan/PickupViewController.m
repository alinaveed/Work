//
//  InventoryViewController.m
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import "PickupViewController.h"
#import "AddInventoryViewController.h"
#import "SearchInventoryViewController.h"
#import "Database.h"
#import "PickupCell.h"
#import "CustomMenuCell.h"
#import "CustomButton.h"
@interface PickupViewController ()

@end

@implementation PickupViewController

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
    db_obj=[[Database alloc]init];
    InventoryArray=[[NSMutableArray alloc]init];
    [inventoryTable setBackgroundColor:[UIColor clearColor]];
    catarray=[[NSMutableArray alloc]init];
    dict=[[NSMutableDictionary alloc] init];
    array=[[NSMutableArray alloc] init];
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            [bckImge setFrame:CGRectMake(0, 0, 320, 480)];
            //            searchCsvBtn
        }
        if(result.height == 568)
        {
            [bckImge setFrame:CGRectMake(0, 0, 320, 568)];
            
            [inventoryTable setFrame:CGRectMake(0, 79, 320, 395)];
            
            [upDateBtn setFrame:CGRectMake(103, 450, 112, 31)];
        }
    }
	// Do any additional setup after loading the view.
}
-(IBAction)Next
{
    AddInventoryViewController *coll = [self.storyboard instantiateViewControllerWithIdentifier:@"addinventory"];
    [self.navigationController pushViewController:coll animated:YES];
}

-(IBAction)SearchInv
{
    SearchInventoryViewController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"searchcsv"];
    [self.navigationController pushViewController:search animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    NSLog(@"view ll apper ");
    InventoryArray= [db_obj getInventoryTable];
    
    
    buyValueArrayChild = [[NSMutableArray alloc] init];
    buyValueArrayParent= [[NSMutableArray alloc] init];
    
    
    NSLog(@"Inventory mai kia hai  %@",InventoryArray);
    
    if([catarray count]>0)
    {
        [catarray removeAllObjects];
    }
    
    
    for (int i=0; i<[InventoryArray count]; i++) {
        
        if(![catarray containsObject:[[InventoryArray objectAtIndex:i] Category]])
            [catarray addObject:[[InventoryArray objectAtIndex:i] Category]];
    }
    
    if([dict count]>0)
    {
        [dict removeAllObjects];
    }
    
    for (int i=0; i<[catarray count]; i++) {
        
        
        NSString *cat=[catarray objectAtIndex:i];
        
        if([array count]>0)
        {
            [array removeAllObjects];
        }
        
        
        NSLog(@"dict mai kia start hai %@",dict);
        
        for (int i=0; i<[InventoryArray count]; i++) {
            
            NSLog(@"cat %@ and object %@",cat,[[InventoryArray objectAtIndex:i] Category]);
            if([[[InventoryArray objectAtIndex:i] Category] isEqualToString:cat])
            {
                
                NSLog(@"if mai aya");
                [array addObject:[InventoryArray objectAtIndex:i]];
                
            }
            
            [buyValueArrayChild addObject:@"0"];
            
        }
        
        [buyValueArrayParent addObject:buyValueArrayChild];
        
        NSLog(@"array %@",array);
        
        [dict setObject:[array copy] forKey:cat];
        cat=nil;
        NSLog(@"dict mai kai add hoa %@",dict);
        
        
    }
    NSLog(@"dict mai kia aya hai %@",dict);
    
    //  NSLog(@"dict mai kia aya hai %@",[[buyValueArrayParent objectAtIndex:0] objectAtIndex:0]);
    
    [inventoryTable reloadData];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSLog(@"view did apear ");
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dict count]>0) {
        return  [[dict valueForKey:[catarray objectAtIndex:section]] count];
        
    }
    else
        return 0;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rid;
    rid = [NSString stringWithFormat: @"%dabcdef%d",indexPath.row,indexPath.section];
    
    
    UITableViewCell *cell ;
    PickupCell *InvCell=(PickupCell*)[tableView dequeueReusableCellWithIdentifier:rid];
    InvCell.tag = indexPath.row +1+indexPath.section;
    
    if (InvCell == nil) {
        InvCell = [[PickupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid] ;
    }
    [InvCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [InvCell setBackgroundColor:[UIColor clearColor]];
    
    
    InventoryClass *obj=[[dict valueForKey:[catarray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    InvCell.lblName.text=obj.Name;
    InvCell.lblPrice.text=obj.Price;
    //for pick current - remaining
//    NSString *forPickup = [NSString stringWithFormat:@"%d", [obj.Quantity intValue]-  [obj.remainingQuantity intValue]];
    NSString *forPickup = [NSString stringWithFormat:@"%d", [obj.maintenanceLevel intValue]];
    InvCell.lblQuantity.text=forPickup;
    
    
    [InvCell.pricebtn setTitle:obj.Price forState:UIControlStateNormal];
    InvCell.pricebtn.indexPathvalues  = indexPath;
    [InvCell.pricebtn addTarget:self action:@selector(AddBuy_Price:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *titlebtn = [[buyValueArrayParent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [InvCell.buybtn setTitle:titlebtn forState:UIControlStateNormal];
    
    InvCell.buybtn.indexPathvalues = indexPath;
    [InvCell.buybtn addTarget:self action:@selector(AddBuy_Price:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *myimg = [[UIImageView alloc] initWithFrame:CGRectMake(217,18 , 15, 15)];
    [myimg setImage:[UIImage imageNamed:@"comboBox.png"]];
    [InvCell addSubview:myimg];
    
    UIImageView *myimg2 = [[UIImageView alloc] initWithFrame:CGRectMake(217+75,18 , 15, 15)];
    [myimg2 setImage:[UIImage imageNamed:@"comboBox.png"]];
    [InvCell addSubview:myimg2];

    cell=InvCell;
    
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [catarray objectAtIndex:section] ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
	return [catarray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
    
    
}

/**/
-(void)AlertFunction:(NSString *)msg{
    NSString *errorFound = @"";
    NSString *Okbtn = @"OK";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:errorFound message:msg delegate:self cancelButtonTitle:Okbtn otherButtonTitles:nil];
    alert.tag = 74637;
    
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 8973) {
        if (buttonIndex == 0) {
            
            //            if(CattextField.text == nil || [CattextField.text isEqualToString:@""])
            //            {
            
            [[buyValueArrayParent objectAtIndex:[saveSection intValue]] replaceObjectAtIndex:[saveIndex intValue] withObject:textField.text];
            
            InventoryClass *obj= [[InventoryClass alloc] init];
            obj = [[dict valueForKey:[catarray objectAtIndex:[saveSection intValue]]] objectAtIndex:[saveIndex intValue]];
            
            //            NSString *checkstr = [NSString stringWithFormat:@"%d",[textField.text intValue]* [obj.Price intValue]];
            //            obj.Price = [checkstr copy];
            NSLog(@"check %@",textField2.text);
            
            if ([textField2.text isEqualToString:@""] ||[textField2.text length]==0 ) {
                
                textField2.text = @"0";
            }
            obj.Price = textField2.text;
            
            int index_=[[dict valueForKey:[catarray objectAtIndex:[saveSection intValue]]] indexOfObject:obj];
            NSString *keyVAue = [catarray objectAtIndex:[saveSection intValue]];

            //Change From Client
//          int valueforQuantity = [obj.Quantity intValue]-  [obj.remainingQuantity intValue];
            int valueforQuantity = [obj.maintenanceLevel intValue];
            
            
//---------------------------Ali 
/*            if ([textField.text intValue]>valueforQuantity) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Value must be less than or equal to pickup value" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
                
            }
            else{
                
                NSMutableArray *mycheck  = [[NSMutableArray alloc]initWithArray:[dict valueForKey:keyVAue]];
                [mycheck replaceObjectAtIndex:index_  withObject:obj];
                [inventoryTable reloadData];
            }
 
 */
//------------------------
            
            //                if (!forcatAndSubcategory)
            //                    errorName = @"Please enter SubCategory";
            //
            //                [self AlertFunction:errorName];
            //            }
            /*            else
             {
             Database *db=[[Database alloc]init];
             
             if (forcatAndSubcategory)
             {
             [db addCategory:CattextField.text];
             pickerArray= [[db getCategory] copy];
             
             selectedCategory = CattextField.text;
             CattextField.text = @"";
             
             [catBtn setTitle:selectedCategory forState:UIControlStateNormal];
             
             CateogryClass *invent_obj= [pickerArray objectAtIndex:[pickerArray count]-1];
             [self updateCateID:[invent_obj.CatId copy]];
             
             }
             else
             {
             [pickerArrayForSubCategories addObject:CattextField.text];
             
             NSString *myString = [pickerArrayForSubCategories componentsJoinedByString:@","];
             NSLog(@"mystr %@",myString);
             [db updateSubCategories:myString andCatID:IDselectedCategory];
             
             pickerArray= [[db getCategory] copy];
             
             selectedSubCategory = CattextField.text;
             CattextField.text = @"";
             
             [subCatBtn setTitle:selectedSubCategory forState:UIControlStateNormal];
             
             }
             [picker reloadAllComponents];
             
             
             }
             */
            
             textField2.text = @"0";
             textField.text = @"0";
        }
        
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 2626 || alertView.tag == 2627) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/**/
-(IBAction)AddBuy_Price:(CustomButton*)sender{
    
    
    CustomButton *btn = (CustomButton *)sender;
    NSIndexPath *getValue = btn.indexPathvalues;
    
    //        NSLog(@"btn  %@",btn);
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 63.0, 260.0, 25.0)];
    textField2 = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 103.0, 260.0, 25.0)];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField2.keyboardType = UIKeyboardTypeDecimalPad;
    
    saveSection = [NSString stringWithFormat:@"%d",getValue.section];
    saveIndex = [NSString stringWithFormat:@"%d",getValue.row];
    
    
    InventoryClass *obj=[[dict valueForKey:[catarray objectAtIndex:getValue.section]] objectAtIndex:getValue.row];
    
    NSString *titlebtn = [[buyValueArrayParent objectAtIndex:getValue.section] objectAtIndex:getValue.row];
    
    textField.text = titlebtn;
    textField2.text = obj.Price;
    
    NSString *nameandEMail = @"Enter Quantity and Price";
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
    [textField setPlaceholder:@"Quantity"];
    
    [prompt addSubview:textField];
    
    textField2.tag = 6574;
    textField2.delegate = self;
    [textField2 setBackgroundColor:[UIColor whiteColor]];
    [textField2 setPlaceholder:@"Price"];
    [prompt addSubview:textField2];
    
    [prompt show];
    [textField becomeFirstResponder];
}

-(IBAction)updatetheValues:(id)sender
{
    
    NSMutableArray *myBtnValue = [[NSMutableArray alloc] init];
    for (int sectionva = 0; sectionva < [self numberOfSectionsInTableView:inventoryTable]; sectionva++) {
        for (int rowva = 0; rowva < [self tableView:inventoryTable numberOfRowsInSection:sectionva]; rowva++) {
            NSIndexPath *myIndexPath =[NSIndexPath indexPathForRow:rowva inSection:sectionva];
            PickupCell * cell = (PickupCell *)[self tableView:inventoryTable cellForRowAtIndexPath:myIndexPath];
            [myBtnValue addObject:cell.buybtn.currentTitle];
        }
    }
    
    
    for (int k =0 ; k<[InventoryArray count]; k++) {
        InventoryClass *obj=[InventoryArray objectAtIndex:k];
        NSString *myRemainingValue = [NSString stringWithFormat:@"%d",[obj.remainingQuantity intValue]+[[myBtnValue objectAtIndex:k] intValue]] ;
        [db_obj pickSectionUpdate:obj.Price andRemainincount:myRemainingValue andInvId:[obj.Inv_Id intValue]];
    }
    [self viewWillAppear:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
