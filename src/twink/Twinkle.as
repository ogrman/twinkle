package twink
{
  import flash.display.Sprite;
  import flash.display.Stage;
  import flash.events.Event;
  import flash.utils.getTimer;
  
  import org.asspec.util.sequences.Sequence;
  
  public class Twinkle
  {
    private var queue : Sequence = Sequence.of();
    private var running : Sequence = Sequence.of();
    
    public function Twinkle(stage : Stage)
    { stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame); }
    
    public function addTween(target : Sprite, parameters : Object) : void
    {
      const time : Number = getTimer();
      const isDelayed : Boolean = parameters.delay != null;
      
      var startTime : Number;
      
      if (isDelayed)
        {
          startTime = time + parameters.delay * 1000;
          delete parameters.delay;
        }
      else
        startTime = time;
        
      const endTime : Number = startTime + parameters.time * 1000;
      
      const tween : Tween = new Tween(target, parameters, startTime, endTime);
      
      setupInitialParameters(tween);
      
      if (isDelayed)
        queue = queue.cons(tween);
      else
        running = running.cons(tween);
    }
    
    private function setupInitialParameters(tween : Tween) : void
    {
      const initialParameters : Object = new Object;
      
      for (var key : String in tween.parameters)
        {
          if (tween.target.hasOwnProperty(key))
            initialParameters[key] = tween.target[key];
        }
      
      tween.initialProperties = initialParameters;
    }
    
    private function handleEnterFrame(event : Event) : void
    {
      const time : Number = getTimer();
      
      updateQueued(time);
      updateRunning(time);
    }
    
    private function updateQueued(time : Number) : void
    {
      for (var i : int = 0; i < queue.length; ++i)
        {
          const tween : Tween = queue[i];
          
          if (time >= tween.startTime)
            {
              queue = queue.filter
                (function (queuedTween : Tween) : Boolean
                 { return queuedTween != tween; });
              
              running = running.cons(tween);
              if (tween.parameters.onStart)
                tween.parameters.onStart();
            }
        }
    }
    
    private function unqueueTween(tween : Tween) : void
    {
      queue = queue.filter
        (function (queuedTween : Tween) : Boolean
         { return queuedTween != tween; });
    }
    
    private function updateRunning(time : Number) : void
    {
      for (var i : int = 0; i < running.length; ++i)
        {
          const tween : Tween = running[i];
          const phase : Number = calculatePhase
            (tween.startTime, tween.endTime, time);
          
          if (phase < 1)
            updateTween(tween, phase);
          else
            finishTween(tween);
        }
    }
    
    private function calculatePhase
      (start : Number, end : Number, now : Number) : Number
    { return (now - start) / (end - start); }
    
    private function finishTween(tween : Tween) : void
    {
      running = running.filter
        (function (runningTween : Tween) : Boolean
        { return runningTween != tween; });
      
      updateTween(tween, 1);
      
      if (tween.parameters.onComplete)
        tween.parameters.onComplete();
    }
    
    private function updateTween
      (tween : Tween, phase : Number) : void
    {
      const target : Sprite = tween.target;
      const initialParameters : Object = tween.initialProperties;
      const parameters : Object = tween.parameters;
      
      const modifiedPhase : Number = tween.parameters.transition ?
        tween.parameters.transition(phase) : phase;
      
      for (var key : String in parameters)
        {
            if (target.hasOwnProperty(key))
            {
              const startValue : Number = initialParameters[key];
              const endValue : Number = parameters[key];
              
              target[key]
                = startValue + (endValue - startValue) * modifiedPhase;
            }
        }
      
      if (parameters.onUpdate)
        parameters.onUpdate(phase);
    }
  }
}
