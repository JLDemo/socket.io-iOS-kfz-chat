//
//  KFZUserInfo.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/13.
//  Copyright © 2016年 kongfz. All rights reserved.
//

#import "KFZUserInfo.h"
#import "KFZLoginInfo.h"
#import "MJExtension.h"

@implementation KFZUserInfo

static KFZLoginInfo *user;

+ (KFZLoginInfo *)userInfo {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self getIMServerTestSuccess];
    });
    return user;
}

//取得消息 imServer
+ (void)getIMServerTestSuccess {
    NSString *urlString = @"http://message.kfz.com/Interface/User/getImsLoginInfo";
    
    //1.构造URL
    NSURL *url = [NSURL URLWithString:urlString];
    //2.构造Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //(1)设置为POST请求
    [request setHTTPMethod:@"POST"];
    
    //(2)超时
    [request setTimeoutInterval:60];
    
    //(4)设置请求体
    NSString *bodyStr = [NSString stringWithFormat:@"token=%@&device=IOS&appName=IOS_KFZ_COM&version=1.4.5",TOKEN];
    
    NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    //    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    //设置请求体
    [request setHTTPBody:bodyData];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //        NSLog(@"%@",data);
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        user = [KFZLoginInfo mj_objectWithKeyValues:dic[@"result"]];
    }];
    [task resume];
}

@end

























