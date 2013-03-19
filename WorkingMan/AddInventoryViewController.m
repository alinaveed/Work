//
//  AddInventoryViewController.m
//  WorkingMan
//
//  Created by Umer Khan on 12/12/12.
//  Copyright (c) 2012 Umer Khan. All rights reserved.
//

#import "AddInventoryViewController.h"
#import "InventoryClass.h"
#import "Database.h"
#import "CateogryClass.h"
@interface AddInventoryViewController ()

@end

@implementation AddInventoryViewController
@synthesize isEdit,Inventory_ToEdit;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithInventoryObject:(InventoryClass*)inventoryObj{


    self=[super init];
    if (self) {
        Inventory_ToEdit=[[InventoryClass alloc]init];
        Inventory_ToEdit=inventoryObj;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    forcatAndSubcategory = YES;
        barForMakupButton.hidden=YES;
    CattextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 63.0, 260.0, 25.0)];

    Database *db_obj=[[Database alloc]init];
    
    if(isEdit)
    {
    
        nameField.text=Inventory_ToEdit.Name;
        priceField.text=Inventory_ToEdit.Price;
        quantityField.text=Inventory_ToEdit.Quantity;
        maintenanceField.text=Inventory_ToEdit.maintenanceLevel;
        
        markUpValue.text = Inventory_ToEdit.MarkUp;
        
        [catBtn setTitle:Inventory_ToEdit.Category forState:UIControlStateNormal];
        [subCatBtn setTitle:Inventory_ToEdit.SubCategory forState:UIControlStateNormal];
        [UpdatenSavebtn setImage:[UIImage imageNamed:@"btn-update.png"] forState:UIControlStateNormal];
        
//        [self updateCateID:[Inventory_ToEdit.Inv_Id copy]];
        
        selectedCategory =  Inventory_ToEdit.Category ;
        IDselectedCategory = [db_obj get_Categoryid:[Inventory_ToEdit.Inv_Id copy]];
    
    }
    pickerArray=[[NSMutableArray alloc]init];
    pickerArray = [db_obj getCategory];
    isViewUp=NO;

    
//    NSArray *myfg = [[NSArray alloc] initWithObjects:@"asdada",@"asdada",nil];
//    pickerArrayForSubCategories = [[NSMutableArray alloc] initWithArray:myfg];


    pickerArrayForSubCategories = [[NSMutableArray alloc] init];

    
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
            [scroll setFrame:CGRectMake(scroll.frame.origin.x,scroll.frame.origin.y -50, scroll.frame.size.height,  scroll.frame.size.height)];
            [picker setFrame:CGRectMake(picker.frame.origin.x, 202+80, picker.frame.size.width, picker.frame.size.height)];
        }
    }
	// Do any additional setup after loading the view.
}

-(void)updateCateID:(NSString *)cmgValue
{
    IDselectedCategory  = cmgValue;
    
    NSLog(@"for values %@",IDselectedCategory);
    
}
-(IBAction)BackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(IBAction)hidepicker:(id)sender{

    [self myViewDown:scroll];
    [bar setHidden:YES];
    [picker setHidden:YES];
    
    NSLog(@"why loss %@",selectedCategory);
    NSLog(@"why loss %@",selectedSubCategory);
    
    [catBtn setTitle:selectedCategory forState:UIControlStateNormal];
    [subCatBtn setTitle:selectedSubCategory forState:UIControlStateNormal];

}

