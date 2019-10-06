class Util { 
    static public function Clamp(number:Float, min:Float, max:Float) { 
       return Math.max(min, Math.min(number, max));
    }
}