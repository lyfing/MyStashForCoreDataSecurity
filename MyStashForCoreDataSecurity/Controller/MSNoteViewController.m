//
//  MSNoteViewController.m
//  MyStashForCoreDataSecurity
//
//  Created by lyfing lee on 13-11-17.
//  Copyright (c) 2013年 lyfing.inc. All rights reserved.
//

#import "MSNoteViewController.h"

@interface MSNoteViewController ()
@property (nonatomic,strong) UITextField *titleTField;
@property (nonatomic,strong) UITextView *bodyTView;
@property (nonatomic,strong) Note *note;
@end

@implementation MSNoteViewController
- (void)dealloc
{
    if ( _titleTField ) {
        self.titleTField = nil;
    }
    
    if ( _bodyTView ) {
        self.bodyTView = nil;
    }
    
    if ( _note ) {
        self.note = nil;
    }
}

- (id)initWithNote:(Note *)mNote
{
    if ( self = [super init] ) {
        self.note = mNote;
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
	// Do any additional setup after loading the view
    [self updateViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
-(void)setupViews
{
    //NavBar && Title
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(handleSaveEvent:)];
    self.navigationItem.rightBarButtonItem = item;
    
    CGFloat x = 10.0f;
    CGFloat y = 10.0f;
    CGFloat width = SCREEN_WIDTH - 2 * x;
    CGFloat height = 30.0f;
    CGRect frame = CGRectMake(x, y, width, height);
    if ( nil == self.titleTField ) {
        self.titleTField = [[UITextField alloc] init];
        [self.titleTField setPlaceholder:@"Input the title"];
        self.titleTField.layer.borderWidth = 1.0f;
        [self.titleTField setFont:[UIFont systemFontOfSize:13.0f]];
        [self.titleTField setTextColor:[UIColor blackColor]];
        self.titleTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [self.view addSubview:self.titleTField];
    }
    self.titleTField.frame = frame;
    
    y += ( height + 10.0f );
    height = 200.0f;
    frame = CGRectMake(x, y, width, height);
    if ( nil == self.bodyTView ) {
        self.bodyTView = [[UITextView alloc] init];
        self.bodyTView.layer.borderWidth = 1.0f;
        [self.bodyTView setFont:[UIFont systemFontOfSize:13.0f]];
        [self.bodyTView setTextColor:[UIColor blackColor]];
        
        [self.view addSubview:self.bodyTView];
    }
    self.bodyTView.frame = frame;

}

- (void)updateViews
{
    if ( self.note ) {
    
        if ( [self.note.title length] > 0 ) {
            [self.titleTField setText:self.note.title];
        }
        
        if ( [self.note.body length] > 0 ) {
            [self.bodyTView setText:self.note.body];
        }
    }
}

- (void)handleSaveEvent:(id)sender
{
    if ( [self.titleTField.text length] > 0 && [self.bodyTView.text length] > 0 )
    {
        if ( nil == self.note ) {
            MSAppDelegate *appDelegate = (MSAppDelegate *)[UIApplication sharedApplication].delegate;
            NSManagedObjectContext *moc = [appDelegate managedObjectContext];
            self.note = [NSEntityDescription insertNewObjectForEntityForName:kEntityNote inManagedObjectContext:moc];
        }
        
        self.note.title = self.titleTField.text;
        self.note.body = self.bodyTView.text;
        
        MSAppDelegate *appDelegate = (MSAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate saveContext];
    }
}
@end