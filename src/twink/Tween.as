package twink
{
  import flash.display.Sprite;
  
  public class Tween
  {
    private var _startTime : Number;
    private var _endTime : Number;

    private var _target : Sprite;
    private var _parameters : Object;
    
    public var initialProperties : Object;
    
    public function Tween
      (target : Sprite,
       parameters : Object,
       startTime : Number,
       endTime : Number)
    {
      _target = target;
      _parameters = parameters;
      _startTime = startTime;
      _endTime = endTime;
    }
    
    public function get target() : Sprite
    { return _target; }
    
    public function get parameters() : Object
    { return _parameters; }
    
    public function get startTime() : Number
    { return _startTime; }
    
    public function get endTime() : Number
    { return _endTime; }
  }
}
