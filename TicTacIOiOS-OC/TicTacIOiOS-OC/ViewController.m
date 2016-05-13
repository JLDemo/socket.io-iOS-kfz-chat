//
//  ViewController.m
//  TicTacIOiOS-OC
//
//  Created by kfz on 16/5/6.
//  Copyright © 2016年 kongfz. All rights reserved.
//  框架地址：https://github.com/socketio/socket.io-client-swift

#import "ViewController.h"
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>
#import "KFZLoginInfo.h"
#import "KFZSubChannels.h"
#import "MJExtension.h"
#import "AFNetWorking.h"
#import "KFZMessage.h"
#import "KFZUserInfo.h"
#import "KFZMsgTableViewCell.h"




@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) SocketIOClient *socket;
// ---------------------- socket
@property (strong, nonatomic) KFZSubChannels *subChannels;
@property (assign, nonatomic, getter=isTyping) BOOL typing;
@property (strong, nonatomic) SocketAckEmitter *ack;
@property (strong, nonatomic) KFZLoginInfo *loginInfo;
// --------------------- UI
@property (weak, nonatomic) UIRefreshControl *refresh;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ViewController
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (KFZSubChannels *)subChannels {
    if (!_subChannels) {
        _subChannels = [KFZUserInfo userInfo].subChannels;
    }
    return _subChannels;
}
- (KFZLoginInfo *)loginInfo {
    if (!_loginInfo) {
        _loginInfo = [KFZUserInfo userInfo];
    }
    return _loginInfo;
}
- (void)addRefresh {
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    _refresh = refresh;
    [self.tv addSubview:refresh];
    [refresh addTarget:self action:@selector(downRefresh) forControlEvents:UIControlEventValueChanged];
}
- (void)addNavigationItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空消息" style:UIBarButtonItemStylePlain target:self action:@selector(clearMessage)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
    self.tv.tableFooterView = [[UIView alloc] init];
    
    // add refresh
    [self addRefresh];
    [self addNavigationItem];
    
    [self getConnection:self.loginInfo.serverAddress];
}



////  参数转字典
- (NSDictionary *)paramsConvertIntoDictonary:(NSString *)paramString {
    NSArray *kvArray = [paramString componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (int i=0; i<kvArray.count; i++) {
        NSString *str = kvArray[i];
        NSArray *paramArray = [str componentsSeparatedByString:@"="];
        [params setValue:[paramArray lastObject] forKey:[paramArray firstObject]];
    }
//    [kvArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSArray *paramArray = [obj componentsSeparatedByString:@"="];
//        [params setValue:[paramArray lastObject] forKey:[paramArray firstObject]];
//    }];
    return params;
}

- (void)getConnection:(NSString *)address {
    NSArray *urlArray = [address componentsSeparatedByString:@"?"];
    NSString *urlString = [urlArray firstObject];
    NSString *paramStr = [urlArray lastObject];
    NSDictionary *params = [self paramsConvertIntoDictonary:paramStr];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];  //
    NSDictionary *options =
    @{@"log": @YES,
      @"forcePolling": @YES,
      @"forceWebsockets": @YES,
      @"VoipEnabled" : @YES,
      @"connectParams" : params
      };
    _socket = [[SocketIOClient alloc] initWithSocketURL:url options:options];
    
    //
    [_socket on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"==========================socket connected");
        [self listeningSubChannels];
        self.ack = ack;
    }];
    
    [self.socket on:@"reconnect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"==========================socket reconnect");
    }];
    [self.socket on:@"error" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"==========================socket error");
    }];
    [self.socket on:@"disconnect" callback:^(NSArray *data, SocketAckEmitter *ack) {
        NSLog(@"==========================disconnect");
    }];
    [_socket connect];
    
}


