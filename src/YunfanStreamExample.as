package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	public class YunfanStreamExample extends Sprite
	{
		/**用户申请accessKey,该accessKey可能失效*/		
		private static const accessKey:String = "aabdb81eb4305f82d52e0f08044cd57d00ebdb9b"; 
		/**用户申请tokenId,该tokenId可能失效*/		
		private static const tokenId:String = "6c58938093e609ad0e497f627936050ec6ab8ecf";
		/**sdk下载地址*/		
		private static const sdkUrl:String = "sdk/Yunfan.swf";
		private var _loader:Loader;
		private var _yunfanClass:Class;
		private var _stream:*;
		public function YunfanStreamExample()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			sdkLoad();
		}
		/**
		 * 开始加载SDK 
		 */		
		private function sdkLoad():void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR ,errorHandler);
			var req:URLRequest = new URLRequest(sdkUrl);
				
			var context:LoaderContext = new LoaderContext(true,ApplicationDomain.currentDomain);
			 context.securityDomain = flash.system.SecurityDomain.currentDomain;//加载远程域的yunfan。swf要带上这句话
			 _loader.load(req); 
		}
		/**
		 * sdk加载完成
		 * @param evt
		 */	
		private function completeHandler(evt:Event):void
		{
			_yunfanClass = _loader.contentLoaderInfo.applicationDomain.getDefinition("YunfanStream") as Class;
			playStream();
		}
		/**
		 * 开始启动播放
		 */		
		private function playStream():void
		{
			var nc:NetConnection = new  NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
			nc.connect(null);
			_stream = new _yunfanClass(nc);  //实例化YunfanStream
			_stream.bufferTime = 2;  //指定缓冲区时长
			var video:Video = new Video();
			video.attachNetStream(_stream); 
			_stream.token(accessKey,tokenId)
			_stream.play("http://demo.yunfancdn.com/video/Transformers4-trailer.mp4");
			_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);		
			_stream.client = this;			
			this.addChild(video);
		}
		
		private function netStatusHandler(evt:NetStatusEvent):void
		{
			switch (evt.info.code)
			{
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
					break;
				case "NetStream.Pause.Notify"://暂停
					break;
				case "NetStream.Buffer.Empty":// 发起缓冲，因为接收数据的速度不足以填充缓冲区
					break;
				case "NetStream.Token.Success":// sdk鉴权通过，无需任何操作
					trace("evt.info.code",evt.info.code);
					break;
				case "NetStream.Token.Failed":// sdk鉴权失败，请检查AccessKey和Token参数是否合法
					trace("evt.info.code",evt.info.code);
					break;
			}
		}
		/**
		 * 获取视频元数据
		 * @param info
		 */		
		public function onMetaData(info:*):void
		{
			
		}
		/**
		 *sdk 加载出错
		 * @param evt
		 */		
		private function errorHandler(evt:Event):void
		{
			
		}
		
	}
}