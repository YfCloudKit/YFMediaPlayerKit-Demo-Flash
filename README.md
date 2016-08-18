### 直播播放SDK Web

### 简介
---
云帆视频加速是跨平台的视频解决方案，致力通过技术革新，打造视频专属的廉价CDN技术。使用云帆视频解决方案，可帮助企业用户建立一个优质高效的视频点播平台，涵盖PC、FLASH、Android、IOS以及OTT的业务支持。在使用户获得流畅的视觉享受的同时降低运营成本，并且客户版权内容能够得到严格的保障。

### 功能特点
---
- 	开放快播播放器技术，技术方案业内顶尖
- 	顶尖P2P技术积累，最大限度节省带宽，服务可用性大于95%
- 	支持市面主流CDN系统
- 	支持云帆自建Nginx、新型CDN加速
- 	兼容好，支持品牌订制
- 	支持点播服务
- 	支持H265云转码服务
- 	支持绝大多数视频格式（开放版本限flv,mp4格式，其它格式如hls等支持请联系云帆客服）

### 运行环境
---
涵盖所有操作系统上的全部浏览器



### 下载并使用SDK
---
### 1.SDK加载
- 确认YunfanSDK的地址，你可以将SDK放在自己的服务器上，
- 如果要加载来自云帆服务器的YunfanSDK，请与云帆客服联系。

```
private var YUNFAN_SDK:String = "http://yourdomain/path/Yunfan.swf";
var req:URLRequest = new URLRequest(YUNFAN_SDK);          
var context:LoaderContext = new LoaderContext(true,ApplicationDomain.currentDomain);
context.securityDomain = flash.system.SecurityDomain.currentDomain;
```

 #### 注意事项
你可以尝试获取sdk版本号，来验证sdk是否加载成功。

### 2.SDK Token鉴权
-   用户申请SDK对应的AccessKey和Token
-   实例化YunfanStream后,调用接口函数token,传入AccessKey和Token参数
-   鉴权成功，派发NetStatusEvent事件，状态码NetStream.Token.Success
-   鉴权失败，派发NetStatusEvent事件，状态码NetStream.Token.Failed
 
### 3.获取yunfanSDK版本号
-   静态属性：YunfanStream.VERSION
-   实例属性：yunfan.version
 
你可以将该版本号通过ContextMenu类添加至flash右键菜单中方便双方调试。
### 4.Yunfan.swf 使用示例
YunfanStream是从NetStream派生，对外提供了NetStream所有的属性、方法和事件，你完全可以按照NetStream类一样使用。
 
YunfanStream视频启动入口：

参数名 | 类型  |说明
---|---|---
vUrl |String|直播视频源地址 



#### 注意事项
YunfanStream会以该vUrl为标准匹配不同的视频码流（同一个视频不同码率也是不同的视频码流），如果贵方同一个视频流的vUrl有多个，请及时告知云帆并说明视频url哪一部分是可以唯一标识该视频流的。

使用示例：


```
//接上面的加载说明，从Yunfan.swf中获取YunfanStream 类
var YunfanStream:Class;
loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function():void{
YunfanStream = loader.contentLoaderInfo.applicationDomain.getDefinition("YunfanStream") as Class;        loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,arguments.callee);
});
 
//加载到YunfanStream 类后，实例化等操作
var yunfan:NetStream = new YunfanStream(netConnection);
yunfan.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
yunfan.client = this;   
yunfan.token(accessKey,tokenId)   // 需在调用play前，传入申请后的accessKey和tokenId
yunfan.play(vUrl); //开始play,sdk自动启动鉴权，通过则正常播放，失败则派发失败状态事件
video.attachNetStream(yunfan);
stage.addChild(video);
 
private function netStatusHandler(e:NetStatusEvent):void{
switch (e.info.code) {
        case "NetConnection.Connect.Success"://NetConnection连接成功
            break;
        case "NetStream.Play.StreamNotFound"://找不到视频流，请检查视频url或者网络
            break;
        case "NetStream.Play.Start"://视频启动播放。一次play()方法至多触发一次该事件。
            break;
        case "NetStream.Play.Stop"://视频停止播放。手动close不会触发该事件
            break;
        case "NetStream.Unpause.Notify"://暂停后恢复播放状态
            break;
        case "NetStream.Buffer.Full"://缓冲区已满，流开始播放
             break；
        case "NetStream.Pause.Notify"://暂停
            break;
        case "NetStream.Buffer.Empty":// 发起缓冲，因为接收数据的速度不足以填充缓冲区
            break;
        case "NetStream.Token.Success":// sdk鉴权通过，无需任何操作
            break;
         case "NetStream.Token.Failed":// sdk鉴权失败，请检查AccessKey和Token参数是否合法
            break;
    }
}  
public function onMetaData(info:Object):void{
    //从这里获取视频宽、高、时长、大小、关键帧等信息
}
```

#### 5.YunfanStream自定义事件
YunfanStream除了NetStream原生事件外，还实现了特有的事件（同样来自NetStatusEvent）:
  {code:'NetStream.SecurityError.843',value:data.ip}
视频服务器（包括CDN节点）的843端口服务未开启或者返回的843策略文件异常。value为对应服务器ip。
 
-   {code:'NetStream.NetWork.ContentRangeError',value:data.ip}      
视频服务器（包括CDN节点）不支持Range字段的HTTP分段请求。
value为对应服务器ip。
 
-   {code:'NetStream.IOError',value:data.ip}     
视频服务器（包括CDN节点）有异常错误。
value为对应服务器ip。
 
-   {code:'NetStream.CDN.StreamNotFound' }      
云帆加速CDN上找不到视频文件，当使用云帆加速CDN的时候请注意该事件。
当视频首次点播的时候，云帆CDN还没有cache到该视频，就找不到该文件，这时候会触发该事件，同时云帆CDN会去下载该视频。等下次点播，云帆CDN上有了该视频，就会从云帆CDN上下载视频。
 
-   {code:’NetStream.Token.Failed’}     
云帆加速SDK Token鉴权失败。需检查传入的AccessKey和Token值，有问题可联系工作人员
 
 
触发上述自定义事件的时候，你可以转向Netstream下载，并将YunfanStream的实例close关闭。
 
 
 
 