- (void)listeningSubChannels {
    KFZSubChannels *subChannels = self.subChannels;

    /// 提出客户端 ,注意拿到这条消息时，需要判断 socketId 是否为当前 socketId ，一致不处理，不一致提出
    [self.socket on:subChannels.kick callback:^(NSArray *array, SocketAckEmitter *ack) {
        NSLog(@"==========================kick");
    }];

    /// 发送新消息的时使用,发送新消息反馈通知
    [self.socket on:subChannels.kNewMessage callback:^(NSArray *array, SocketAckEmitter *ack) {
        NSDictionary *dic = [array firstObject];
        [self sendMessageSuccess:dic[@"result"]];
    }];
    
    // Typing
    [self.socket on:subChannels.typing callback:^(NSArray *array, SocketAckEmitter *ack) {
        [self addTyping:1034285];
    }];

    // 收到消息
    [self.socket on:subChannels.privateMsg callback:^(NSArray *array, SocketAckEmitter *ack) {
        [self receiveMessage:[array firstObject]];
    }];

    /// 联系人变动通知
    [self.socket on:subChannels.contact callback:^(NSArray *array, SocketAckEmitter *ack) {
        NSLog(@"==========================contacts");
    }];

    /// 选择对话用户时使用
    [self.socket on:subChannels.clientTalkId callback:^(NSArray *array, SocketAckEmitter *ack) {
        NSLog(@"==========================clientTalkId");
    }];

    [self.socket on:subChannels.notice callback:^(NSArray *array, SocketAckEmitter *ack) {
        NSLog(@"==========================notice");
    }];

    [self.socket on:subChannels.messageStateNotice callback:^(NSArray *array, SocketAckEmitter *ack) {
        NSLog(@"==========================messageStateNotice");
        KFZMessage *message = [self.dataSource lastObject];
        message.tipState = tipStatesFaile;
        [self.tv reloadData];
    }];


    [self.socket on:subChannels.broadcast callback:^(NSArray *array, SocketAckEmitter *ack) {
        NSLog(@"==========================broadcast");
    }];
}

#pragma -mark 监听方法
- (void)addTyping:(NSUInteger)typingUserId {
    if (self.isTyping) {
        return;
    }
    self.typing = YES;
    KFZMessage *msg = [KFZMessage messageWithTypingPhoto:self.receiverPhoto receiverNickname:self.receiverNickname];
    [self.dataSource addObject:msg];
    
    [self.tv reloadData];
}
- (void)receiveMessage:(NSDictionary *)dic {
    KFZMessage *msg = [KFZMessage mj_objectWithKeyValues:dic[@"result"]];
    msg.buddy = YES;
    KFZMessage *lastMessage = [self.dataSource lastObject];
    if (lastMessage && lastMessage.isTyping) {
        [self.dataSource removeLastObject];
    }
    [self.dataSource addObject:msg];
    [self.tv reloadData];
    self.typing = NO;
}

- (void)sendMessageSuccess:(NSDictionary *)result {
    KFZMessage *message = [KFZMessage mj_objectWithKeyValues:result];
    [self.dataSource removeLastObject];
    [self.dataSource addObject:message];
    [self.tv reloadData];
}

#pragma -mark 发送消息
- (IBAction)sendClicked:(UIButton *)sender {
    NSString *text = self.textField.text;
    [self sendMessage:self.ack];
    //
    KFZMessage *message = [KFZMessage messageWithTypingPhoto:[KFZUserInfo userInfo].photo receiverNickname:self.receiverNickname];
    message.typing = NO;
    message.buddy = NO;
    message.msgContent = text;
    message.sendTime = @"";
    message.tipState = tipStatesSend;
    [self.dataSource addObject:message];
    [self.tv reloadData];
}

- (void)sendMessage:(SocketAckEmitter *)ack {
    //    sender	发送者编号	true
    NSUInteger senderNum = self.loginInfo.userId;
    //    senderNickname
    NSString *senderNickname = self.loginInfo.nickname;
    //    receiver	接收者编号	true
    //    receiverNickname	接受者昵称	true
    //    msgContent	消息内容
    //    clientMsgId	客户端消息Id
    NSDate *date = [NSDate date];
    NSString *clientMsgId = [NSString stringWithFormat:@"%lf",[date timeIntervalSince1970]];
    
    NSDictionary *params = @{
                             @"sender" : @(senderNum),
                             @"senderNickname" : senderNickname,
                             @"receiver" : @(self.receiverNum),  //
                             @"receiverNickname" : self.receiverNickname,
                             @"msgContent" : self.textField.text,
                             @"clientMsgId" : clientMsgId  // clientMsgId
                             };
    NSArray *array = @[params];
    
    [self.socket emitWithAck:@"NEW_MESSAGE" withItems:array](0, ^(NSArray* data) {
        [self.socket emit:self.subChannels.kNewMessage withItems:array];
    });
    self.textField.text= nil;
}

