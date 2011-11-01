package
{
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageScaleMode;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;
    import flash.ui.Mouse;


    [SWF(frameRate="60", width="640", height="640")]
    public class LineDemo extends Sprite
    {
        private var canvas:Graphics;

        private var startP:CPoint = new CPoint();

        private var endP:CPoint = new CPoint(10, 10);

        private var step:uint = 16;

        private var path:Vector.<CPoint>;

        public function LineDemo()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;

            graphics.lineStyle(0, 0, 1, true);
            var command:Vector.<int> = new Vector.<int>();
            var coord:Vector.<Number> = new Vector.<Number>();
            var i:int = 0;
            var width:int = 640;

            for (i; i <= width; i += step)
            {
                command.push(1);
                coord.push(0, i);
                command.push(2);
                coord.push(width, i);

                command.push(1);
                coord.push(i, 0);
                command.push(2);
                coord.push(i, width);

            }

            graphics.drawPath(command, coord);

            var t:Shape = new Shape();
            addChild(t);
            canvas = t.graphics;

            stage.addEventListener(MouseEvent.MOUSE_DOWN, onmousedown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onmouseup);
            drawLine();
        }
		
		private function onmousedown(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onmousemove);
			onmousemove(e);
		}
		
		private function onmouseup(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onmousemove);
		}

        private function onmousemove(e:MouseEvent):void
        {
            var column:uint = this.mouseX / step;
            var row:uint = this.mouseY / step;

            if (e.ctrlKey)
            {
                startP.x = column;
                startP.y = row;
            }
            else
            {
                endP.x = column;
                endP.y = row;
            }

            drawLine();
        }

        private function drawLine():void
        {
			macro(startP.x, endP.x, startP.y, endP.y);

            canvas.clear();

            for (var i:int = 0; i < path.length; i++)
            {
                var p:CPoint = path[i];
                if (p.equals(startP))
                    canvas.beginFill(0xFF0000, p.alpha);
                else if (p.equals(endP))
                    canvas.beginFill(0x00FF00, p.alpha);
                else
                    canvas.beginFill(0x0000FF, p.alpha);

                canvas.drawRect(p.x * step, p.y * step, step, step);
                canvas.endFill();
            }

            canvas.lineStyle(0);
            canvas.moveTo(startP.x * step + step * 0.5, startP.y * step + step * 0.5);
            canvas.lineTo(endP.x * step + step * 0.5, endP.y * step + step * 0.5);
        }

        private function wuxiaolin(x0:int, x1:int, y0:int, y1:int):void
        {
            path = new Vector.<CPoint>();

            var threshold:Number = 0.2;
            var steep:Boolean = Math.abs(y1 - y0) > Math.abs(x1 - x0);
            var tmp:int;
            if (steep)
            {
                tmp = x0;
                x0 = y0;
                y0 = tmp;

                tmp = x1;
                x1 = y1;
                y1 = tmp;
            }
            if (x0 > x1)
            {
                tmp = x0;
                x0 = x1;
                x1 = tmp;

                tmp = y0;
                y0 = y1;
                y1 = tmp;
            }

            if (steep)
                path.push(new CPoint(y0, x0));
            else
                path.push(new CPoint(x0, y0));


            var gradient:Number = (y1 - y0) / (x1 - x0);
            var intery:Number = y0 + gradient;
            for (var x:int = x0 + 1; x <= x1 - 1; x++)
            {
                var rf:Number = 1 - intery % 1;
                var f:Number = intery % 1;
                if (steep)
                {
                    if (rf > threshold)
                        path.push(new CPoint(int(intery), x, rf));
                    if (f > threshold)
                        path.push(new CPoint(int(intery) + 1, x, f));
                }
                else
                {
                    if (rf > threshold)
                        path.push(new CPoint(x, int(intery), rf));
                    if (f > threshold)
                        path.push(new CPoint(x, int(intery) + 1, f));
                }
                intery = intery + gradient;
            }

            if (steep)
                path.push(new CPoint(y1, x1));
            else
                path.push(new CPoint(x1, y1));
        }

        private function bresenham(x0:int, x1:int, y0:int, y1:int):void
        {
            path = new Vector.<CPoint>();

            var steep:Boolean = Math.abs(y1 - y0) > Math.abs(x1 - x0);
            var tmp:int;
            if (steep)
            {
                tmp = x0;
                x0 = y0;
                y0 = tmp;

                tmp = x1;
                x1 = y1;
                y1 = tmp;
            }

            if (x0 > x1)
            {
                tmp = x0;
                x0 = x1;
                x1 = tmp;

                tmp = y0;
                y0 = y1;
                y1 = tmp;
            }

            var deltax:int = x1 - x0;
            var deltay:int = Math.abs(y1 - y0);
            var error:int = deltax / 2;

            var ystep:int = -1;
            if (y0 < y1)
                ystep = 1;

            var x:int = x0;
            var y:int = y0;

            for (; x <= x1; x++)
            {
                if (steep)
                    path.push(new CPoint(y, x));
                else
                    path.push(new CPoint(x, y));

                error = error - deltay;
                if (error < 0)
                {
                    y = y + ystep;
                    error = error + deltax;
                }

            }
        }

        private function macro(x0:int, x1:int, y0:int, y1:int):void
        {
            path = new Vector.<CPoint>();

            var steep:Boolean = Math.abs(y1 - y0) > Math.abs(x1 - x0);
            var tmp:int;
            if (steep)
            {
                tmp = x0;
                x0 = y0;
                y0 = tmp;

                tmp = x1;
                x1 = y1;
                y1 = tmp;
            }

            if (x0 > x1)
            {
                tmp = x0;
                x0 = x1;
                x1 = tmp;

                tmp = y0;
                y0 = y1;
                y1 = tmp;
            }

            var gradient:Number = Math.abs(y1 - y0) / (x1 - x0);
            var intery:Number = 0.5 + gradient * 0.5;
            var x:int = x0;
            var y:int = y0;
            var ystep:int = -1;
            if (y0 < y1)
                ystep = 1;

            for (; x <= x1; x++)
            {
                if (steep)
                    path.push(new CPoint(y, x));
                else
                    path.push(new CPoint(x, y));

                if (intery >= 1)
                {
                    intery %= 1;
                    y += ystep;
                    if (intery > 0)
                    {
                        if (steep)
                            path.push(new CPoint(y, x));
                        else
                            path.push(new CPoint(x, y));
                    }
                }
				intery += gradient;
            }
        }
    }
}