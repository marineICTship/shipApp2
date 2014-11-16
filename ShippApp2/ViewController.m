//
//  ViewController.m
//  ShippApp2
//
//  Created by codepro on 2014/11/15.
//  Copyright (c) 2014年 FutureUniversityHakodate. All rights reserved.
//

#import "ViewController.h"
#import "CustomAnnotation.h"
#import "CustomOverlay.h"

@interface ViewController ()<MKMapViewDelegate>


@property (nonatomic, retain) MKMapView *mapView;


@end

@implementation ViewController
@synthesize myMapView;

//アプリ起動時に呼ばれる
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //mapCreate,readMarine,readShip,readBoatを読み込む
    [self createMap];
    [self readMarine];
    
    [self readShip];
    [self readBoat];
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
    NSString *path_mesh = [[NSBundle mainBundle] pathForResource:@"MeshChart" ofType:@"txt"];
    NSData *meshjson = [NSData dataWithContentsOfFile:path_mesh];
    NSMutableDictionary *meshjsonobj = [NSJSONSerialization JSONObjectWithData:meshjson options:0 error:nil];
    
    NSInteger meshsize = [meshjsonobj[@"MeshCharts"] count];
    for(int k = 0; k < meshsize; k++){
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
    NSString *path_marine = [[NSBundle mainBundle] pathForResource:@"MarineChart" ofType:@"txt"];
    NSData *marinejson = [NSData dataWithContentsOfFile:path_marine];
    NSMutableDictionary *marinejsonobj = [NSJSONSerialization JSONObjectWithData:marinejson options:0 error:nil];
    
    //ID0 海苔ヒビ 黄色(255,255,0)
    //ID1 浮標 アイコン(赤(255,0,0))
    //ID2 白(255,255,255)
    //ID3 防波堤 黒(0,0,0)
    //ID4 等深線 水色(51,158,255)
    //ID5 メッシュチャート (51,204,255)
    
    NSInteger marinesize = [marinejsonobj[@"MarineCharts"] count];
    UIImage *fuhyouimg = [UIImage imageNamed:@"fuhyou.gif"];
    for(int j = 0; j < marinesize; j++){
        NSString *ID = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"ID"];
        NSString *polygonID = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"polygonID"];
        NSString *fuhyoulat1 = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"latlngs"][0][0];
        NSString *fuhyoulon1 = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"latlngs"][0][1];
        CLLocationCoordinate2D fuhyou_point;
        fuhyou_point.latitude = fuhyoulat1.doubleValue;
        fuhyou_point.longitude = fuhyoulon1.doubleValue;
        //UIColor *sc = [UIColor colorWithRed:1.0 green:0.80 blue:1.00 alpha:1.0];;
        
        if(ID.integerValue == 1){
            
            NSString *marinelat60 = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"latlngs60"][0][0];
            NSString *marinelon60 = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"latlngs60"][0][1];
            
            
            CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinates:fuhyou_point newTitle:ID newSubTitle:ID newimg:fuhyouimg];
            [myMapView addAnnotation:annotation];
            

            
        }else{
            NSInteger size = [marinejsonobj[@"MarineCharts"][j][@"Marine"][@"latlngs"] count];
            //NSLog(@"[%@] [%@] [%@] [%@]",marine_lat1,marine_lat2,marine_lon1,marine_lon2);
            //NSLog(@"[%@] [%@] [%ld] ",marinelat1,marinelon1,size);
            //NSLog(@"[%d] [%@] [%@] [%ld] ",j,ID,polygonID,size);
            
            CLLocationCoordinate2D marine_point[size];
            for(int m = 0; m < size; m++){
                NSString *marinelat = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"latlngs"][m][0];
                NSString *marinelon = marinejsonobj[@"MarineCharts"][j][@"Marine"][@"latlngs"][m][1];
                marine_point[m] = CLLocationCoordinate2DMake(marinelat.doubleValue,marinelon.doubleValue);
            }
            MKPolyline *line = [MKPolyline polylineWithCoordinates:marine_point count:size];
            //CustomOverlay *annotation = [[CustomOverlay alloc] initWithCoordinates:marine_point withstroke:1.0 newstrokeColor:sc newcount:size];
            [myMapView addOverlay:line];
            
        }

    }
}


