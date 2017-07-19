//
//  MapViewController.m
//  IOSMapDemo
//
//  Created by XHVR on 2017/7/14.
//  Copyright © 2017年 XHVR. All rights reserved.
//

#import "MapViewController.h"

// 实现服务和地图协议
@interface MapViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate>
@property (nonatomic,strong) BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *myMapView;

@property (nonatomic,strong) BMKLocationService *service;// 定位服务

@property (nonatomic,strong) BMKPoiSearch *poiSearch;//搜索服务
@property (nonatomic,strong) NSMutableArray *dataArray;

- (IBAction)search:(id)sender;


@end

@implementation MapViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(BMKPoiSearch*)poiSearch
{
    if (!_poiSearch) {
        _poiSearch = [[BMKPoiSearch alloc] init];
        //  设置代理为当前，否则接收不到搜索结果
        _poiSearch.delegate=self;
    }
    return _poiSearch;
}


// poi 搜索

- (IBAction)search:(UIButton*)sender {
    
    NSString *key=@"";
    switch(sender.tag)
    {
        case 0:
            key=@"地铁";
            break;
        case 1:
            key=@"学校";
            break;
        case 2:
            key=@"医院";
            break;
        case 3:
            key=@"超市";
            break;
    }
    
    
    BMKNearbySearchOption *opt=[[BMKNearbySearchOption alloc] init];
    opt.pageIndex=0;
    opt.pageCapacity=10;
    opt.radius=1000;// 搜索范围
    opt.location=CLLocationCoordinate2DMake(30.67, 104.06); // 或者从定位中获取
    opt.keyword=key;
    
    BOOL flag=[self.poiSearch poiSearchNearBy:opt];
    if(flag){
        NSLog(@"搜索成功");
    }else{
        NSLog(@"搜索失败");

    }
}

#pragma mark -------BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    //若搜索成功
    if (errorCode ==BMK_SEARCH_NO_ERROR) {
        // 清空前一次的结果和大头针
        
        [self.dataArray removeAllObjects];
        [self.mapView removeAnnotations:self.mapView.annotations];
        for (BMKPoiInfo *info in poiResult.poiInfoList) {
            [self.dataArray addObject:info];
            //初始化一个点的注释 //只有三个属性
            BMKPointAnnotation *annotoation = [[BMKPointAnnotation alloc] init];
            //坐标
            annotoation.coordinate = info.pt;
            //title
            annotoation.title = info.name;
            //子标题
            annotoation.subtitle = info.address;
            //将标注添加到地图上
            [self.mapView addAnnotation:annotoation];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 获得自身控件的矩形 设置autosizing 横向拉伸
    CGRect frame=_myMapView.frame;
    _mapView = [[BMKMapView alloc]initWithFrame:frame];
    
    // 缩放级别
    self.mapView.zoomLevel=18;
    
//    //  设置显示范围
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(30.67, 104.06);
//    BMKCoordinateSpan span = BMKCoordinateSpanMake(2, 2);
//    _mapView.limitMapRegion = BMKCoordinateRegionMake(center, span);////限制地图显示范围
//    _mapView.rotateEnabled = NO;//禁用旋转手势
    
    // 设置坐标点
//    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(30.67, 104.06)];
    
    // 添加到屏幕控件
    [self.view addSubview:_mapView];
    
    //  启动定位服务  注意虚拟器是否有设置经纬度 如果超出范围可能会只有蓝色点  或者加载很慢
    self.service=[[BMKLocationService alloc] init];
    self.service.delegate=self;
    [self.service startUserLocationService];
    
}

// 定位服务
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.mapView.showsUserLocation=YES;
    [self.mapView updateLocationData:userLocation];
    self.mapView.centerCoordinate=userLocation.location.coordinate;
    
    NSLog(@"定位的经度:%f,定位的纬度:%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
    
    self.mapView.zoomLevel=18;
    
    [self.service stopUserLocationService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
