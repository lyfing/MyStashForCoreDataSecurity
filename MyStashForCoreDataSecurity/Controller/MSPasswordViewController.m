//
//  MSPasswordViewController.m
//  MyStashForCoreDataSecurity
//
//  Created by lyfing lee on 13-11-17.
//  Copyright (c) 2013年 lyfing.inc. All rights reserved.
//

#import "MSPasswordViewController.h"

@interface MSPasswordViewController ()
@property (nonatomic,strong) UITextField *nameTFiled;
@property (nonatomic,strong) UITextField *userIDTField;
@property (nonatomic,strong) UITextField *passwordTField;
@property (nonatomic,strong) Account *account;
@end

@implementation MSPasswordViewController
- (void)dealloc
{
    if ( _nameTFiled ) {
        self.nameTFiled = nil;
    }
    
    if ( _userIDTField ) {
        self.userIDTField = nil;
    }
    
    if ( _passwordTField ) {
        self.passwordTField = nil;
    }
    
    if ( _account ) {
        self.account = nil;
    }
}

- (id)initWithAccount:(Account *)mAccount
{
    if ( self = [super init] ) {
        self.account = mAccount;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self setupViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self updateViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)setupViews
{
    //NavBar && Title
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(handleSaveEvent:)];
    self.navigationItem.rightBarButtonItem = item;
    
    CGFloat x = 10.0f;
    CGFloat y = 10.0f;
    CGFloat width = SCREEN_WIDTH - 2 * x;
    CGFloat height = 30.0f;
    
    CGRect frame = CGRectMake(x, y, width, height);
    if ( nil == self.nameTFiled ) {
        self.nameTFiled = [[UITextField alloc] init];
        [self.nameTFiled setPlaceholder:@"Your Name"];
        self.nameTFiled.layer.borderWidth = 1.0f;
        [self.nameTFiled setFont:[UIFont systemFontOfSize:13.0f]];
        [self.nameTFiled setTextColor:[UIColor blackColor]];
        self.nameTFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.view addSubview:self.nameTFiled];
    }
    self.nameTFiled.frame = frame;
    
    y += ( height + 10.0f );
    frame = CGRectMake(x, y, width, height);
    if ( nil == self.userIDTField ) {
        self.userIDTField = [[UITextField alloc] init];
        [self.userIDTField setPlaceholder:@"Your UID"];
        self.userIDTField.layer.borderWidth = 1.0f;
        [self.userIDTField setFont:[UIFont systemFontOfSize:13.0f]];
        [self.userIDTField setTextColor:[UIColor blackColor]];
        self.userIDTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.view addSubview:self.userIDTField];
    }
    self.userIDTField.frame = frame;
    
    y += ( height + 10.0f );
    frame = CGRectMake(x, y, width, height);
    if ( nil == self.passwordTField ) {
        self.passwordTField = [[UITextField alloc] init];
        [self.passwordTField setPlaceholder:@"Your Password"];
        self.passwordTField.layer.borderWidth = 1.0f;
        [self.passwordTField setFont:[UIFont systemFontOfSize:13.0f]];
        [self.passwordTField setTextColor:[UIColor blackColor]];
        self.passwordTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.view addSubview:self.passwordTField];
    }
    self.passwordTField.frame = frame;
}

- (void)updateViews
{
    if ( self.account ) {
        
        if ( [self.account.name length] > 0 ) {
            [self.nameTFiled setText:self.account.name];
        }
        
        if ( [self.account.userID length] > 0 ) {
            [self.userIDTField setText:self.account.userID];
        }
        
        if ( [self.account.password length] > 0 ) {
            [self.passwordTField setText:self.account.password];
        }
    }
}


- (void)handleSaveEvent:(id)sender
{
    BOOL hasName = [self.nameTFiled.text length] > 0;
    BOOL hasUID = [self.userIDTField.text length] > 0;
    BOOL hasPwd = [self.passwordTField.text length] > 0;
    
    
    if ( hasName && hasUID && hasPwd )
    {
        if ( nil == self.account ) {
            MSAppDelegate *appDelegate = (MSAppDelegate *)[UIApplication sharedApplication].delegate;
            NSManagedObjectContext *moc = [appDelegate managedObjectContext];
            self.account = [NSEntityDescription insertNewObjectForEntityForName:kEntityAccount inManagedObjectContext:moc];
        }
        
        self.account.name = self.nameTFiled.text;
        self.account.userID = self.userIDTField.text;
        self.account.password = self.passwordTField.text;
        
        MSAppDelegate *appDelegate = (MSAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate saveContext];
    }
}
@end
