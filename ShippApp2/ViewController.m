//
//  ViewController.m
//  ShippApp2
//
//  Created by codepro on 2014/11/15.
//  Copyright (c) 2014年 FutureUniversityHakodate. All rights reserved.
//

#import "ViewController.h"
#import "CustomAnnotation.h"

@interface ViewController ()<MKMapViewDelegate>


@property (nonatomic, retain) MKMapView *mapView;


@end

@implementation ViewController
@synthesize myMapView;

//アプリ起動時に呼ばれる
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //mapCreate,readMarine,readShipを読み込む
    [self createMap];
    [self readMarine];
    [self readShip];
}

//マップの処理
- (void) createMap{
    myMapView.delegate = self;
    
    MKCoordinateRegion region = myMapView.region;
    region.center.latitude = 34.551246;
    region.center.longitude = 135.188034;
    region.span.latitudeDelta = 0.5;
    region.span.longitudeDelta = 0.5;
    [myMapView setRegion:region animated:YES];
}

//メッシュチャート、海図情報の(1分ごとに更新する必要のない)jsonデータを取得
- (void) readMarine{
    
    //メッシュチャートの情報を取得
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"MeshChart" ofType:@"txt"];
    NSData *meshjson = [NSData dataWithContentsOfFile:path2];
    NSMutableDictionary *meshjsonobj = [NSJSONSerialization JSONObjectWithData:meshjson options:0 error:nil];
    
    for(int k = 0; k < 30; k++){
        CLLocationCoordinate2D coors[2];
        
        //NSString *lat1 = (NSString*)meshjsonobj[@"MeshCharts"][0][@"Mesh"][@"latlngs"][0][0];
        NSString *lat1 = meshjsonobj[@"MeshCharts"][k][@"Mesh"][@"latlngs"][0][0];
        NSString *lat2 = meshjsonobj[@"MeshCharts"][k][@"Mesh"][@"latlngs"][1][0];
        NSString *lon1 = meshjsonobj[@"MeshCharts"][k][@"Mesh"][@"latlngs"][0][1];
        NSString *lon2 = meshjsonobj[@"MeshCharts"][k][@"Mesh"][@"latlngs"][1][1];
        
        coors[0] = CLLocationCoordinate2DMake(lat1.floatValue, lon1.floatValue);
        coors[1] = CLLocationCoordinate2DMake(lat2.floatValue, lon2.floatValue);
        MKPolyline *line = [MKPolyline polylineWithCoordinates:coors count:2];
        [myMapView addOverlay:line];
    }
    
    //マリンチャートの情報を取得
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"MarineChart" ofType:@"txt"];
    NSData *marinejson = [NSData dataWithContentsOfFile:path3];
    NSMutableDictionary *marinejsonobj = [NSJSONSerialization JSONObjectWithData:marinejson options:0 error:nil];
    
    //ID0 海苔ヒビ 黄色(255,255,0)
    //ID1 浮標 アイコン(赤(255,0,0))
    //ID2 白(255,255,255)
    //ID3 防波堤 黒(0,0,0)
    //ID4 等深線 水色(51,158,255)
    //ID5 メッシュチャート (51,204,255)
    
    /*for(int j = 0; j < 20; j++){
        NSString *polygonID = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"polygonID"];
        if(polygonID.integerValue == 1){
            
        }else{
            
            NSString *marinelat1 = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"latlngs"][0][0];
            //NSString *marine_lat2 = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"latlngs"][1][0];
            NSString *marinelon1 = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"latlngs"][0][1];
            //NSString *marine_lon2 = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"latlngs"][1][1];
            //NSLog(@"[%@] [%@] [%@] [%@]",marine_lat1,marine_lat2,marine_lon1,marine_lon2);
            NSLog(@"[%@] [%@] ",marinelat1,marinelon1);
        }
    }*/
}


