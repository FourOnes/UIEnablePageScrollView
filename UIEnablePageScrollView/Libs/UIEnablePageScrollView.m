//
//  tnAppDelegate.m
//  UIEnablePageScrollView
//
//  Created by Lee Aru on 13-5-8.
//  Copyright (c) 2013年 FourOnes http://www.xnwai.com. All rights reserved.
//

#import "UIEnablePageScrollView.h"
@interface UIEnablePageScrollView(Private)
-(void)needShowViews:(NSInteger)curPage;
-(void)notifyPageChaged:(NSInteger)p;
@end

@implementation UIEnablePageScrollView
@synthesize page=_page;
@synthesize pageCount=_pageCount;
@synthesize UIEnablePageScrollViewDelegate;
@synthesize isLoadCompeleted=_isLoadCompeleted;
@synthesize loadingCompeleted;

-(void)needShowViews:(NSInteger)curPage{
    if(curPage<0||curPage>=_pageCount) return;
    //需要显示的页码
    NSMutableArray *numList=[[NSMutableArray alloc]init];
    if(curPage-1>=0){
        [numList addObject:[NSNumber numberWithInt:curPage-1]];
    }
    [numList addObject:[NSNumber numberWithInt:curPage]];
    if(curPage+1<_pageCount){
        [numList addObject:[NSNumber numberWithInt:curPage+1]];
    }
    //移除所有VIEW
    for (UIView *view in [self subviews]) {
        int tag=view.tag;
        if(tag==9999) continue;
        if([numList containsObject:[NSNumber numberWithInt:view.tag]]){
            [numList removeObject:[NSNumber numberWithInt:view.tag]];
            continue;
        }
        [view removeFromSuperview];
    }
    for (NSNumber *n in numList) {
        UIView *view = [self.UIEnablePageScrollViewDelegate UIEnablePageScrollView:self withIndex:n.integerValue];
        view.tag=n.integerValue;
        [self addSubview:view];
    }
    [numList release];
}

-(void)reload{
    _pageCount=[UIEnablePageScrollViewDelegate numberOfUIEnablePageScrollView:self];
    //移除所有VIEW
    for (UIView *view in [self subviews]) {
        int tag=view.tag;
        if(tag==9999) continue;
        [view removeFromSuperview];
    }
    
    [self setIsLoadCompeleted:self.isLoadCompeleted];
    if(self.page<0||self.page>=_pageCount){
        self.page=0;
    }
    //滚动视图
    //[self scrollRectToVisible:CGRectMake(_page*self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height) animated:YES];
    [self needShowViews:self.page];
    [self notifyPageChaged:self.page];
}

-(void)setPage:(NSInteger)p{
    if(p==self.page) return;
    _page=p;
    //滚动视图
    [self scrollRectToVisible:CGRectMake(_page*self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height) animated:YES];
}
-(void)setIsLoadCompeleted:(BOOL)yeOrNo{
    _isLoadCompeleted=yeOrNo;
    if([[self subviews]containsObject:loadMoreView]){
        if(_isLoadCompeleted){
            [loadMoreView removeFromSuperview];
            self.contentSize=CGSizeMake(self.pageCount*self.frame.size.width, self.frame.size.height);
        }
        else{
            self.contentSize=CGSizeMake((self.pageCount+1)*self.frame.size.width, self.frame.size.height);
        }
    }
    else{
        if(_isLoadCompeleted){
            self.contentSize=CGSizeMake(self.pageCount*self.frame.size.width, self.frame.size.height);
        }
        else{
            [self addSubview:loadMoreView];
            self.contentSize=CGSizeMake((self.pageCount+1)*self.frame.size.width, self.frame.size.height);
        }
    }
    loadMoreView.frame=CGRectMake(self.pageCount*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _page=0;
        
        self.pagingEnabled=YES;
        self.scrollEnabled=YES;
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
        self.delegate=self;
        
        loadMoreView=[[UIView alloc]init];
        loadMoreView.backgroundColor=[UIColor clearColor];
        loadMoreView.tag=9999;
        //增加转圈圈
        UIActivityIndicatorView *quanquan=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.frame.size.width-25.0f)/2.0f, (self.frame.size.height-25.0f)/2.0f, 25.0f, 25.0f)];;
        quanquan.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        quanquan.hidesWhenStopped=NO;
        [loadMoreView addSubview:quanquan];
        [quanquan startAnimating];
        [quanquan release];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.frame.size.width;
    int p = floor((self.contentOffset.x - pageWidth / 3) / pageWidth) + 1;
    if(p<0) return;
    if(p>=self.pageCount)
    {
        if(!self.loadingCompeleted) return;
        self.loadingCompeleted=NO;
        if([self.UIEnablePageScrollViewDelegate respondsToSelector:@selector(UIEnablePageScrollViewLoadMore:)]){
            [self.UIEnablePageScrollViewDelegate UIEnablePageScrollViewLoadMore:self];
        }
    }
    else{
        [self needShowViews:p];
        if(self.page!=p){
            [self notifyPageChaged:p];
        }
        _page=p;
    }
}
-(void)notifyPageChaged:(NSInteger)p{
    if([self.UIEnablePageScrollViewDelegate respondsToSelector:@selector(UIEnablePageScrollViewPageChanged:curPage:)]){
        NSMutableDictionary *viewDicList=[[[NSMutableDictionary alloc]init]autorelease];
        //查找当前存在的VIEW
        for (UIView *view in [self subviews]){
            if(view.tag==p){
                [viewDicList setValue:view forKey:[NSString stringWithFormat:@"%d",view.tag]];
            }
            if(p-1>=0&&view.tag==p-1){
                [viewDicList setValue:view forKey:[NSString stringWithFormat:@"%d",view.tag]];
            }
            if(p+1<_pageCount&&view.tag==p+1){
                [viewDicList setValue:view forKey:[NSString stringWithFormat:@"%d",view.tag]];
            }
        }
        [self.UIEnablePageScrollViewDelegate UIEnablePageScrollViewPageChanged:viewDicList curPage:p];
    }
}
-(void)dealloc{
    [super dealloc];
    [loadMoreView release];
    loadMoreView=nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if([self.UIEnablePageScrollViewDelegate respondsToSelector:@selector(UIEnablePageScrollViewLoadMore:didSelectedIndex:)]){
        [self.UIEnablePageScrollViewDelegate UIEnablePageScrollViewLoadMore:self didSelectedIndex:_page];
    }
    NSLog(@"当前页:%d",_page);
    [super touchesEnded:touches withEvent:event];
}

@end
