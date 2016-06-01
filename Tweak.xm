#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AMapPOI.h"


NSMutableArray* nearByPOIs;
UITableView *nearByPOITableView;
%hook DTMapViewSignInController
-(NSMutableArray *)nearByPOIs
{
     NSMutableArray*tempArr=%orig ;
     object_getInstanceVariable(self,"_nearByPOIs",(void**)&nearByPOIs);//访问私有变量

   /*  if(tempArr.count!=0)
     {

        if([tempArr objectAtIndex:1]==[tempArr objectAtIndex:2])
             return tempArr ;
    
          [tempArr insertObject:[tempArr objectAtIndex:1] atIndex:1];
          AMapPOI *myobj =[tempArr objectAtIndex:1];
          AMapGeoPoint *myp=myobj.location;
          myp.longitude=22.674209;
          myp.latitude=114.064201;
      }*/
        AMapPOI *myobj=[nearByPOIs firstObject];

        NSLog(@"%@%@%@%@\n type:%@\n name:%@\n  ",myobj.province,myobj.city,myobj.district,myobj.address,myobj.type,myobj.name);


	 return tempArr;
}


- (void)viewDidLoad
{
    %orig;
    UIButton *btnAdd=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-110, [UIScreen mainScreen].bounds.size.height-50, 100, 44)];
    [btnAdd setTitle:@"添加打卡地点" forState:UIControlStateNormal];
    btnAdd.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [btnAdd addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [btnAdd setBackgroundColor:[UIColor blueColor]];
    [((UIViewController *)self).view addSubview:btnAdd];
    [((UIViewController *)self).view bringSubviewToFront:btnAdd];
    object_getInstanceVariable(self,"_nearByPOITableView",(void**)&nearByPOITableView);

}
%new
- (void)clickBtn
{
    UIView *showview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    showview.backgroundColor=[UIColor whiteColor];
    showview.tag=100;
    showview.alpha=0.7;
    [((UIViewController *)self).view addSubview:showview];

    UIView *showInputView=[[UIView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-300)/2, 100, 300, 400)];
    showInputView.tag=1001;
    showInputView.backgroundColor=[UIColor grayColor];

    [((UIViewController *)self).view addSubview:showInputView];

    UITapGestureRecognizer *tapClose=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickclose:)];
    [showview addGestureRecognizer:tapClose];
    
    UITextField *textla=[[UITextField alloc]initWithFrame:CGRectMake(20, 20, 260, 30)];
    textla.tag=101;
    textla.placeholder=@"114.1234";
    textla.keyboardType=UIKeyboardTypeEmailAddress;
    textla.borderStyle=UITextBorderStyleRoundedRect;
    [showInputView addSubview:textla];
    
    UITextField *textlo=[[UITextField alloc]initWithFrame:CGRectMake(20, 70, 260, 30)];
    textlo.tag=102;

    textlo.placeholder=@"22.1234";
    textlo.keyboardType=UIKeyboardTypeEmailAddress;
    textlo.borderStyle=UITextBorderStyleRoundedRect;
    [showInputView addSubview:textlo];
    
    UITextField *textaddress=[[UITextField alloc]initWithFrame:CGRectMake(20, 120, 260, 30)];
    textaddress.tag=103;
    textaddress.borderStyle=UITextBorderStyleRoundedRect;
    textaddress.placeholder=@"安琪二楼餐厅(粗略地址)";
    [showInputView addSubview:textaddress];

    
    UITextField *textdeaiyaddress=[[UITextField alloc]initWithFrame:CGRectMake(20, 170, 260, 30)];
    textdeaiyaddress.tag=104;
    textdeaiyaddress.borderStyle=UITextBorderStyleRoundedRect;
    textdeaiyaddress.placeholder=@"广东省深圳市宝安区xx街道(详细地址)";
    [showInputView addSubview:textdeaiyaddress];
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 220, 70, 30)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.backgroundColor=[UIColor blackColor];
    leftBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftBtn addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [showInputView addSubview:leftBtn];

    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(210, 220,70, 30)];
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    rightBtn.backgroundColor=[UIColor blackColor];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(addBtn) forControlEvents:UIControlEventTouchUpInside];

    [showInputView addSubview:rightBtn];



}

%new
-(void)clickclose:(UITapGestureRecognizer *)recognizer
{
    UIView *grayView=recognizer.view;

    UIView *fuView=[grayView  superview];
    UIView *showInputView=[fuView viewWithTag:1001];

    [showInputView removeFromSuperview];
    [showInputView release];
    showInputView=nil;

    [grayView removeFromSuperview];
    [grayView release];
    grayView=nil;
    //还一个也要消失
}

%new
-(void)closeBtn
{
    UIView *grayView=[((UIViewController *)self).view viewWithTag:100];
    UIView *showInputView=[((UIViewController *)self).view viewWithTag:1001];
    [showInputView removeFromSuperview];
    [showInputView release];
    showInputView=nil;

    [grayView removeFromSuperview];
    [grayView release];
    grayView=nil;
}
%new 
-(void)addBtn
{
    UIView *showInputView1= [((UIViewController *)self).view viewWithTag:1001];
    UITextField *textla=[showInputView1 viewWithTag:101];
    UITextField *textlo=[showInputView1 viewWithTag:102];
    UITextField *textaddress=[showInputView1 viewWithTag:103];
    UITextField *textdeaiyaddress=[showInputView1 viewWithTag:104];
     if(nearByPOIs.count!=0)
     {
        AMapPOI *myobj=[nearByPOIs firstObject];

 
        AMapGeoPoint *myp=myobj.location;

        myp.longitude=[textlo.text doubleValue];;
        myp.latitude=[textla.text doubleValue];

        myobj.location=myp;
        myobj.gridcode=@"3414000520";
        myobj.adcode=@"440306";
        myobj.pcode=@"440000";
        myobj.uid=@"B0FFG9HACK";

         myobj.name=textaddress.text;
         myobj.province=@"广东省";
         myobj.city=@"深圳市";
         myobj.district=@"宝安区";// 这里没具体在界面展示，需要的自行配置咯
         myobj.address=textdeaiyaddress.text;

         [nearByPOITableView reloadData];
     }
     //不知道怎么调用 [self closeBtn]; copy

    UIView *grayView=[((UIViewController *)self).view viewWithTag:100];
    UIView *showInputView=[((UIViewController *)self).view viewWithTag:1001];
    [showInputView removeFromSuperview];
    [showInputView release];
    showInputView=nil;

    [grayView removeFromSuperview];
    [grayView release];
    grayView=nil;
}

%end