//船舶の(1分ごとに更新する必要のある)jsonデータを取得
- (void) readShip{
    //船舶jsonの取得
    
    //ログデータ
    NSString *path_ship = [[NSBundle mainBundle] pathForResource:@"ship" ofType:@"txt"];
    NSData *shipjson = [NSData dataWithContentsOfFile:path_ship];
    NSMutableDictionary *shipjsonobj = [NSJSONSerialization JSONObjectWithData:shipjson options:0 error:nil];
    
    
    /*NSURL *path = [NSURL URLWithString:@"http://175.184.26.216/ships.json"];
     NSURLRequest *request = [NSURLRequest requestWithURL:path];
     NSURLResponse *response;
     NSData *shipjson = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
     NSDictionary *shipjsonobj = [NSJSONSerialization JSONObjectWithData:shipjson options:0 error:nil];*/
    
    NSInteger shipsize = [shipjsonobj[@"ships"] count];
    UIImage *img = [UIImage imageNamed:@"ship_stop_icon_000.png"];

    //
    for(int i = 0; i < shipsize; i++){
        NSString *mmsi = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"mmsi"];
        NSString *imo = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"imo"];
        NSString *name = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"name"];
        NSString *callsign = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"callsign"];
        NSString *slat60 = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"latitude"];
        NSString *slon60 = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"longtude"];
        NSString *slat = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"latlng"][0];
        NSString *slon = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"latlng"][1];
        NSString *sspeed = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"speed"];
        NSString *scourse = shipjsonobj[@"ships"][i][@"Ship"][@"course"];
        //NSString *slength = shipjsonobj[@"ships"][i][@"Ship"][@"length"];
        //NSString *swidth = shipjsonobj[@"ships"][i][@"Ship"][@"width"];
        //NSString *sflag = shipjsonobj[@"ships"][i][@"Ship"][@"flag"];
        NSString *stime = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"timestamp"];
        NSString *shipicon;
        //NSLog(@"[%d] [%@] [%@] [%@] ",i,sspeed,callsign,scourse);
        double jsspeed = sspeed.doubleValue;
        
        //アイコンの設定
        if(jsspeed >= 1.0){
            NSString *shipicon00 = @"ship_icon_";
            NSString *shipicon0;
            NSString *radian;
            NSString *ipng = @".png";
            NSInteger iscourse = scourse.integerValue; //courseのままでは不可
            NSString *jscourse = [NSString stringWithFormat:@"%ld", iscourse];
            
            if(iscourse >= 0 && iscourse < 10){
                //文字列の結合 例 005,
                radian = [@"00" stringByAppendingString:jscourse];
            }else if(iscourse >= 10 && iscourse < 100){
                //文字列の結合 例 010
                radian = [@"0" stringByAppendingString:jscourse];
                
            }else if(iscourse >= 100 && iscourse < 360){
                radian = jscourse;
            }
            
            //文字列の結合
            shipicon0 = [shipicon00 stringByAppendingString:radian];//ship_icon_100
            shipicon = [shipicon0 stringByAppendingString:ipng];
            
        }else{
            shipicon = @"ship_stop_icon.png";
            
        }
        UIImage *shipimg = [UIImage imageNamed:shipicon];
        
        CLLocationCoordinate2D point;
        point.latitude = slat.doubleValue;
        point.longitude = slon.doubleValue;
        
        //MKPointAnnotation *pin = [[MKPointAnnotation alloc]init];
        //UIImage *img = [UIImage imageNamed:shipicon];
        //[pin setCoordinate:point];
        //pin.title = name;
        //pin.subtitle = stime;
        //[myMapView addAnnotation:pin];
        
        //CustomAnnotationクラスの初期化
        CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinates:point newTitle:name newSubTitle:stime newimg:shipimg];
        //annotationをマップに追加
        [myMapView addAnnotation:annotation];
    }
}

     /*MKPinAnnotationColor pincolor = MKPinAnnotationColorGreen;
     //UIImage *img = [UIImage imageNamed:@"ship_stop_icon_000.png"];
     CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(37, 136);
     NSString *title = @"たいとる";
     NSString *subTitle = @"さぶさぶさぶ";
    
    // CustomAnnotationクラスの初期化
    CustomAnnotation *aannotation = [[CustomAnnotation alloc] initWithCoordinates:locationCoordinate newTitle:title newSubTitle:subTitle newimg:img];
    // annotationをマップに追加
    [myMapView addAnnotation:aannotation];
      }*/
    


