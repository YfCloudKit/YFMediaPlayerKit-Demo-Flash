package {
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.Event;
	
	public class NetStreamExample extends Sprite {
		private var videoURL:String = "rtmp://live.hkstv.hk.lxdns.com/live/hks";
//		private var videoURL:String = "http://demo.yunfancdn.com/video/Transformers4-trailer.mp4";
		private var connection:NetConnection;
		private var stream:NetStream;
		private var streamName:String = "";
		private var connectUrl:String = "";
		public function NetStreamExample() {
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.client = new CustomClient();
			play(videoURL);
		}
		private function play(url:String):void
		{
			if(url.indexOf("rtmp://") != -1 )  //rtmp流
			{
				var flag:int = url.lastIndexOf("/"); 
				connectUrl = url.substr(0,flag+1); 
				streamName = url.substr(flag + 1, url.length); 
			}
			else
			{
				connectUrl = url;  //http流
			}
			if(streamName == "")
				connection.connect(null)
			else
				connection.connect(connectUrl)	
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound":
					trace("Stream not found: " + videoURL);
					break;
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		
		private function connectStream():void {
			var stream:NetStream = new NetStream(connection);
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.client = new CustomClient();
			var video:Video = new Video(500,300);
			video.attachNetStream(stream);
			if(streamName == "")
				stream.play(connectUrl);
			else
				stream.play(streamName);
			addChild(video);
		}
	}
}

class CustomClient {
	public function onMetaData(info:Object):void {
		trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
	}
	public function onCuePoint(info:Object):void {
		trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
	}
	public function onXMPData(info:Object):void {
	}
	public function onBWDone():void
	{
	}
}