-(IBAction)AddCategoryFunction{
    
    
    NSString *nameandEMail = @"Please enter Category";
    NSString *Enterbtn = @"Add";
    NSString *Cancelbtn = @"Cancel";
    
    [CattextField setPlaceholder:@"Category *"];
    
    if (!forcatAndSubcategory)
    {
        nameandEMail = @"Please enter SubCategory";
        [CattextField setPlaceholder:@"SubCategory *"];
    }
    UIAlertView *prompt;
    prompt = [[UIAlertView alloc] initWithTitle:nameandEMail
                                        message:@"\n\n\n" // IMPORTANT
                                       delegate:nil
                              cancelButtonTitle:Cancelbtn
                              otherButtonTitles:Enterbtn, nil];
    prompt.tag = 8973;
    prompt.delegate = self;
    
    CattextField.tag = 6573;
    CattextField.delegate = self;
    [CattextField setBackgroundColor:[UIColor whiteColor]];
    
    
    [prompt addSubview:CattextField];
    
    [prompt show];
    // set cursor and show keyboard
    [CattextField becomeFirstResponder];
    
    
    
}
-(void)AlertFunction:(NSString *)msg
{
    
    NSString *errorFound = @"";
    NSString *Okbtn = @"OK";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:errorFound message:msg delegate:self cancelButtonTitle:Okbtn otherButtonTitles:nil];
    alert.tag = 74637;
    
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 8973) {
        if (buttonIndex == 1) {
            if(CattextField.text == nil || [CattextField.text isEqualToString:@""])
            {
                NSString *errorName = @"Please enter Category";
                
                if (!forcatAndSubcategory)
                    errorName = @"Please enter SubCategory";
                
                [self AlertFunction:errorName];
            }
            else
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
        }
        
        
    }
    
    if (alertView.tag == 74637) {
        
        [self AddCategoryFunction];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 2626 || alertView.tag == 2627) {
        [self.navigationController popViewControllerAnimated:YES];    
    }

}




- (void)myViewUp:(UIView*)sender

{
    if(!isViewUp)
    {
	
	[UIView beginAnimations:nil context:NULL];
	
    [UIView setAnimationDuration:0.3];
	
    CGRect rect = sender.frame;
	
	rect.origin.y -= moveHeight;
	
	sender.frame = rect;
	
    [UIView commitAnimations];
    }
	
    isViewUp=YES;
	
	
}


- (void)myViewDown:(UIView*)sender
{
	
    if(isViewUp)
    {
	[UIView beginAnimations:nil context:NULL];
	
    [UIView setAnimationDuration:0.3];
	
    CGRect rect = sender.frame;
	
	rect.origin.y += moveHeight;
	
	sender.frame = rect;
	
    [UIView commitAnimations];
    }
    isViewUp=NO;
	
}
-(IBAction)buttonClicked:(UIButton*)sender{
    
    [self myViewDown:scroll];
    
    if(!isViewUp)
    {
        
        moveHeight=100;
        [self myViewUp:scroll];
    }
    [maintenanceField resignFirstResponder];
    [quantityField resignFirstResponder];
    [priceField resignFirstResponder];
    [nameField resignFirstResponder];
    
    if ([sender tag]==0) {
        
        [mySelectCatbtn setTitle:@"Add Category"];
        forcatAndSubcategory = YES;
        
        selectedSubCategory = @"";
        
//        CateogryClass *invent_obj= [pickerArray objectAtIndex:0];
//        selectedCategory = invent_obj.CatName;
//        [self updateCateID:[invent_obj.CatId copy]];

    }
    else
    {
        [mySelectCatbtn setTitle:@"Add Subcategory"];
        forcatAndSubcategory = NO;
        

        Database *db=[[Database alloc]init];
        NSMutableArray *newpickerArray=[[NSMutableArray alloc]init];
        newpickerArray = [db getCategory];
        for (int  i =0; i<[newpickerArray count]; i++) {
            
            CateogryClass *invent_obj= [pickerArray objectAtIndex:i];
            
             NSLog(@"picker %@",IDselectedCategory);
            
            
            if ([invent_obj.CatId  isEqualToString:IDselectedCategory]) {
                
                if ([pickerArrayForSubCategories count]!=0) {
                    [pickerArrayForSubCategories removeAllObjects];
                }
                NSLog(@"picker %d",[pickerArrayForSubCategories count]);
                NSLog(@"picker %@",pickerArrayForSubCategories);

                pickerArrayForSubCategories = [[NSMutableArray alloc] initWithArray:invent_obj.subCategories];
//                selectedSubCategory=[pickerArrayForSubCategories objectAtIndex:0];
                
            }
        }



    }
    
    [bar setHidden:NO];
    [picker setHidden:NO];
    
//    [picker setFrame:CGRectMake(picker.frame.origin.x, 202+80, picker.frame.size.width, picker.frame.size.height)];
    [picker reloadAllComponents];
    
    if (forcatAndSubcategory)
    {
         [picker selectRow:pickerArray.count-1 inComponent:0 animated:YES];
         [self pickerView:picker didSelectRow:pickerArray.count-1  inComponent:0];
    }
	else
    {
        if ([IDselectedCategory isEqualToString:@""] ||
            IDselectedCategory == nil  ||
            [IDselectedCategory isKindOfClass:[NSNull class]])
        {
            [bar setHidden:YES];
            [picker setHidden:YES];
            [self myViewDown:scroll];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please Select Category" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];

        }
        else{
            [picker selectRow:pickerArrayForSubCategories.count-1 inComponent:0 animated:YES];
            [self pickerView:picker didSelectRow:pickerArrayForSubCategories.count-1  inComponent:0];

        }
    }

    
   
    
}

