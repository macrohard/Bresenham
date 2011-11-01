package
{
	import flash.geom.Point;
	
	public class CPoint extends Point
	{
		public var alpha:Number;
		
		public function CPoint(x:Number=0, y:Number=0, alpha:Number = 1)
		{
			super(x, y);
			this.alpha = alpha;
		}
	}
}