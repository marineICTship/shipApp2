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
    
    //mapCreate,readMarine,readShip]を読み込む
    [self createMap];
    //[self readMarine];
    [self readShip];
}

//マップの処理を書く
- (void) createMap{
    myMapView.delegate = self;
    
    MKCoordinateRegion region = myMapView.region;
    region.center.latitude = 34.551246;
    region.center.longitude = 135.188034;
    region.span.latitudeDelta = 0.5;
    region.span.longitudeDelta = 0.5;
    [myMapView setRegion:region animated:YES];
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
