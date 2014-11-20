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
#import "DetailTableViewController.h"
#import "AppDelegate.h"


@interface ViewController ()<MKMapViewDelegate>{

}

@property (nonatomic, retain) MKMapView *mapView;


@end

@implementation ViewController
@synthesize myMapView,colorjugde;

//@synthesize mmsi,imo,name,allsign,slat60,slon60,sspeed,scourse,stime;
//slength,swidth,flag



//アプリ起動時に呼ばれる
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the vie
    double a = 1.0;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate]; // デリゲート呼び出し
    appDelegate.AlphaJugde = &(a); // デリゲートプロパティに値代入
    
    
    //mapCreate,readMarine,readShip,readBoatを読み込む
    [self createMap];
    [self readMesh];
    [self readMarine];
    
    [self readShip];
    [self readBoat];
    [self readFishingNet];
    
    
    //現在時刻の取得
    NSDate *datetime = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSString *result = [fmt stringFromDate:datetime];  //表示するため文字列に変換する
    NSLog(@"%@", result);
    

    // タイマーを作成してスタート
    NSTimer *tm = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(hoge:) userInfo:nil repeats:YES];

}

// 呼ばれるhogeメソッド
-(void)hoge:(NSTimer*)timer{
    // ここに何かの処理を記述する
    // （引数の timer には呼び出し元のNSTimerオブジェクトが引き渡されてきます）
    [self refresh];
    
    [self readShip];
    [self readBoat];
    [self readMarine];
    
    int up = 1;
    NSLog(@"%d,Yes",up);
    up++;
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

//メッシュチャート
- (void) readMesh{
    //メッシュチャートの情報を取得
    /*NSURL *path_mesh = [NSURL URLWithString:@"http://175.184.26.216/MeshChart.json"];
    NSURLRequest *merequest = [NSURLRequest requestWithURL:path_mesh];
    NSURLResponse *response;
    NSData *meshjson = [NSURLConnection sendSynchronousRequest:merequest returningResponse:&response error:nil];
    NSDictionary *meshjsonobj = [NSJSONSerialization JSONObjectWithData:meshjson options:0 error:nil];*/
    
    //ログデータ
    NSString *path_mesh = [[NSBundle mainBundle] pathForResource:@"MeshChart" ofType:@"txt"];
     NSData *meshjson = [NSData dataWithContentsOfFile:path_mesh];
     NSMutableDictionary *meshjsonobj = [NSJSONSerialization JSONObjectWithData:meshjson options:0 error:nil];
    
    colorjugde = 28;
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

}

//海図情報の(1分ごとに更新する必要のない)jsonデータを取得
- (void) readMarine{
    
    //マリンチャートの情報を取得
    /*NSURL *path_marine = [NSURL URLWithString:@"http://175.184.26.216/MarineChart.json"];
    NSURLRequest *marequest = [NSURLRequest requestWithURL:path_marine];
    NSURLResponse *mresponse;
    NSData *marinejson = [NSURLConnection sendSynchronousRequest:marequest returningResponse:&mresponse error:nil];
    NSDictionary *marinejsonobj = [NSJSONSerialization JSONObjectWithData:marinejson options:0 error:nil];*/

    //ログデータ
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
            if(ID.integerValue == 0){
                colorjugde = ID.intValue;
            }else{
                colorjugde = ID.intValue + 23;
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
    CustomAnnotation *annotation = [CustomAnnotation alloc];
    
    //ログデータ
    /*NSString *path_ship = [[NSBundle mainBundle] pathForResource:@"ship" ofType:@"txt"];
    NSData *shipjson = [NSData dataWithContentsOfFile:path_ship];
    NSMutableDictionary *shipjsonobj = [NSJSONSerialization JSONObjectWithData:shipjson options:0 error:nil];
    */
    
    NSURL *path = [NSURL URLWithString:@"http://175.184.26.216/ships.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:path];
    NSURLResponse *response;
    NSData *shipjson = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSDictionary *shipjsonobj = [NSJSONSerialization JSONObjectWithData:shipjson options:0 error:nil];
    
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
            
            if(iscourse > 0 && iscourse < 10){
                //文字列の結合 例 005,
                radian = [@"00" stringByAppendingString:jscourse];
                
            }else if(iscourse >= 10 && iscourse < 100){
                //文字列の結合 例 010
                radian = [@"0" stringByAppendingString:jscourse];
                
            }else if(iscourse >= 100 && iscourse < 360){
                radian = jscourse;
                
            }else{
                radian = @"000";
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
        //CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinates:point newTitle:name newSubTitle:stime newimg:shipimg];
        annotation = [[CustomAnnotation alloc] initWithCoordinates:point newTitle:name newSubTitle:stime newimg:shipimg];
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
    /*NSURL *path_boat = [NSURL URLWithString:@"http://175.184.26.216/boats.json"];
    NSURLRequest *brequest = [NSURLRequest requestWithURL:path_boat];
    NSURLResponse *bresponse;
    NSData *boatjson = [NSURLConnection sendSynchronousRequest:brequest returningResponse:&bresponse error:nil];
    NSDictionary *boatjsonobj = [NSJSONSerialization JSONObjectWithData:boatjson options:0 error:nil];*/
    
    //ログデータ
    NSString *path_boat = [[NSBundle mainBundle] pathForResource:@"boat" ofType:@"txt"];
    NSData *boatjson = [NSData dataWithContentsOfFile:path_boat];
    NSMutableDictionary *boatjsonobj = [NSJSONSerialization JSONObjectWithData:boatjson options:0 error:nil];
    
    NSInteger boatsize = [boatjsonobj[@"boats"] count];
    
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
        
        NSString *under = @"_";
        NSString *bpng = @".png";
        NSString *radian;
        NSString *boaticon;
        NSInteger bicourse = bcourse.integerValue; //courseのままでは不可
        NSString *bscourse = [NSString stringWithFormat:@"%ld", bicourse];
        
        //アプリ内にpngファイルがある場合
        //if(){}一日以上経過していたらoutdata
        if(jbspeed >= 2.0){
            NSString *boat = @"boat";
            NSString *radian2;
            NSString *radian3;
            
            //文字列の結合 例 boat01,boat01_,boat01_1,boat01_1.png
            radian = [boat stringByAppendingString:bid];
            radian2 = [radian stringByAppendingString:under];
            radian3 = [radian2 stringByAppendingString:bscourse];
            //boaticon = [radian3 stringByAppendingString:bpng];//
            
            boaticon = @"boat_move_icon.png";//
        }else{
            NSString *boat = @"b";
            
            //文字列の結合 例 b01,b01.png
            radian = [boat stringByAppendingString:bid];
            //boaticon = [radian stringByAppendingString:bpng];//
            
            boaticon = @"boat_stop_icon.png";//
        }
        boatimg = [UIImage imageNamed:boaticon];
        //↑アプリ内にpngファイルがある場合
        
        //サーバからpngファイルを読み込む場合
        /*
        if(jbspeed >= 2.0){
            NSString *burl0 =  @"http://175.184.26.216/app/webroot/ship/ship_icon_";
            NSString *shipicon00;
            NSString *shipicon0;
            
            if(bicourse > 0 && bicourse < 10){
                //文字列の結合 例 005,
                radian = [@"00" stringByAppendingString:bscourse];
                
            }else if(bicourse >= 10 && bicourse < 100){
                //文字列の結合 例 010
                radian = [@"0" stringByAppendingString:bscourse];
                
            }else if(bicourse >= 100 && bicourse < 360){
                radian = bscourse;
                
            }else{
                radian = @"000";
            }
            
            //文字列の結合
            shipicon00 = [burl0 stringByAppendingString:radian];//ship_icon_100
            shipicon0 = [shipicon00 stringByAppendingString:bpng];
            boaticon = [shipicon0 stringByAppendingString:shipicon0];

        }else{
            boaticon =  @"http://175.184.26.216/app/webroot/ship/ship_icon_000.png";

        }
        NSURL *burl = [NSURL URLWithString:boaticon];
        NSData *bdata = [NSData dataWithContentsOfURL:burl];
        boatimg = [UIImage imageWithData:bdata];*/
        //↑サーバからpngファイルを読み込む場合
        
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
        colorjugde = bid.intValue;
        MKPolyline *line = [MKPolyline polylineWithCoordinates:bppoint count:mbsize - 1];
        //CustomOverlay *annotation = [[CustomOverlay alloc] initWithCoordinates:marine_point withstroke:1.0 newstrokeColor:sc newcount:size];
        [myMapView addOverlay:line];
    }
}

//漁網を表示
- (void)readFishingNet{
    /*NSURL *FNpath = [NSURL URLWithString:@"http://175.184.26.216/FishingNets.json"];
    NSURLRequest *FNrequest = [NSURLRequest requestWithURL:FNpath];
    NSURLResponse *FNresponse;
    NSData *FNjson = [NSURLConnection sendSynchronousRequest:FNrequest returningResponse:&FNresponse error:nil];
    NSDictionary *FNjsonobj = [NSJSONSerialization JSONObjectWithData:FNjson options:0 error:nil];*/
    
    //ログデータ
    NSString *path_FN = [[NSBundle mainBundle] pathForResource:@"fishNet" ofType:@"txt"];
    NSData *FNjson = [NSData dataWithContentsOfFile:path_FN];
    NSMutableDictionary *FNjsonobj = [NSJSONSerialization JSONObjectWithData:FNjson options:0 error:nil];
    
    NSInteger FNsize = [FNjsonobj[@"FishingNets"] count];
    
    for(int r = 0; r < FNsize; r++){
        NSString *FNid = FNjsonobj[@"FishingNets"][r][@"FishingNet"][@"id"];
        
        NSInteger FNllsize = [FNjsonobj[@"FishingNets"][r][@"FishingNet"][@"latlngs"] count];
        CLLocationCoordinate2D FNpoint[FNllsize];
        
        for(int s = 0; s < FNllsize; s++){
            NSString *FNlat = FNjsonobj[@"FishingNets"][r][@"FishingNet"][@"latlngs"][s][0];
            NSString *FNlon = FNjsonobj[@"FishingNets"][r][@"FishingNet"][@"latlngs"][s][1];
            FNpoint[s] = CLLocationCoordinate2DMake(FNlat.doubleValue,FNlon.doubleValue);
        }
        colorjugde = FNid.intValue;
        MKPolyline *line = [MKPolyline polylineWithCoordinates:FNpoint count:FNllsize];
        //CustomOverlay *annotation = [[CustomOverlay alloc] initWithCoordinates:marine_point withstroke:1.0 newstrokeColor:sc newcount:size];
        [myMapView addOverlay:line];
    }
}



//線を引く際に呼ばれる
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineView *view = [[MKPolylineView alloc]initWithOverlay:overlay];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]; // デリゲート呼び出し
    
    view.lineWidth = 1.0;
    view.strokeColor = appDelegate.ColorArray[colorjugde];

    
    myMapView.showsUserLocation = NO;
    
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
        UIButton *b = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        av.rightCalloutAccessoryView = b;
        
    }
    return av;
}

- (void) mapView:(MKMapView*)_mapView annotationView:(MKAnnotationView*)annotationView calloutAccessoryControlTapped:(UIControl*)control {
    // タップしたときの処理
    // annotationView.annotation でどのアノテーションか判定可能
    CustomAnnotation* pin = (CustomAnnotation*)annotationView.annotation;
    NSLog(@"title:%@",pin.subtitle);
    
    sename = pin.title;
    setime = pin.subtitle;
    //mmsi,imo,
    //,allsign,slat60,slon60,sspeed,scourse,stime;
    
    [self performSegueWithIdentifier:@"detail" sender:self];

}

//Segueが実行されると、実行直前に自動的に呼び出される
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Segueの特定
    if ( [[segue identifier] isEqualToString:@"detail"] ) {
        DetailTableViewController *nextViewController = [segue destinationViewController];
        //ここで遷移先ビューのクラスの変数receiveStringに値を渡している
        nextViewController.sename = sename;
        nextViewController.setime = setime;
    }
}

- (void)refresh{
    //CustomAnnotation *annotation = [CustomAnnotation alloc];
    [myMapView removeAnnotations: myMapView.annotations];
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