//船舶、漁船の(1分ごとに更新する必要のある)jsonデータを取得
- (void) readShip{
    //船舶jsonの取得
    //ログデータ
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ship" ofType:@"txt"];
    NSData *shipjson = [NSData dataWithContentsOfFile:path];
    NSMutableDictionary *shipjsonobj = [NSJSONSerialization JSONObjectWithData:shipjson options:0 error:nil];
    
    
    /*NSURL *path = [NSURL URLWithString:@"http://175.184.26.216/ships.json"];
     NSURLRequest *request = [NSURLRequest requestWithURL:path];
     NSURLResponse *response;
     NSData *shipjson = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
     NSDictionary *shipjsonobj = [NSJSONSerialization JSONObjectWithData:shipjson options:0 error:nil];*/
    
    UIImage *img = [UIImage imageNamed:@"ship_stop_icon_000.png"];
    //jsonファイルの格納
    for(int i = 0; i < 157; i++){
        NSString *mmsi = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"mmsi"];
        NSString *imo = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"imo"];
        NSString *name = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"name"];
        NSString *callsign = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"callsign"];
        NSString *lat = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"latlng"][0];
        NSString *lon = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"latlng"][1];
        NSString *speed = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"speed"];
        NSString *course = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"course"];
        NSString *time = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"timestamp"];
        NSString *shipicon;
        
        
        //アイコンの設定
        /*if(speed.integerValue >= 1){
            NSString *shipicon0 = @"ship_icon_";
            NSString *radian = @"00";
            NSString *radian2;
            NSString *radian3;
            
            //文字列の結合 例 005,00100
            radian2 = [radian stringByAppendingString:course];
            
            // 文字列の末尾から3文字を取り出す
            radian3 = [radian2 substringFromIndex:3];
            
            //文字列の結合
            shipicon = [shipicon0 stringByAppendingString:shipicon0];
            
        }else{
            shipicon = @"ship_stop_icon_000.png";
            
        }*/
        
        CLLocationCoordinate2D point;
        MKPointAnnotation *pin = [[MKPointAnnotation alloc]init];
        point.latitude = lat.doubleValue;
        point.longitude = lon.doubleValue;
        //UIImage *img = [UIImage imageNamed:shipicon];
        [pin setCoordinate:point];
        pin.title = name;
        pin.subtitle = time;
        [myMapView addAnnotation:pin];
        //CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinates:point newTitle:name newSubTitle:time newimg:img];
        // annotationをマップに追加
        //[myMapView addAnnotation:annotation];
    }
    
    /*MKPinAnnotationColor pincolor = MKPinAnnotationColorGreen;
     UIImage *img = [UIImage imageNamed:@"ship_stop_icon_000.png"];
     CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(41, 136);
     NSString *title = @"たいとる";
     NSString *subTitle = @"さぶさぶさぶ";*/
    
    // CustomAnnotationクラスの初期化
    //CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinates:locationCoordinate newTitle:title newSubTitle:subTitle newPinColor:&pincolor newimg:img];
    // annotationをマップに追加
    //[myMapView addAnnotation:annotation];
    
}

//線を引くとき呼ばれる
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineView *view = [[MKPolylineView alloc]initWithOverlay:overlay];
    //view.strokeColor = [UIColor blueColor];
    view.strokeColor = [UIColor colorWithRed:0.20 green:0.80 blue:1.00 alpha:1.0];
    view.lineWidth = 0.3;
    myMapView.showsUserLocation = NO;
    return view;
}

// アノテーションが表示される時に呼ばれる
-(MKAnnotationView*)mapView:(MKMapView*)mapView
          viewForAnnotation:(id)annotation{
    
    static NSString *PinIdentifier = @"Pin";
    MKAnnotationView *av = (MKAnnotationView*)[myMapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
    
    //if([ annotation isKindOfClass:[ CustomAnnotation class ]]){
        
        if(av == nil){
        
        av = [[MKAnnotationView alloc]
              initWithAnnotation:annotation reuseIdentifier:PinIdentifier];
        av.image = [UIImage imageNamed:@"ship_stop_icon_000.png"];  // アノテーションの画像を指定する
        //av.image = [UIImage imageNamed:@"fuhyou.gif"];
        //av.image = ((CustomAnnotation*)annotation).img;
        av.canShowCallout = YES;  // ピンタップ時にコールアウトを表示する
    }
    return av;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