//漁船の(1分ごとに更新する必要のある)jsonデータを取得
- (void) readBoat{
    //ログデータ
    //NSString *path_boat = [[NSBundle mainBundle] pathForResource:@"boat" ofType:@"txt"];
    NSString *path_boat = [[NSBundle mainBundle] pathForResource:@"boat" ofType:@"txt"];
    NSData *boatjson = [NSData dataWithContentsOfFile:path_boat];
    NSMutableDictionary *boatjsonobj = [NSJSONSerialization JSONObjectWithData:boatjson options:0 error:nil];
    
    NSInteger boatsize = [boatjsonobj[@"boats"] count];
    //
    for(int p = 0; p < boatsize; p++){

        NSString *bid = boatjsonobj[@"boats"][p][@"Boat"][@"id"];
        NSString *blat60 = boatjsonobj[@"boats"][p][@"Boat"][@"latitude"];
        NSString *blon60 = boatjsonobj[@"boats"][p][@"Boat"][@"longitude"];
        NSString *bspeed = boatjsonobj[@"boats"][p][@"Boat"][@"speed"];
        NSString *bcourse = boatjsonobj[@"boats"][p][@"Boat"][@"course"];
        NSString *btime = boatjsonobj[@"boats"][p][@"Boat"][@"timestamp"];
        UIImage *boatimg;
        double jbspeed = bspeed.doubleValue;
        
        NSInteger mbsize = [boatjsonobj[@"boats"][p][@"Boat"][@"latlngs"] count]; //mark
        
        //if(){}一日以上経過していたらoutdata
        if(jbspeed >= 2.0){
            boatimg = [UIImage imageNamed:@"boat_move_icon.png"];
        }else{
            boatimg = [UIImage imageNamed:@"boat_stop_icon.png"];
        }
        
        NSString *bwlat = boatjsonobj[@"boats"][p][@"Boat"][@"latlngs"][mbsize - 1][0]; //wake
        NSString *bwlon = boatjsonobj[@"boats"][p][@"Boat"][@"latlngs"][mbsize - 1][1];
        
        CLLocationCoordinate2D bwpoint,bppoint[mbsize - 1];
        bwpoint.latitude = bwlat.doubleValue;
        bwpoint.longitude = bwlon.doubleValue;
        
        //CustomAnnotationを初期化
        CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinates:bwpoint newTitle:blat60 newSubTitle:blon60 newimg:boatimg];
        // annotationをマップに追加
        [myMapView addAnnotation:annotation];
        
        for(int q = 0; q < mbsize - 1; q++){
            NSString *bplat = boatjsonobj[@"boats"][p][@"Boat"][@"latlngs"][q][0]; //position
            NSString *bplon = boatjsonobj[@"boats"][p][@"Boat"][@"latlngs"][q][1];
            bppoint[q] = CLLocationCoordinate2DMake(bplat.doubleValue,bplon.doubleValue);
        }
        MKPolyline *line = [MKPolyline polylineWithCoordinates:bppoint count:mbsize - 1];
        //CustomOverlay *annotation = [[CustomOverlay alloc] initWithCoordinates:marine_point withstroke:1.0 newstrokeColor:sc newcount:size];
        [myMapView addOverlay:line];
    }
}


//線を引く際に呼ばれる
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineView *view = [[MKPolylineView alloc]initWithOverlay:overlay];
    
    //if([ line isKindOfClass:[ CustomOverlay class ]]){
        //view.strokeColor = [UIColor blueColor];
        view.strokeColor = [UIColor colorWithRed:0.20 green:0.80 blue:1.00 alpha:1.0];
        view.lineWidth = 0.5;
        myMapView.showsUserLocation = NO;
    //}
    return view;
}

// アノテーションが表示される時に呼ばれる
-(MKAnnotationView*)mapView:(MKMapView*)mapView
          viewForAnnotation:(id)annotation{
    
    static NSString *PinIdentifier = @"Pin";
    MKAnnotationView *av = (MKAnnotationView*)[myMapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
    
    if([ annotation isKindOfClass:[ CustomAnnotation class ]]){
        
        //if(av == nil){
        
        av = [[MKAnnotationView alloc]
              initWithAnnotation:annotation reuseIdentifier:PinIdentifier];
        //av.image = [UIImage imageNamed:@"ship_stop_icon_000.png"];  // アノテーションの画像を指定する
        //av.image = [UIImage imageNamed:@"fuhyou.gif"];
        av.image = ((CustomAnnotation*)annotation).img;//アノテーションの画像を指定する
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
