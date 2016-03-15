//
//  ViewController.m
//  WeChatApliy
//
//  Created by dpfst520 on 15/12/1.
//  Copyright © 2015年 pengfei.dang. All rights reserved.
//

#import "ViewController.h"

#import "DdNetWork.h"

#import "WXApi.h"

@interface ViewController ()

@end

@implementation ViewController

//移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//监听通知
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([WXApi isWXAppInstalled])// 判断 用户是否安装微信
    {
        //监听一个通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"ORDER_PAY_NOTIFICATION" object:nil];
    }
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"微信支付";
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(50, 100, self.view.frame.size.width - 100, 60);
    payButton.backgroundColor = [UIColor lightGrayColor];
    [payButton setTitle:@"微信支付" forState:UIControlStateNormal];
    [payButton setImage:[UIImage imageNamed:@"payNow_weixin"] forState:UIControlStateNormal];
    [payButton setImageEdgeInsets:UIEdgeInsetsMake(5, -20, 0, 0)];
    payButton.layer.cornerRadius = 5;
    [payButton addTarget:self action:@selector(weChatPayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];

    
}

#pragma mark -- 微信支付
- (void)weChatPayAction:(UIButton *)sender
{
    /*
     
     *1、向自己服务器请求订单生成预支付订单信息
     
     */
    
    NSString *string = [NSString stringWithFormat:@""];
    [DdNetWork getRequestWithURLString:string Parameters:nil RequestHead:nil DataReturnType:DataReturnTypeData SuccessBlock:^(NSData *data) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSDictionary *dict = [resultDic objectForKey:@""];
        if (dict != nil) {
            NSMutableString *stamp = [dict objectForKey:@""];
            
            //生成预支付订单信息
            PayReq *rep    = [[PayReq alloc]init];    //
            
            /** 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录*/
            rep.openID     = [dict objectForKey:@""]; //
            
            /** 商家向财付通申请的商家id */
            rep.partnerId  = @"";
            
            /** 预支付订单 */
            rep.prepayId   = [dict objectForKey:@""];
            
            /** 随机串，防重发 */
            rep.nonceStr   = [dict objectForKey:@""];
            
            /** 时间戳，防重发 */
            rep.timeStamp  = stamp.intValue;
            
            /** 商家根据财付通文档填写的数据和签名 */
            rep.package    = [dict objectForKey:@""];
            
            /** 商家根据微信开放平台文档对数据做的签名 */
            rep.sign       = [dict objectForKey:@""];
       /*
        2、调起微信支付
        */
            if ([WXApi sendReq:rep]) {
                NSLog(@"调起成功。。。");
            } else {
                NSLog(@"调起失败。。。");
            }
            
        }
    } FailureBlock:^(NSError *error) {
        NSLog(@"error ---> %@", error);
    }];
}

#pragma mark -- 收到支付成功的消息做相应处理
- (void)getOrderPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"]) {
        NSLog(@"支付成功。。。");
    } else {
        NSLog(@"支付失败。。。");
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
