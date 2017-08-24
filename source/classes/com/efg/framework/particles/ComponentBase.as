import mx.events.EventDispatcher;

class com.eightbitrocket.fireworksengine.ComponentBase extends MovieClip {
	public function ComponentBase() {	
		EventDispatcher.initialize(this);
	}	
	public function Destroy() {
		this.removeMovieClip();
	}
	public function SetLocation(x:Number,y:Number) {
		this._x = x;
		this._y = y;
	}
	public function addEventListener(){/*Interface Stub*/}
	public function removeEventListener(){/*Interface Stub*/}
	public function dispatchEvent(){/*Interface Stub*/}	
}