#pragma mark -
#pragma mark PICKERVIEW

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (forcatAndSubcategory)
        return pickerArray.count;
	else
        return pickerArrayForSubCategories.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (forcatAndSubcategory) {
        
        CateogryClass *invent_obj= [pickerArray objectAtIndex:row];
        NSLog(@"name %@",invent_obj.CatName);
        return invent_obj.CatName;
    }
    else
    {
        return [pickerArrayForSubCategories objectAtIndex:row];
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	
    
    if (forcatAndSubcategory) {

        CateogryClass *invent_obj= [pickerArray objectAtIndex:row];
        selectedCategory = invent_obj.CatName;
        [self updateCateID:[invent_obj.CatId copy]];
        
    }
    else
    {
        selectedSubCategory=[pickerArrayForSubCategories objectAtIndex:row];
    }
    
}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    [self hidepicker:nil];
//    if (textField==quantityField)
//    {
//        moveHeight = 50;
//       
//        [self myViewUp:self.view];
//    }
     if(textField==maintenanceField)
    {
        moveHeight = 70;
     
        [self myViewUp:scroll];
    
    }
    

    
    
    if (textField==markUpValue) {
        moveHeight=120;
        barForMakupButton.hidden=NO;
        [self myViewUp:scroll];
    }

}
-(IBAction)hidemarkUpKeyboard
{
    barForMakupButton.hidden=YES;
    [markUpValue resignFirstResponder];

    [self myViewDown:scroll];


}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    
    if (textField==quantityField || textField==maintenanceField) {
        [self myViewDown:scroll];
    }


    
    [textField resignFirstResponder];
	return YES;
}

-(IBAction)saveToDB{
    
    NSLog(@" catBtn.titleLabel.text %@",catBtn.titleLabel.text);
    
    NSLog(@" subCatBtn.titleLabel.text %@",subCatBtn.titleLabel.text);
    if([nameField.text length]==0 ||[quantityField.text length]==0 || [priceField.text length]==0  || [maintenanceField.text length]==0 || [catBtn.titleLabel.text length]==0 || [subCatBtn.titleLabel.text length]==0 || [markUpValue.text length]==0)
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please Enter all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    else{
        Database *db=[[Database alloc]init];
        
        InventoryClass *invt_obj=[[InventoryClass alloc]init];
        invt_obj.Name=nameField.text;
        invt_obj.Quantity=quantityField.text;
        invt_obj.Price=priceField.text;
        invt_obj.maintenanceLevel=maintenanceField.text;
        invt_obj.Category=catBtn.titleLabel.text;
        invt_obj.SubCategory=subCatBtn.titleLabel.text;
        invt_obj.MarkUp=markUpValue.text;
        
        if(isEdit)
        {
            invt_obj.Inv_Id=Inventory_ToEdit.Inv_Id;
            [db updateInventory:invt_obj];
          
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Successfully Updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag = 2626;
            [alert show];
            
            //update
            
        }
        
        else{
            [db addInventory:invt_obj];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Successfully Added" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        alert.tag = 2627;
            [alert show];

        }
        
      
        
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
