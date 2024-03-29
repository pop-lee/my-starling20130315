/*
Copyright 2012-2013 Joshua Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package feathers.display
{
	import feathers.textures.Scale9Textures;

	import flash.errors.IllegalOperationError;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;
	import starling.utils.MatrixUtil;

	/**
	 * Scales an image with nine regions to maintain the aspect ratio of the
	 * corners regions. The top and bottom regions stretch horizontally, and the
	 * left and right regions scale vertically. The center region stretches in
	 * both directions to fill the remaining space.
	 */
	public class Scale9Image extends Sprite
	{
		/**
		 * @private
		 */
		private static const HELPER_MATRIX:Matrix = new Matrix();

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		private static var helperImage:Image;
		
		/**
		 * Constructor.
		 */
		public function Scale9Image(textures:Scale9Textures, textureScale:Number = 1)
		{
			super();
			this.textures = textures;
			this._textureScale = textureScale;
			this._hitArea = new Rectangle();
			this.readjustSize();

			this.addEventListener(Event.FLATTEN, flattenHandler);
		}

		/**
		 * @private
		 */
		private var _propertiesChanged:Boolean = true;

		/**
		 * @private
		 */
		private var _layoutChanged:Boolean = true;

		/**
		 * @private
		 */
		private var _renderingChanged:Boolean = true;
		
		/**
		 * @private
		 */
		private var _frame:Rectangle;

		/**
		 * @private
		 */
		private var _textures:Scale9Textures;

		/**
		 * The textures displayed by this image.
		 */
		public function get textures():Scale9Textures
		{
			return this._textures;
		}

		/**
		 * @private
		 */
		public function set textures(value:Scale9Textures):void
		{
			if(!value)
			{
				throw new IllegalOperationError("Scale9Image textures cannot be null.");
			}
			if(this._textures == value)
			{
				return;
			}
			this._textures = value;
			this._frame = this._textures.texture.frame;
			this._layoutChanged = true;
			this._renderingChanged = true;
		}

		/**
		 * @private
		 */
		private var _width:Number = NaN;
		
		/**
		 * @private
		 */
		override public function get width():Number
		{
			return this._width;
		}
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			if(this._width == value)
			{
				return;
			}
			this._width = this._hitArea.width = value;
			this._layoutChanged = true;
		}
		
		/**
		 * @private
		 */
		private var _height:Number = NaN;
		
		/**
		 * @private
		 */
		override public function get height():Number
		{
			return this._height;
		}
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			if(this._height == value)
			{
				return;
			}
			this._height = this._hitArea.height = value;
			this._layoutChanged = true;
		}
		
		/**
		 * @private
		 */
		private var _textureScale:Number = 1;
		
		/**
		 * The amount to scale the texture. Useful for DPI changes.
		 */
		public function get textureScale():Number
		{
			return this._textureScale;
		}
		
		/**
		 * @private
		 */
		public function set textureScale(value:Number):void
		{
			if(this._textureScale == value)
			{
				return;
			}
			this._textureScale = value;
			this._layoutChanged = true;
		}
		
		/**
		 * @private
		 */
		private var _smoothing:String = TextureSmoothing.BILINEAR;
		
		/**
		 * The smoothing value to pass to the images.
		 *
		 * @see starling.textures.TextureSmoothing
		 */
		public function get smoothing():String
		{
			return this._smoothing;
		}
		
		/**
		 * @private
		 */
		public function set smoothing(value:String):void
		{
			if(this._smoothing == value)
			{
				return;
			}
			this._smoothing = value;
			this._propertiesChanged = true;
		}

		/**
		 * @private
		 */
		private var _color:uint = 0xffffff;

		/**
		 * The color value to pass to the images.
		 */
		public function get color():uint
		{
			return this._color;
		}

		/**
		 * @private
		 */
		public function set color(value:uint):void
		{
			if(this._color == value)
			{
				return;
			}
			this._color = value;
			this._propertiesChanged = true;
		}

		/**
		 * @private
		 */
		private var _useSeparateBatch:Boolean = true;

		/**
		 * Determines if the regions are batched normally by Starling or if
		 * they're batched separately.
		 */
		public function get useSeparateBatch():Boolean
		{
			return this._useSeparateBatch;
		}

		/**
		 * @private
		 */
		public function set useSeparateBatch(value:Boolean):void
		{
			if(this._useSeparateBatch == value)
			{
				return;
			}
			this._useSeparateBatch = value;
			this._renderingChanged = true;
		}

		/**
		 * @private
		 */
		private var _hitArea:Rectangle;

		/**
		 * @private
		 */
		private var _batch:QuadBatch;

		/**
		 * @private
		 */
		private var _topLeftImage:Image;

		/**
		 * @private
		 */
		private var _topCenterImage:Image;

		/**
		 * @private
		 */
		private var _topRightImage:Image;

		/**
		 * @private
		 */
		private var _middleLeftImage:Image;

		/**
		 * @private
		 */
		private var _middleCenterImage:Image;

		/**
		 * @private
		 */
		private var _middleRightImage:Image;

		/**
		 * @private
		 */
		private var _bottomLeftImage:Image;

		/**
		 * @private
		 */
		private var _bottomCenterImage:Image;

		/**
		 * @private
		 */
		private var _bottomRightImage:Image;
		
		/**
		 * @private
		 */
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			if(!resultRect)
			{
				resultRect = new Rectangle();
			}
			
			var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;
			
			if (targetSpace == this) // optimization
			{
				minX = this._hitArea.x;
				minY = this._hitArea.y;
				maxX = this._hitArea.x + this._hitArea.width;
				maxY = this._hitArea.y + this._hitArea.height;
			}
			else
			{
				this.getTransformationMatrix(targetSpace, HELPER_MATRIX);

				MatrixUtil.transformCoords(HELPER_MATRIX, this._hitArea.x, this._hitArea.y, HELPER_POINT);
				minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
				maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
				minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
				maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

				MatrixUtil.transformCoords(HELPER_MATRIX, this._hitArea.x, this._hitArea.y + this._hitArea.height, HELPER_POINT);
				minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
				maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
				minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
				maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

				MatrixUtil.transformCoords(HELPER_MATRIX, this._hitArea.x + this._hitArea.width, this._hitArea.y, HELPER_POINT);
				minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
				maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
				minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
				maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

				MatrixUtil.transformCoords(HELPER_MATRIX, this._hitArea.x + this._hitArea.width, this._hitArea.y + this._hitArea.height, HELPER_POINT);
				minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
				maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
				minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
				maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;
			}
			
			resultRect.x = minX;
			resultRect.y = minY;
			resultRect.width  = maxX - minX;
			resultRect.height = maxY - minY;
			
			return resultRect;
		}
		
		/**
		 * @private
		 */
		override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			if(forTouch && (!this.visible || !this.touchable))
			{
				return null;
			}
			return this._hitArea.containsPoint(localPoint) ? this : null;
		}

		/**
		 * @private
		 */
		override public function flatten():void
		{
			this.validate();
			super.flatten();
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			this.validate();
			super.render(support, parentAlpha);
		}

		/**
		 * Readjusts the dimensions of the image according to its current
		 * textures. Call this method to synchronize image and texture size
		 * after assigning textures with a different size.
		 */
		public function readjustSize():void
		{
			this.width = this._frame.width * this._textureScale;
			this.height = this._frame.height * this._textureScale;
		}

		/**
		 * @private
		 */
		private function validate():void
		{
			this.refreshImages();
			if(this._propertiesChanged || this._layoutChanged || this._renderingChanged)
			{
				this.refreshBatch();

				const grid:Rectangle = this._textures.scale9Grid;
				const scaledLeftWidth:Number = grid.x * this._textureScale;
				const scaledTopHeight:Number = grid.y * this._textureScale;
				const scaledRightWidth:Number = (this._frame.width - grid.x - grid.width) * this._textureScale;
				const scaledBottomHeight:Number = (this._frame.height - grid.y - grid.height) * this._textureScale;
				const scaledCenterWidth:Number = this._width - scaledLeftWidth - scaledRightWidth;
				const scaledMiddleHeight:Number = this._height - scaledTopHeight - scaledBottomHeight;

				var image:Image;
				if(scaledTopHeight > 0)
				{
					if(this._useSeparateBatch)
					{
						image = helperImage;
						helperImage.texture = this._textures.topLeft;
						helperImage.readjustSize();
					}
					else
					{
						image = this._topLeftImage;
						image.smoothing = this._smoothing;
						image.color = this._color;
					}
					image.scaleX = image.scaleY = this._textureScale;
					image.x = scaledLeftWidth - image.width;
					image.y = scaledTopHeight - image.height;
					if(this._useSeparateBatch && scaledLeftWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					if(this._useSeparateBatch)
					{
						image = helperImage;
						helperImage.texture = this._textures.topCenter;
						helperImage.readjustSize();
					}
					else
					{
						image = this._topCenterImage;
						image.smoothing = this._smoothing;
						image.color = this._color;
					}
					image.scaleX = image.scaleY = this._textureScale;
					image.x = scaledLeftWidth;
					image.y = scaledTopHeight - image.height;
					image.width = scaledCenterWidth;
					if(this._useSeparateBatch && scaledCenterWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					if(this._useSeparateBatch)
					{
						image = helperImage;
						helperImage.texture = this._textures.topRight;
						helperImage.readjustSize();
					}
					else
					{
						image = this._topRightImage;
						image.smoothing = this._smoothing;
						image.color = this._color;
					}
					image.scaleX = image.scaleY = this._textureScale;
					image.x = this._width - scaledRightWidth;
					image.y = scaledTopHeight - image.height;
					if(this._useSeparateBatch && scaledRightWidth > 0)
					{
						this._batch.addImage(helperImage);
					}
				}

				if(scaledMiddleHeight > 0)
				{
					if(this._useSeparateBatch)
					{
						image = helperImage;
						helperImage.texture = this._textures.middleLeft;
						helperImage.readjustSize();
					}
					else
					{
						image = this._middleLeftImage;
						image.smoothing = this._smoothing;
						image.color = this._color;
					}
					image.scaleX = image.scaleY = this._textureScale;
					image.x = scaledLeftWidth - image.width;
					image.y = scaledTopHeight;
					image.height = scaledMiddleHeight;
					if(this._useSeparateBatch && scaledLeftWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					if(this._useSeparateBatch)
					{
						image = helperImage;
						helperImage.texture = this._textures.middleCenter;
						helperImage.readjustSize();
					}
					else
					{
						image = this._middleCenterImage;
						image.smoothing = this._smoothing;
						image.color = this._color;
					}
					image.scaleX = image.scaleY = this._textureScale;
					image.x = scaledLeftWidth;
					image.y = scaledTopHeight;
					image.width = scaledCenterWidth;
					image.height = scaledMiddleHeight;
					if(this._useSeparateBatch && scaledCenterWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					if(this._useSeparateBatch)
					{
						image = helperImage;
						helperImage.texture = this._textures.middleRight;
						helperImage.readjustSize();
					}
					else
					{
						image = this._middleRightImage;
						image.smoothing = this._smoothing;
						image.color = this._color;
					}
					image.scaleX = image.scaleY = this._textureScale;
					image.x = this._width - scaledRightWidth;
					image.y = scaledTopHeight;
					image.height = scaledMiddleHeight;
					if(this._useSeparateBatch && scaledRightWidth > 0)
					{
						this._batch.addImage(helperImage);
					}
				}

				if(scaledBottomHeight > 0)
				{
					if(this._useSeparateBatch)
					{
						image = helperImage;
						helperImage.texture = this._textures.bottomLeft;
						helperImage.readjustSize();
					}
					else
					{
						image = this._bottomLeftImage;
						image.smoothing = this._smoothing;
						image.color = this._color;
					}
					image.scaleX = image.scaleY = this._textureScale;
					image.x = scaledLeftWidth - image.width;
					image.y = this._height - scaledBottomHeight;
					if(this._useSeparateBatch && scaledLeftWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					if(this._useSeparateBatch)
					{
						image = helperImage;
						helperImage.texture = this._textures.bottomCenter;
						helperImage.readjustSize();
					}
					else
					{
						image = this._bottomCenterImage;
						image.smoothing = this._smoothing;
						image.color = this._color;
					}
					image.scaleX = image.scaleY = this._textureScale;
					image.x = scaledLeftWidth;
					image.y = this._height - scaledBottomHeight;
					image.width = scaledCenterWidth;
					if(this._useSeparateBatch && scaledCenterWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					if(this._useSeparateBatch)
					{
						image = helperImage;
						helperImage.texture = this._textures.bottomRight;
						helperImage.readjustSize();
					}
					else
					{
						image = this._bottomRightImage;
						image.smoothing = this._smoothing;
						image.color = this._color;
					}
					image.scaleX = image.scaleY = this._textureScale;
					image.x = this._width - scaledRightWidth;
					image.y = this._height - scaledBottomHeight;
					if(this._useSeparateBatch && scaledRightWidth > 0)
					{
						this._batch.addImage(helperImage);
					}
				}
			}

			this._propertiesChanged = false;
			this._layoutChanged = false;
			this._renderingChanged = false;
		}

		/**
		 * @private
		 */
		private function refreshImages():void
		{
			if(!this._renderingChanged || this._useSeparateBatch)
			{
				return;
			}
			if(this._topLeftImage)
			{
				this._topLeftImage.texture = this._textures.topLeft;
				this._topLeftImage.readjustSize();
			}
			else
			{
				this._topLeftImage = new Image(this._textures.topLeft);
				this.addChild(this._topLeftImage);
			}
			if(this._topCenterImage)
			{
				this._topCenterImage.texture = this._textures.topCenter;
				this._topCenterImage.readjustSize();
			}
			else
			{
				this._topCenterImage = new Image(this._textures.topCenter);
				this.addChild(this._topCenterImage);
			}
			if(this._topRightImage)
			{
				this._topRightImage.texture = this._textures.topRight;
				this._topRightImage.readjustSize();
			}
			else
			{
				this._topRightImage = new Image(this._textures.topRight);
				this.addChild(this._topRightImage);
			}
			if(this._middleLeftImage)
			{
				this._middleLeftImage.texture = this._textures.middleLeft;
				this._middleLeftImage.readjustSize();
			}
			else
			{
				this._middleLeftImage = new Image(this._textures.middleLeft);
				this.addChild(this._middleLeftImage);
			}
			if(this._middleCenterImage)
			{
				this._middleCenterImage.texture = this._textures.middleCenter;
				this._middleCenterImage.readjustSize();
			}
			else
			{
				this._middleCenterImage = new Image(this._textures.middleCenter);
				this.addChild(this._middleCenterImage);
			}
			if(this._middleRightImage)
			{
				this._middleRightImage.texture = this._textures.middleRight;
				this._middleRightImage.readjustSize();
			}
			else
			{
				this._middleRightImage = new Image(this._textures.middleRight);
				this.addChild(this._middleRightImage);
			}
			if(this._bottomLeftImage)
			{
				this._bottomLeftImage.texture = this._textures.bottomLeft;
				this._bottomLeftImage.readjustSize();
			}
			else
			{
				this._bottomLeftImage = new Image(this._textures.bottomLeft);
				this.addChild(this._bottomLeftImage);
			}
			if(this._bottomCenterImage)
			{
				this._bottomCenterImage.texture = this._textures.bottomCenter;
				this._bottomCenterImage.readjustSize();
			}
			else
			{
				this._bottomCenterImage = new Image(this._textures.bottomCenter);
				this.addChild(this._bottomCenterImage);
			}
			if(this._bottomRightImage)
			{
				this._bottomRightImage.texture = this._textures.bottomRight;
				this._bottomRightImage.readjustSize();
			}
			else
			{
				this._bottomRightImage = new Image(this._textures.bottomRight);
				this.addChild(this._bottomRightImage);
			}
		}

		/**
		 * @private
		 */
		private function refreshBatch():void
		{
			if(this._useSeparateBatch)
			{
				if(!this._batch)
				{
					this._batch = new QuadBatch();
					this._batch.touchable = false;
					this.addChild(this._batch);
				}
				if(this._topLeftImage)
				{
					this._topLeftImage.removeFromParent(true);
					this._topLeftImage = null;
				}
				if(this._topCenterImage)
				{
					this._topCenterImage.removeFromParent(true);
					this._topCenterImage = null;
				}
				if(this._topRightImage)
				{
					this._topRightImage.removeFromParent(true);
					this._topRightImage = null;
				}
				if(this._middleLeftImage)
				{
					this._middleLeftImage.removeFromParent(true);
					this._middleLeftImage = null;
				}
				if(this._middleCenterImage)
				{
					this._middleCenterImage.removeFromParent(true);
					this._middleCenterImage = null;
				}
				if(this._middleRightImage)
				{
					this._middleRightImage.removeFromParent(true);
					this._middleRightImage = null;
				}
				if(this._bottomLeftImage)
				{
					this._bottomLeftImage.removeFromParent(true);
					this._bottomLeftImage = null;
				}
				if(this._bottomCenterImage)
				{
					this._bottomCenterImage.removeFromParent(true);
					this._bottomCenterImage = null;
				}
				if(this._bottomRightImage)
				{
					this._bottomRightImage.removeFromParent(true);
					this._bottomRightImage = null;
				}
				this._batch.reset();

				if(!helperImage)
				{
					helperImage = new Image(this._textures.topLeft);
					helperImage.smoothing = this._smoothing;
					helperImage.color = this._color;
				}
			}
			else if(this._batch)
			{
				this._batch.removeFromParent(true);
				this._batch = null;
			}
		}

		/**
		 * @private
		 */
		private function flattenHandler(event:Event):void
		{
			this.validate();
		}
	}
}