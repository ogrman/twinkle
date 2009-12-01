package twink
{
  import flash.display.Sprite;
  
  public class TweenRequest
  {
    private var _length : Number;
    private var _delay : Number;
    private var _target : Sprite;
    private var _parameters : Object;
    //private var _callback : Function;
    
    public function TweenRequest
      (length : Number, delay : Number, target : Sprite, parameters : Object)
    {
      _length = length;
      _delay = delay;
      //_callback = callback;
      _target = target;
      _parameters = parameters;
    }
    
    public function get length() : Number
    { return _length; }
    
    public function get delay() : Number
    { return _delay; }
    
    public function get target() : Sprite
    { return _target; }
    
    public function get parameters() : Object
    { return _parameters; }
    
    //public function get callback() : Function
    //{ return _callback; }
  }
}
