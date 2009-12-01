package
{
  import flash.display.Sprite;
  
  import twink.Twinkle;
  
  [SWF (width = 400, height = 400)]
  public class application extends Sprite
  {
    private var twinkle : Twinkle;
    
    private var sprite : Sprite;
    
    public function application()
    {
      twinkle = new Twinkle(stage);
      
      sprite = new Sprite;
      sprite.graphics.beginFill(0x000000);
      sprite.graphics.drawRect(0, 0, 25, 25);
      sprite.graphics.endFill();
      
      addChild(sprite);
      
      reset();
    }
    
    public function reset() : void
    {
      sprite.x = 0;
      sprite.y = 0;
      sprite.alpha = 1;
      
      twinkle.addTween
        (sprite,
          {
            delay: 1,
            time: 2,
            x: 150,
            y: 150,
            alpha: 0,
            transition: function (phase : Number) : Number
              {
                return phase * phase * phase / 3 + phase * phase * 2 / 3
              },
            onStart: function () : void { trace("Starting tween!"); },
            onUpdate: tracePhase,
            onComplete: reset
          });
    }
    
    public function tracePhase(phase : Number) : void
    { trace(phase); }
  }
}
