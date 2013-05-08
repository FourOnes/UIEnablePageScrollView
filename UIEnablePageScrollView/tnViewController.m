//
//  tnViewController.m
//  UIEnablePageScrollView
//
//  Created by Lee Aru on 13-5-8.
//  Copyright (c) 2013年 FourOnes. All rights reserved.
//

#import "tnViewController.h"

@interface tnViewController ()

@end

@implementation tnViewController
@synthesize pageScrollView=_pageScrollView;
@synthesize sourceList=_sourceList;
@synthesize list=_list;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _pageScrollView=[[UIEnablePageScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.pageScrollView];
    self.pageScrollView.UIEnablePageScrollViewDelegate=self;
    
    _sourceList=[[NSMutableArray alloc]init];
    m_nCurPageindex=1;
    _list=[[NSMutableArray alloc]init];
    [self initSourceList];
    [self loadDataHelper:[NSString stringWithFormat:@"%d",m_nCurPageindex]];
}
-(void)viewDidUnload{
    self.pageScrollView=nil;
    self.sourceList=nil;
    self.list=nil;
    [super viewDidUnload];
}
-(void)dealloc{
    self.pageScrollView=nil;
    self.sourceList=nil;
    self.list=nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    self.pageScrollView=nil;
    self.sourceList=nil;
    self.list=nil;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UIEnablePageScrollViewDelegate--
-(void)UIEnablePageScrollViewLoadMore:(id)sender{
    if([self.list count]<[self.sourceList count]){
        self.pageScrollView.loadingCompeleted=NO;
        //模拟联网加载数据的过程
        [self performSelector:@selector(loadDataHelper:) withObject:[NSString stringWithFormat:@"%d",m_nCurPageindex+1] afterDelay:.5f];
    }
}
-(NSInteger)numberOfUIEnablePageScrollView:(id)sender{
    return [self.list count];
}
-(UIView *)UIEnablePageScrollView:(id)sender withIndex:(NSInteger)index{
    
    CGFloat x=index*self.pageScrollView.frame.size.width;
    CGRect rect=CGRectMake(x, 0, self.pageScrollView.frame.size.width, self.pageScrollView.frame.size.height);
    UIView *view=[[[UIView alloc]initWithFrame:rect] autorelease];
    view.backgroundColor=(UIColor *)[self.list objectAtIndex:index];
    UILabel *textLbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 60)];
    textLbl.backgroundColor=[UIColor blackColor];
    textLbl.text=[NSString stringWithFormat:@"第%d页",index+1];
    textLbl.textColor=[UIColor whiteColor];
    textLbl.font=[UIFont boldSystemFontOfSize:35.0f];
    [view addSubview:textLbl];
    [textLbl release];
    [self.pageScrollView addSubview:view];
    return view;
}
-(void)UIEnablePageScrollViewPageChanged:(NSMutableDictionary *)viewDictionary curPage:(NSInteger)page{
    NSLog(@"UIEnablePageScrollViewPageChanged");
}
-(void)UIEnablePageScrollViewLoadMore:(id)sender didSelectedIndex:(NSInteger)index{
    NSString *s=[NSString stringWithFormat:@"选中了%d页",index];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:s delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}

#pragma mark --模拟数据源---
-(void)initSourceList{
    for (CGFloat i=0; i<255; i+=30) {
        for (CGFloat j=0; j<255; j+=30){
            for (CGFloat k=0; k<255; k+=30){
                UIColor *color=[UIColor colorWithRed:i/255.0f green:j/255.0f blue:k/255.0f alpha:1.0f];
                [self.sourceList addObject:color];
            }
        }
    }
    m_nTotalDatas=[self.sourceList count];
    m_nTotalPages=m_nTotalDatas/ROWS;
    if(m_nTotalDatas%ROWS>0){
        m_nTotalPages++;
    }
}
-(void)loadDataHelper:(NSString *)i{
    NSInteger index=[i integerValue];
    if(index==1){
        [self.list removeAllObjects];
    }
    for (NSInteger i=(index-1)*ROWS; i<index*ROWS; i++) {
        [self.list addObject:[self.sourceList objectAtIndex:i]];
    }
    m_nCurPageindex=index;
    self.pageScrollView.loadingCompeleted=YES;
    [self.pageScrollView reload];
}

@end
