//
//  PDLanYaLianJie.m
//
//  Created by 彭懂 on 16/2/23.
//  Copyright © 2016年 彭懂. All rights reserved.
//

#import "PDLanYaLianJie.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

#define weak_Self(id) __weak typeof(id) weakSelf = id

#define channelOnPeropheralView @"peripheralView"
#define channelOnCharacteristicView @"CharacteristicView"

@interface PDLanYaLianJie ()

@property (nonatomic, strong) BabyBluetooth * babyTooth;
@property (nonatomic, strong) CBPeripheral * currPeripheral;
@property (nonatomic, strong) NSString * serviceName;
@property (nonatomic, strong) NSString * writeCharacterName;
@property (nonatomic, strong) NSString * notigyCharacterName;
@property (nonatomic, strong) CBService * service;
@property (nonatomic, strong) CBCharacteristic * curretCharacterist;
@property (nonatomic, assign) BOOL isLanYaLianJie;

@end

static PDLanYaLianJie *config = nil;
@implementation PDLanYaLianJie

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[PDLanYaLianJie alloc] init];
        config.isLanYaLianJie = YES;
    });
    return config;
}

- (void)deallocSharedLanYa
{
    self.isLanYaLianJie = NO;
    [self.babyTooth cancelScan];
    [self.babyTooth cancelAllPeripheralsConnection];
    self.lanYaStatus = NO;
}

- (void)cansaoXinHaoQiangduBegin
{
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(xinhaoQinagDu) userInfo:nil repeats:YES];
}

- (void)xinhaoQinagDu
{
    [self.currPeripheral readRSSI];
}

- (void)resameCanse
{
    [self.babyTooth cancelAllPeripheralsConnection];
    // 设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    self.babyTooth.scanForPeripherals().begin();
}

- (void)beginBlueToothWithDiverceName:(NSString *)diverceName
{
    [self.babyTooth cancelAllPeripheralsConnection];
    self.deviceName = diverceName;
    self.babyTooth = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegateInit];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    self.babyTooth.scanForPeripherals().begin();
}

- (void)linkLanYaDiverceBeginWithServiceName:(NSString *)serviceName writeCharacteristice:(NSString *)characterName andNotifyCharacteristice:(NSString *)notifyCharacteristice
{
    self.serviceName = serviceName;
    self.writeCharacterName = characterName;
    self.notigyCharacterName = notifyCharacteristice;
    [self linDiverceDelegate];
    self.babyTooth.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}

- (void)sendMessegeWithData:(NSData *)data
{
    if (!self.curretCharacterist || !self.currPeripheral) {
        NSLog(@"currPeripheral,curretCharacterist获取失败");
        return;
    }
    [self.currPeripheral writeValue:data forCharacteristic:self.curretCharacterist type:CBCharacteristicWriteWithResponse];
}

- (void)babyDelegateInit
{
    __weak typeof(self) weakSelf = self;
    // 蓝牙状态
    [self.babyTooth setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [weakSelf.pdDelegate LanYaIsOpen:YES];
        } else {
            [weakSelf.pdDelegate LanYaIsOpen:NO];
        }
    }];
    
    //设置扫描到设备的委托
    [self.babyTooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        if ([peripheral.name isEqualToString:weakSelf.deviceName]) {
            weakSelf.currPeripheral = peripheral;
            [weakSelf.babyTooth cancelScan];
            [weakSelf.pdDelegate LanYaFindDiverceNameIsSuccess:YES];
        } else {
        }
    }];
    [self.babyTooth setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        NSLog(@"sdafwe  %@", peripheral.name);
        
    }];
    
    // 设置查找设备的过滤器
    [self.babyTooth setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        // 设置查找规则是名称大于1 ， the search rule is peripheral.name length > 2
        if (peripheralName.length > 2) {
            return YES;
        }
        return NO;
    }];
    
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey: @YES};
    // 连接设备->
    [self.babyTooth setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
}