- (void)sendTyping {
    NSDictionary *dic = @{
                          @"loginInfo" : @{
                                  @"typingUserId" : @(self.loginInfo.userId)
                                  },
                          @"status" : @"1"
                          };
    [self.socket emit:@"TYPING" withItems:@[dic]];
}


#pragma -mark tableView的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KFZMsgTableViewCell *cell = [KFZMsgTableViewCell msgTableViewCellWithTableView:tableView];
    KFZMessage *model = self.dataSource[indexPath.row];
    cell.message = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
    
}

#pragma -mark 通知方法
- (void)textChanged {
    self.sendButton.enabled = self.textField.text.length;
    
    // send typing
    [self sendTyping];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma -mark 消息记录接口
- (void)getContactMessage {
//    NSString *urlString = [SERVER stringByAppendingString:CONTACTMESSAGE];
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVER,CONTACTMESSAGE];
    NSString *urlString = @"http://message.kfz.com/Interface/Message/getContactMessage";
    static NSUInteger page = 1;
    NSDictionary *params = @{
                             @"token" : TOKEN,
                             @"contactId" : @(self.receiverNum),
                             @"page" : @(page++),
                             @"pageSize" : @PAGESIZE
                             };

    [KFZNet POST:urlString params:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary  *responseObject) {
        NSArray *result = responseObject[@"result"];
        NSMutableArray *modelArray = [KFZMessage mj_objectArrayWithKeyValuesArray:result];
        if (self.dataSource.count == 0) {
            self.dataSource = modelArray;
        }else {
            for (KFZMessage *m in modelArray) {
                [self.dataSource insertObject:m atIndex:0];
            }
        }
        
        [self.dataSource sortUsingComparator:^NSComparisonResult(KFZMessage *msg1, KFZMessage *msg2) {
            NSComparisonResult result = [msg1.sendTime compare:msg2.sendTime];
            return result;
        }];
        
        
        [self.tv reloadData];
        [self.refresh endRefreshing];
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.refresh endRefreshing];
    }];

}
#pragma -mark 清空消息记录
- (void)clearMessage {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER,CLEARMESSAGE];
    NSDictionary *params = @{
                             @"token" : TOKEN,
                             @"contactId" : @(self.receiverNum)
                             };
    
    [KFZNet POST:urlString params:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.dataSource = nil;
        [self.tv reloadData];
    } faile:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
    /*
     token	签名	true	注：web用户传空值
     contactId	联系人Id
     */
}

#pragma -mark 下拉刷新
- (void)downRefresh {
    [self getContactMessage];
}
@end







/*





 - (void)getConnection:(NSString *)address {
 NSURL *url = [[NSURL alloc] initWithString:address];  //@"http://localhost:8900"
 NSDictionary *options = @{@"log": @YES, @"forcePolling": @YES};
 _socket = [[SocketIOClient alloc] initWithSocketURL:url options:options];
 //
 [_socket on:@"connect" callback:^(NSArray *data, SocketAckEmitter *ack) {
 NSLog(@"==========================socket connected");
 }];
 [_socket on:@"currentAmount" callback:^(NSArray *data, SocketAckEmitter *ack) {
 double cur = [[data objectAtIndex:0] floatValue];
 
 [_socket emitWithAck:@"canUpdate" withItems:@[@(cur)]](0, ^(NSArray* data) {
 [_socket emit:@"update" withItems:@[@{@"amount": @(cur + 2.50)}]];
 });
 
 [ack with:@[@"Got your currentAmount, ", @"dude"]];
 }];
 [_socket connect];
 }


*/