- (void)linDiverceDelegate
{
    __weak typeof(self) weakSelf = self;
    BabyRhythm * rhythm = [[BabyRhythm alloc] init];
    [self.babyTooth setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        
    }];
    
    [self.babyTooth setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        weakSelf.lanYaStatus = NO;
        if (weakSelf.isLanYaLianJie == NO) {
            return ;
        }
        [weakSelf.pdDelegate LanYaLianJieIsSuccess:NO];
    }];
    
    // 断开连接
    [self.babyTooth setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        weakSelf.lanYaStatus = NO;
        if (weakSelf.isLanYaLianJie == NO) {
            return ;
        }
        [weakSelf.pdDelegate LanYaLianJieIsSuccess:NO];
    }];
    
    [self.babyTooth setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        
        weakSelf.lanYaStatus = NO;
//        [weakSelf.pdDelegate LanYaLianJieIsSuccess:NO];
    }];
    
    // 设置发现设备的Services的委托
    [self.babyTooth setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        
        for (CBService *s in peripheral.services) {
            PDLog(@"发现设备的Services的委托  : %@     %@", s.UUID.UUIDString, weakSelf.serviceName);
            if ([s.UUID.UUIDString isEqualToString:weakSelf.serviceName]) {
                weakSelf.service = s;
            }
        }
        [rhythm beats];
    }];
    
    // 发现特性
    [self.babyTooth setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        PDLog(@"setBlockOnDiscoverCharacteristicsAtChannel  : %@,  %@", service.UUID.UUIDString, weakSelf.service.UUID.UUIDString);
        if ([weakSelf.service.UUID.UUIDString isEqualToString: service.UUID.UUIDString]) {
            for (int row = 0; row < service.characteristics.count; row++) {
                CBCharacteristic * characterist = [service.characteristics objectAtIndex:row];
                if ([characterist.UUID.UUIDString isEqualToString:weakSelf.writeCharacterName] || [characterist.UUID.UUIDString isEqualToString:weakSelf.notigyCharacterName]) {
                    if ([characterist.UUID.UUIDString isEqualToString:weakSelf.writeCharacterName]) {
                        weakSelf.curretCharacterist = characterist;
                    }
                    [weakSelf linkCharacteristicDelegate];
                    // 读取服务
                    weakSelf.babyTooth.channel(channelOnCharacteristicView).characteristicDetails(weakSelf.currPeripheral, characterist);
                    if ([characterist.UUID.UUIDString isEqualToString:weakSelf.notigyCharacterName]) {
                        CBCharacteristicProperties p = characterist.properties;
                        if (p & CBCharacteristicPropertyNotify) {
                            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:characterist];
                            [weakSelf.babyTooth notify:weakSelf.currPeripheral characteristic:characterist block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                                [weakSelf.pdDelegate LanYaReceiveMessegeData:characteristics.value];
                            }];
                        }
                    }
                }
            }
        }
    }];
    
    //读取rssi的委托
    [self.babyTooth setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        if ([weakSelf.pdDelegate respondsToSelector:@selector(LanYaXinHaoQiangDu:)]) {
            [weakSelf.pdDelegate LanYaXinHaoQiangDu:RSSI];
        }
    }];
    
    // characteristics信息读取
    [self.babyTooth setBlockOnReadValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        
    }];
    
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    [self.babyTooth setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
}

- (void)linkCharacteristicDelegate
{
    weak_Self(self);
    // 写入数据成功
    [self.babyTooth setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@    andsuccess  : %@  %zd",characteristic.UUID, characteristic.value, error, error.code);
    }];
    
    // 通知是否开启
    [self.babyTooth setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        weakSelf.lanYaStatus = YES;
        [weakSelf.pdDelegate LanYaLianJieIsSuccess:YES];
        NSLog(@"uid:%@,isNotifying:%@", characteristic.UUID, characteristic.isNotifying?@"on":@"off");
    }];
}

@end
