package;

import borris.BMath;
import borris.containers.*;
import borris.controls.*;
import borris.textures.*;
import borrisEngine.components.BRigidBody2D;
import borrisEngine.core.BEntity;
import borrisEngine.core.BEntityComponent;
import borrisEngine.core.BGame;
import borrisEngine.core.BLayer;
import borrisEngine.core.BScene;
import borrisEngine.ui.BStarlingInput;
import borrisEngine.utils.BSceneParser;

import openfl.Assets;
import openfl.display.*;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.net.FileReference;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;

import starling.core.Starling;
import starling.display.Image;

/**
 * ...
 * @author Rohaan Allport
 */
class LevelEditor
{
	public var game(get, set):BGame;
	public var sceneXML(get, set):Xml;
	public var selectedScene(get, set):BScene;
	public var selectedEntity(get, set):BEntity;
	
	
	public var renderSprite:Sprite;
	private var _gridHighlighter:Shape = new Shape();
	private var _entityHighlighter:Shape = new Shape();
	
	private var _container:DisplayObjectContainer;
	private var _toolsPanel:ToolsPanel;
	private var _hierarchyPanel:HierarchyPanel;
	@:allow(HierarchyPanel)
	private var _prpertiesPanel:PropertiesPanel;
	private var _layersPanel:LayersPanel;
	private var _assetsPanel:AssetsPanel;
	
	// map shit
	private var _mapEditMode:Bool = false;
	private var _lineOffset:Int = 0;
	private var _gridSize:Int = 64;
	private var _snapToGrid:Bool = true;
	private var _mode:String = "entity"; // different editing modes. enity, asset, component, layer, etc
	// TODO add functionality to remove entities, assets and componets
	// TODO pause gameply when going into map edit mode
	// TODO 
	
	// scene shit
	private var _game:BGame;
	private var _gameScenes:Array<BScene>;
	private var _selectedScene:BScene;
	//private var _selectedLayer:BLayer;
	private var _selectedEntity:BEntity;
	
	private var _sceneXML:Xml;
	
		

	public function new(container:DisplayObjectContainer) 
	{
		_container = container;
		
		_toolsPanel = new ToolsPanel();
		_hierarchyPanel = new HierarchyPanel();
		_prpertiesPanel = new PropertiesPanel();
		_layersPanel = new LayersPanel();
		_assetsPanel = new AssetsPanel();
		
		_toolsPanel._editor =
		_hierarchyPanel._editor =
		_prpertiesPanel._editor =
		_layersPanel._editor =
		_assetsPanel._editor = this;
		
		// add objects to respective containers
		_container.addChild(_toolsPanel);
		_container.addChild(_hierarchyPanel);
		_container.addChild(_prpertiesPanel);
		_container.addChild(_layersPanel);
		_container.addChild(_assetsPanel);
		
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	/**
	 * 
	 */
	public function update():Void
	{
		pan();
		
		// hold M and press Enter to activate Map edit mode
		if (BStarlingInput.keyIsDown(Keyboard.M) && BStarlingInput.keyPressed(Keyboard.ENTER))
		{
			_mapEditMode = !_mapEditMode;
			renderSprite.visible = _mapEditMode;
			drawGrid();
		} // end if
		
		if (_mapEditMode)
		{
			var xPos:Int = Std.int(BStarlingInput.touchPositionIn(_selectedScene).x) + _lineOffset;
			var yPos:Int = Std.int(BStarlingInput.touchPositionIn(_selectedScene).y) + _lineOffset;
			
			if (_snapToGrid)
			{
				xPos = Std.int(BStarlingInput.touchPositionIn(_selectedScene).x / _gridSize) * _gridSize + _lineOffset;
				yPos = Std.int(BStarlingInput.touchPositionIn(_selectedScene).y / _gridSize) * _gridSize + _lineOffset;
			} // end if
			
			_gridHighlighter.x = xPos;
			_gridHighlighter.y = yPos;
			
			if (_selectedEntity != null)
			{
				_entityHighlighter.x = _selectedEntity.x;
				_entityHighlighter.y = _selectedEntity.y;
			} // end if
			
			if(BStarlingInput.keyPressed(Keyboard.O))
			{
				//map1.parseXML(map1.bmapXML);
				//map1.drawLayers();
			} 
			
			// Insert a layer
			if(BStarlingInput.keyIsDown(Keyboard.INSERT) && BStarlingInput.keyPressed(Keyboard.L))
			{
				//map1.addXMLLayer("poop", Math.random() * 5);
			}
			
			// Delete a layer
			if(BStarlingInput.keyIsDown(Keyboard.DELETE) && BStarlingInput.keyPressed(Keyboard.L))
			{
				//map1.removeXMLLayer();
				//map1.redrawLayers();
			}
			
			// Inert a type of entity
			if(BStarlingInput.keyIsDown(Keyboard.E) && BStarlingInput.mousePressed)
			//if(BStarlingInput.keyIsDown(Keyboard.E) && BStarlingInput.mouseIsDown)
			{
				_selectedEntity = addEntity((xPos + _gridSize / 2), (yPos + _gridSize / 2));
				_hierarchyPanel.update(_selectedScene);
			} // end if
			
			if (BStarlingInput.keyIsDown(Keyboard.D) && BStarlingInput.mousePressed)
			{
				/*addDisplayObject(_selectedEntity, "industrial platforn 1-2-120000", Image, [
				["x", -32],
				["y", -32]
				//["rotation", Math.PI/4]
				]);
				
				addDisplayObject(_selectedEntity, "Sider unit 1 walking leg forward", starling.display.MovieClip, [
				["x", -32],
				["y", -32],
				["fps", 60]
				//["rotation", Math.PI/4]
				]);*/
				//_selectedEntity.
				addDisplayObject(_selectedEntity, _assetsPanel.seletedAssetName, Image, [
				["x", if(!_snapToGrid) Std.int(BStarlingInput.touchPositionIn(_selectedEntity).x) else Std.int(BStarlingInput.touchPositionIn(_selectedEntity).x / _gridSize) * _gridSize],
				["y", if(!_snapToGrid) Std.int(BStarlingInput.touchPositionIn(_selectedEntity).y) else Std.int(BStarlingInput.touchPositionIn(_selectedEntity).y / _gridSize) * _gridSize]
				]);
				
			} // end if

			//
			if (BStarlingInput.keyIsDown(Keyboard.C) && BStarlingInput.mousePressed)
			{
				addComponent(_selectedEntity, BRigidBody2D, [], [
				["type", "static"]
				]);
			} // end if
			
			// Move up or down a layer
			if (BStarlingInput.keyIsDown(Keyboard.E) && BStarlingInput.keyPressed(Keyboard.UP))
			{
				
			}
			else if (BStarlingInput.keyIsDown(Keyboard.E) && BStarlingInput.keyPressed(Keyboard.DOWN))
			{
				
			}
			
			// Save the file
			if(BStarlingInput.keyIsDown(Keyboard.CONTROL) && BStarlingInput.keyPressed(Keyboard.S))
			{
				//var file:FileReference = new FileReference();
				//file.save(map1.bmapXML, "Untitled.xml");
				
			}
			
			
		} // end if
		
		if(BStarlingInput.keyIsDown(Keyboard.CONTROL) && BStarlingInput.keyPressed(Keyboard.S))
		{
			//BSceneParser.createXML(selectedScene);
			var stringXML:String = BSceneParser.createXML(_selectedScene).toString();
			
			var file:FileReference = new FileReference();
			file.save(stringXML, "untitled.xml");
			
		}
		
		/*if (BStarlingInput.keyIsDown(Keyboard.LEFT))
		{
			_game.x += 10;
			renderSprite.x -= 10;
		}
		else if (BStarlingInput.keyIsDown(Keyboard.RIGHT))
		{
			_game.x -= 10;
			renderSprite.x += 10;
		}
		else if (BStarlingInput.keyIsDown(Keyboard.UP))
		{
			_game.y += 10;
			renderSprite.y -= 10;
		}
		else if (BStarlingInput.keyIsDown(Keyboard.DOWN))
		{
			_game.y -= 10;
			renderSprite.y += 10;
		}*/
		
	} // end function 
	
	
	/**
	 * 
	 */
	public function drawGrid():Void
	{
		renderSprite.graphics.clear();
		renderSprite.graphics.lineStyle(1, 0xffffff, 0.5);
			
		for(i in 0...100)
		{
			renderSprite.graphics.moveTo(_lineOffset, i * _gridSize + _lineOffset);
			renderSprite.graphics.lineTo(8000, i * _gridSize + _lineOffset);
		} // end for
		
		for(i in 0...100)
		{
			renderSprite.graphics.moveTo(i * _gridSize + _lineOffset, _lineOffset);
			renderSprite.graphics.lineTo(i * _gridSize + _lineOffset, 8000);
		} // end for
		
		_gridHighlighter.graphics.clear();
		_gridHighlighter.graphics.beginFill(0xffffff, 0.5);
		_gridHighlighter.graphics.drawRect(0, 0, _gridSize, _gridSize);
		_gridHighlighter.graphics.endFill();
		
		_entityHighlighter.graphics.clear();
		_entityHighlighter.graphics.beginFill(0xffffff, 0.5);
		_entityHighlighter.graphics.drawCircle(0, 0, 25);
		_entityHighlighter.graphics.beginFill(0xffffff, 1);
		_entityHighlighter.graphics.drawCircle(0, 0, 5);
		_entityHighlighter.graphics.endFill();
		
		renderSprite.addChild(_gridHighlighter);
		renderSprite.addChild(_entityHighlighter);
	} // end function
	
	/**
	 * 
	 */
	public function pan():Void
	{
		var posX:Float = 0;
		var posY:Float = 0;
		
		//posX = bodyToFollow.getWorldCenter().x * physScale;
		//posY = bodyToFollow.getWorldCenter().y * physScale;
		
		posX = _selectedScene.mainCamera.targetCam.x;
		posY = _selectedScene.mainCamera.targetCam.y;
		
		
		renderSprite.x = renderSprite.stage.stageWidth/2 - posX;
		renderSprite.y = renderSprite.stage.stageHeight / 2 - posY;
		
	} // end function 
	
	
	//********************************************************************************************
	
	
	/*public function addLayer():BLayer
	{
		
	} // end function
	
	
	public function delateLayer():BLayer
	{
		
	} // end function

	
	public function switchLayer():BLayer
	{
		
	} // end function*/

	
	public function addEntity(x:Float = 0, y:Float = 0):BEntity
	{
		var entity:BEntity = new BEntity();
		entity.x = x;
		entity.y = y;
		
		_selectedScene.addEntity(entity);
		
		return entity;
	} // end function
	
	
	/*public function selectEntity():BEntity
	{
		
	} // end function
	
	
	public function removeEntity():BEntity
	{
		
	} // end function
	*/
	
	public function addDisplayObject(entity:BEntity, nameOrPrefix:String, type:Class<starling.display.DisplayObject>, ?propertyArgs:Array<Array<Dynamic>>):starling.display.DisplayObject
	{
		var displayObject:starling.display.DisplayObject;// = Type.createInstance(type, [BGame.sAssets.getTexture(nameOrPrefix)]);
		var displayObject:starling.display.DisplayObject = null;
		switch(type)
		{
			case Image:
				displayObject = new Image(BGame.sAssets.getTexture(nameOrPrefix));
				
			case starling.display.MovieClip:
				displayObject = new starling.display.MovieClip(BGame.sAssets.getTextures(nameOrPrefix));
				Starling.current.juggler.add(cast(displayObject, starling.display.MovieClip));
				
			//case TextField:
				
		} // end switch
		
		entity.addChild(displayObject);
		
		// 
		for (field in propertyArgs)
		{
			field[0] = "set_" + field[0];
		} // end for
		
		// 
		for (field in Type.getInstanceFields(type))
		{
			for (i in 0...propertyArgs.length)
			{
				if (field == propertyArgs[i][0])
				{
					Reflect.setProperty(displayObject, propertyArgs[i][0].substring(4), propertyArgs[i][1]);
				}// end if
			} // end for
		} // end for
		
		return displayObject;
	} // end function
	
	
	/**
	 * 
	 * @param	entity
	 * @param	type
	 * @param	contructorArgs
	 * @param	fieldArgs
	 * @return
	 */
	public function addComponent(entity:BEntity, type:Class<BEntityComponent>, contructorArgs:Array<Dynamic>, ?propertyArgs:Array<Array<Dynamic>>):BEntityComponent
	{
		var component:BEntityComponent = Type.createInstance(type, contructorArgs);
		entity.addComponent(component);
		
		// 
		for (field in propertyArgs)
		{
			field[0] = "set_" + field[0];
		} // end for
		
		// 
		for (field in Type.getInstanceFields(type))
		{
			for (i in 0...propertyArgs.length)
			{
				if (field == propertyArgs[i][0])
				{
					Reflect.setProperty(component, propertyArgs[i][0].substring(4), propertyArgs[i][1]);
				}// end if
			} // end for
		} // end for
		
		return component;
	} // end function
	
	
	
	/*public function selectComponent():BEntityComponent
	{
		return component;
	} // end function*/
	
	//********************************************************************************************
	
	
	
	
	
	//**************************************** SET AND GET ******************************************
	
	private function get_game():BGame
	{
		return _game;
	}
	private function set_game(value:BGame):BGame
	{
		_game = value;
		return _game;
	}

	
	private function get_sceneXML():Xml
	{
		return _sceneXML;
	}
	private function set_sceneXML(value:Xml):Xml
	{
		return _sceneXML = value;
	}
	
	
	private function get_selectedEntity():BEntity
	{
		return _selectedEntity;
	}
	private function set_selectedEntity(value:BEntity):BEntity
	{
		_selectedEntity = value;
		_prpertiesPanel.update(_selectedScene);
		return _selectedEntity;
	} 
	
	
	private function get_selectedScene():BScene
	{
		return _selectedScene;
	} 
	private function set_selectedScene(value:BScene):BScene
	{
		_selectedScene = value;
		_hierarchyPanel.update(_selectedScene);
		_prpertiesPanel.update(_selectedScene);
		_layersPanel.update(_selectedScene);
		return _selectedScene;
	} 
	
	
	
}


// 

class LevelEditorPanel extends BPanel
{
	@:allow(LevelEditor)
	private var _editor:LevelEditor;
	
	public function new(title:String)
	{
		super(title);
		
	}
} // end class


class ToolsPanel extends LevelEditorPanel
{
	// containers
	private var _toolFlexContainer:BUIComponent;
	private var _snapFlexContainer:BUIComponent;
	private var _playbackFlexContainer:BUIComponent;
	private var _toolFlexBox:BFlexBox;
	private var _snapFlexBox:BFlexBox;
	private var _playbackFlexBox:BFlexBox;
	
	// assets
	private var _selectButton:BIconRadioButton;
	private var _imageButton:BIconRadioButton;
	private var _entityButton:BIconRadioButton;
	private var _physicsButton:BIconRadioButton;
	private var _05Button:BIconRadioButton;
	private var _06Button:BIconRadioButton;
	private var _07Button:BIconRadioButton;
	private var _08Button:BIconRadioButton;
	private var _09Button:BIconRadioButton;
	private var _10Button:BIconRadioButton;
	private var _110Button:BIconRadioButton;
	private var _120Button:BIconRadioButton;
	
	// 
	private var _panButton:BIconRadioButton;
	private var _zoonInButton:BIconRadioButton;
	private var _zoomOutButton:BIconRadioButton;
	
	// snapping
	private var _snapToGridButton:BIconRadioButton;
	private var _snapToObjectButton:BIconRadioButton;
	
	// playback
	private var _playButton:BIconRadioButton;
	private var _pauseButton:BIconRadioButton;
	private var _stopButton:BIconRadioButton;
	private var _rewindButton:BIconRadioButton;
	private var _fastForwardButton:BIconRadioButton;
	private var _skipToStartButton:BIconRadioButton;
	private var _skipToEndButton:BIconRadioButton;
	
	// button groups
	private var _toolGroup:BRadioButtonGroup;
	private var _snappingGroup:BRadioButtonGroup;
	private var _playbackGroup:BRadioButtonGroup;
	
	
	public function new()
	{
		super("Tools");
		
		setSize(80, 500);
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	private function playStateHandler(event:MouseEvent):Void 
	{
		if (event.currentTarget == _playButton)
		{
			//_editor.playGame();
		}
		else if (event.currentTarget == _pauseButton)
		{
			//_editor.pauseGame();
		}
		else if (event.currentTarget == _stopButton)
		{
			//_editor.stopGame();
		}
		
	} // end function
	
		
	//**************************************** FUNCTIONS ********************************************
	
	override private function initialize():Void
	{
		super.initialize();
		
		// initialize assets
		// containers
		_toolFlexContainer = new BUIComponent(content, 0, 0);
		_snapFlexContainer = new BUIComponent(content, 0, 0);
		_playbackFlexContainer = new BUIComponent(content, 0, 0);
		
		_toolFlexBox = new BFlexBox(BFlexBox.HORIZONTAL, _toolFlexContainer, 0, 0);
		_toolFlexBox.flexParent = this;
		_toolFlexBox.justify = BFlexBox.START;
		_toolFlexBox.wrap = BFlexBox.WRAP;
		//_toolFlexBox.style.backgroundColor = 0x660000;
		
		_snapFlexBox = new BFlexBox(BFlexBox.HORIZONTAL, _snapFlexContainer, 0, 0);
		_snapFlexBox.flexParent = this;
		_snapFlexBox.justify = BFlexBox.START;
		_snapFlexBox.wrap = BFlexBox.WRAP;
		//_snapFlexBox.style.backgroundColor = 0x006600;
		
		_playbackFlexBox = new BFlexBox(BFlexBox.HORIZONTAL, _playbackFlexContainer, 0, 0);
		_playbackFlexBox.flexParent = this;
		_playbackFlexBox.justify = BFlexBox.START;
		_playbackFlexBox.wrap = BFlexBox.WRAP;
		//_playbackFlexBox.style.backgroundColor = 0x000066;
		
		// UI
		_selectButton = cast(_toolFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Select")));
		_imageButton = cast(_toolFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Image")));
		_entityButton = cast(_toolFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Entity")));
		_physicsButton = cast(_toolFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Physics")));
		
		_panButton = cast(_toolFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Pan")));
		_zoonInButton = cast(_toolFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Zoom In")));
		_zoomOutButton = cast(_toolFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Zoom Out")));
		
		_snapToGridButton  = cast(_snapFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Snap to Grid")));
		_snapToObjectButton  = cast(_snapFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Snap to Object")));
		
		_playButton = cast(_playbackFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Play")));
		_pauseButton = cast(_playbackFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Pause")));
		_stopButton = cast(_playbackFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Stop")));
		_rewindButton = cast(_playbackFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Rewind")));
		_fastForwardButton = cast(_playbackFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Fast Forward")));
		_skipToStartButton = cast(_playbackFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Skip to Start")));
		_skipToEndButton  = cast(_playbackFlexBox.addItem(new BIconRadioButton(null, 0, 0, "Skip to End")));
		
		// groups
		_toolGroup = new BRadioButtonGroup("radio tool group");
		_snappingGroup = new BRadioButtonGroup("radio snapping group");
		_playbackGroup = new BRadioButtonGroup("radio playback group");
		
		_toolGroup.addRadioButton(_selectButton);
		_toolGroup.addRadioButton(_imageButton);
		_toolGroup.addRadioButton(_entityButton);
		_toolGroup.addRadioButton(_physicsButton);
		
		_snappingGroup.addRadioButton(_snapToGridButton);
		_snappingGroup.addRadioButton(_snapToObjectButton);
		
		_playbackGroup.addRadioButton(_playButton);
		_playbackGroup.addRadioButton(_pauseButton);
		_playbackGroup.addRadioButton(_stopButton);
		_playbackGroup.addRadioButton(_rewindButton);
		_playbackGroup.addRadioButton(_fastForwardButton);
		_playbackGroup.addRadioButton(_skipToStartButton);
		_playbackGroup.addRadioButton(_skipToEndButton);
		
		
		// setting the icons
		_selectButton.icon = new Bitmap(Assets.getBitmapData("graphics/select arrow.png"));
		_imageButton.icon = new Bitmap(Assets.getBitmapData("graphics/image icon 01 32x32.png"));
		_entityButton.icon = new Bitmap(Assets.getBitmapData("graphics/entity icon 32x32.png"));
		_physicsButton.icon = new Bitmap(Assets.getBitmapData("graphics/physics icon 01 32x32.png"));
		
		_panButton.icon = new Bitmap(Assets.getBitmapData("graphics/hand icon.png"));
		_zoonInButton.icon = new Bitmap(Assets.getBitmapData("graphics/zoom In icon 32x32.png"));
		_zoomOutButton.icon = new Bitmap(Assets.getBitmapData("graphics/zoom out icon 32x32.png"));
		
		_snapToGridButton.icon = new Bitmap(Assets.getBitmapData("graphics/snap to grid icon 01 32x32.png"));
		_snapToObjectButton.icon = new Bitmap(Assets.getBitmapData("graphics/snap to object icon 01 32x32.png"));
		
		_playButton.icon = new Bitmap(Assets.getBitmapData("graphics/play icon 32x32.png"));
		_pauseButton.icon = new Bitmap(Assets.getBitmapData("graphics/pause icon 32x32.png"));
		_stopButton.icon = new Bitmap(Assets.getBitmapData("graphics/stop icon 32x32.png"));
		_rewindButton.icon = new Bitmap(Assets.getBitmapData("graphics/rewind icon 32x32.png"));
		_fastForwardButton.icon = new Bitmap(Assets.getBitmapData("graphics/fast forward icon 32x32.png"));
		_skipToStartButton.icon = new Bitmap(Assets.getBitmapData("graphics/skip to start icon 32x32.png"));
		_skipToEndButton.icon = new Bitmap(Assets.getBitmapData("graphics/skip to end icon 32x32.png"));
		
		
		// event handling
		_playButton.addEventListener(MouseEvent.CLICK, playStateHandler);
		
	} // end function
	
	
	
	
	override private function positionAssets():Void
	{
		super.positionAssets();
		
		if (_toolFlexContainer != null) 
		{
			_toolFlexContainer.setSize(_width - _padding * 2, 12500 / (_width - _padding * 2));
			if (_toolFlexContainer.height < 30)
			{
				_toolFlexContainer.height = 30;
			}
		}
		if (_snapFlexContainer != null && _toolFlexContainer != null) 
		{
			_snapFlexContainer.setSize(_width - _padding * 2, 7000 / (_width - _padding * 2)); 
			_snapFlexContainer.y = _toolFlexContainer.y + _toolFlexContainer.height;
			if (_snapFlexContainer.height < 30)
			{
				_snapFlexContainer.height = 30;
			}
		}
		if (_playbackFlexContainer != null && _snapFlexContainer != null) 
		{
			_playbackFlexContainer.setSize(_width - _padding * 2, 10000 / (_width - _padding * 2));
			_playbackFlexContainer.y = _snapFlexContainer.y + _snapFlexContainer.height;
			if (_playbackFlexContainer.height < 30)
			{
				_playbackFlexContainer.height = 30;
			}
		}
		
	} // end function
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
} // end class


class HierarchyPanel extends LevelEditorPanel
{
	private var _layerAccordian:BAccordion;
	
	
	public function new()
	{
		super("Hierarchy");
		
		setSize(300, 500);
		
		
		_layerAccordian = new BAccordion(content, 0, 0);
		
		// event handling
		
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	private function entityChangeHandler(event:Event):Void 
	{
		_editor.selectedEntity = cast(cast(event.currentTarget, BList).selectedItem.data);
		//_editor._prpertiesPanel.update(_editor.selectedScene);
	} // end function
		
		
	//**************************************** FUNCTIONS ********************************************
	
	
	override private function positionAssets():Void
	{
		super.positionAssets();
		
		if (_layerAccordian != null) _layerAccordian.width = _width - _padding * 2; 
	} // end function
	
	
	public function update(scene:BScene):Void
	{
		_layerAccordian.removeAll();
		
		// repopulate the BAccordion
		for (i in 0..._editor.selectedScene.numLayers)
		{
			var layer = _editor.selectedScene.getLayerAt(i);
			var details:BDetails = _layerAccordian.addDetails(new BDetails(layer.name));
			details.indent = 20;
			
			var entityList:BList = new BList();
			entityList.width = _layerAccordian.width - 20;
			entityList.height = 20;
			entityList.rowHeight = 20;
			entityList.numRowsToShow = 1;
			entityList.autoSize = true;
			details.addItem(entityList);
			
			entityList.addEventListener(Event.CHANGE, entityChangeHandler);
			
			//for (j in 0...5)
			for(j in 0...layer.numEntities)
			{
				var entity:BEntity = layer.getEntityAt(j);
				/*var button = new BButton(null, 0, (j * 20), (if (entity.name != null) entity.name; else "null" ));
				button.autoSize = false;
				button.setSize(400, 20);
				button.toggle = true;
				button.setStateAlphas(0, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5);
				details.addItem(button);*/
				
				entityList.addItem( {label: if (entity.name != null) entity.name; else "null", data: entity } );
			} // end for
			
		} // end for
		
	} // end function
	
	
	
	
	//**************************************** SET AND GET ******************************************
	
} // end class


class PropertiesPanel extends LevelEditorPanel
{
	private var _objectNameLabel:BLabel;
	private var _objectTypeLabel:BLabel;
	private var _objectXPosLabel:BLabel;
	private var _objectYPosLabel:BLabel;
	private var _objectWidthLabel:BLabel;
	private var _objectHeightLabel:BLabel;
	private var _objectScaleXLabel:BLabel;
	private var _objectScaleYLabel:BLabel;
	private var _objectRotationLabel:BLabel;
	
	private var _objectNameTextInput:BTextInput;
	
	private var _objectXPosNS:BNumericStepper;
	private var _objectYPosNS:BNumericStepper;
	private var _objectWidthNS:BNumericStepper;
	private var _objectHeightNS:BNumericStepper;
	private var _objectScaleXNS:BNumericStepper;
	private var _objectScaleYNS:BNumericStepper;
	private var _objectRotationNS:BNumericStepper;
	
	private var _propCategoryAccordion:BAccordion;
	private var _spritesAccordion:BAccordion;
	private var _componentsAccordion:BAccordion;
	
	// other
	private var _assetUIArray:Array<Dynamic>;
	
	public function new()
	{
		super("Properties");
		
		setSize(300, 500);
		
		_propCategoryAccordion = new BAccordion(content, 0, 60);
		var _posAndSizeDetails:BDetails = new BDetails("POSITION AND SIZE");
		var _assetsDetails:BDetails = new BDetails("ASSETS");
		var _componentsDetails:BDetails = new BDetails("COMPONENTS");
		_propCategoryAccordion.addDetails(_posAndSizeDetails);
		_propCategoryAccordion.addDetails(_assetsDetails);
		_propCategoryAccordion.addDetails(_componentsDetails);
		for (details in _propCategoryAccordion.details)
		{
			details.indent = 30;
		} // end for
		
		_objectNameLabel = new BLabel(content, 0, 0, "Name: ");
		_objectTypeLabel = new BLabel(content, 0, 30, "Type: ");
		_objectXPosLabel = new BLabel(null, 0, 0, "X: ");
		_objectYPosLabel = new BLabel(null, 220, 0, "Y: ");
		_objectWidthLabel = new BLabel(null, 0, 30, "Width: ");
		_objectHeightLabel = new BLabel(null, 220, 30, "Height: ");
		_objectScaleXLabel = new BLabel(null, 0, 60, "Scale X: ");
		_objectScaleYLabel = new BLabel(null, 220, 60, "Scale Y: ");
		_objectRotationLabel = new BLabel(null, 0, 90, "Rotation: ");
		
		_objectTypeLabel.width = 400;
		
		_objectNameTextInput = new BTextInput(content, 80, 0, "");
		
		_objectXPosNS = new BNumericStepper(null, 100, 0);
		_objectYPosNS = new BNumericStepper(null, 320, 0);
		_objectWidthNS = new BNumericStepper(null, 100, 30);
		_objectHeightNS = new BNumericStepper(null, 320, 30);
		_objectScaleXNS = new BNumericStepper(null, 100, 60);
		_objectScaleYNS = new BNumericStepper(null, 320, 60);
		_objectRotationNS = new BNumericStepper(null, 100, 90);
		
		for (ns in [_objectXPosNS, _objectYPosNS, _objectWidthNS, _objectHeightNS, _objectScaleXNS, _objectScaleYNS, _objectRotationNS])
		{
			ns.buttonPlacement = BPlacement.LEFT;
			ns.maximum = 10000;
			ns.minimum = -10000;
		} // end for
		
		_objectRotationNS.maximum = 360;
		_objectRotationNS.minimum = -180;
		
		
		_spritesAccordion = new BAccordion(null, 0, 0);
		_componentsAccordion = new BAccordion(null, 0, 0);
		
		
		// add assets to respective containers
		_posAndSizeDetails.addItem(_objectXPosLabel);
		_posAndSizeDetails.addItem(_objectYPosLabel);
		_posAndSizeDetails.addItem(_objectWidthLabel);
		_posAndSizeDetails.addItem(_objectHeightLabel);
		_posAndSizeDetails.addItem(_objectScaleXLabel);
		_posAndSizeDetails.addItem(_objectScaleYLabel);
		_posAndSizeDetails.addItem(_objectRotationLabel);
		
		_posAndSizeDetails.addItem(_objectXPosNS);
		_posAndSizeDetails.addItem(_objectYPosNS);
		_posAndSizeDetails.addItem(_objectWidthNS);
		_posAndSizeDetails.addItem(_objectHeightNS);
		_posAndSizeDetails.addItem(_objectScaleXNS);
		_posAndSizeDetails.addItem(_objectScaleYNS);
		_posAndSizeDetails.addItem(_objectRotationNS);
		
		_assetsDetails.addItem(_spritesAccordion);
		_componentsDetails.addItem(_componentsAccordion);
		
		
		// event handling
		_objectNameTextInput.addEventListener(Event.CHANGE, entityPropertyChangeHandler);
		_objectXPosNS.addEventListener(Event.CHANGE, entityPropertyChangeHandler);
		_objectYPosNS.addEventListener(Event.CHANGE, entityPropertyChangeHandler);
		_objectWidthNS.addEventListener(Event.CHANGE, entityPropertyChangeHandler);
		_objectHeightNS.addEventListener(Event.CHANGE, entityPropertyChangeHandler);
		_objectScaleXNS.addEventListener(Event.CHANGE, entityPropertyChangeHandler);
		_objectScaleYNS.addEventListener(Event.CHANGE, entityPropertyChangeHandler);
		_objectRotationNS.addEventListener(Event.CHANGE, entityPropertyChangeHandler);
		
	}
	
	
	
	
	//**************************************** HANDLERS *********************************************
		
	
	private function entityPropertyChangeHandler(event:Event):Void 
	{
		
		
		if(event.currentTarget == _objectNameTextInput)
			_editor.selectedEntity.name = _objectNameTextInput.text;
				
		if(event.currentTarget == _objectXPosNS)
			_editor.selectedEntity.x = _objectXPosNS.value;
		
		if(event.currentTarget == _objectYPosNS)
			_editor.selectedEntity.y = _objectYPosNS.value;
		
		if(event.currentTarget == _objectWidthNS)
			_editor.selectedEntity.width = _objectWidthNS.value;
		
		if(event.currentTarget == _objectHeightNS)
			_editor.selectedEntity.height = _objectHeightNS.value;
		
		if(event.currentTarget == _objectScaleXNS)
			_editor.selectedEntity.scaleX = _objectScaleXNS.value;
		
		if(event.currentTarget == _objectScaleYNS)
			_editor.selectedEntity.scaleY = _objectScaleYNS.value;
		
		if(event.currentTarget == _objectRotationNS)
			_editor.selectedEntity.rotation = BMath.degreesToRadians(_objectRotationNS.value);
		
		//_editor.selectedScene = _editor.selectedScene;
	} // end function
	
	
	private function assetPropertyChangeHandler(event:Event):Void 
	{
		/*nameTextInput.name = "nameTextInput";
		xNS.name = "xNS";
		yNS.name = "yNS";
		widthNS.name = "widthNS";
		heightNS.name = "heightNS";
		scaleXNS.name = "scaleXNS";
		scaleYNS.name = "scaleYNS";
		RotationNS.name = "RotationNS";*/
		
		var uIComp:BUIComponent = null;
		
		/*if (cast(event.currentTarget, BUIComponent).name == "nameTextInput")
		{
			for (set in _assetUIArray)
			{
				if (set.nameTextInput == event.currentTarget)
				{
					set.asset.name = cast(event.currentTarget, BTextInput).text;
				} // end if
			} // end for
		} // end if
		
		if (cast(event.currentTarget, BUIComponent).name == "xNS")
		{
			for (set in _assetUIArray)
			{
				if(set.xNS == event.currentTarget)
					cast(set.asset, starling.display.DisplayObject).x = cast(event.currentTarget, BNumericStepper).value;
			} // end for
		} // end if
		
		if (cast(event.currentTarget, BUIComponent).name == "yNS")
		{
			for (set in _assetUIArray)
			{
				if(set.yNS == event.currentTarget)
					cast(set.asset, starling.display.DisplayObject).y = cast(event.currentTarget, BNumericStepper).value;
			} // end for
		} // end if
		
		if (cast(event.currentTarget, BUIComponent).name == "widthNS")
		{
			for (set in _assetUIArray)
			{
				if(set.widthNS == event.currentTarget)
					cast(set.asset, starling.display.DisplayObject).width = cast(event.currentTarget, BNumericStepper).value;
			} // end for
		} // end if
		
		if (cast(event.currentTarget, BUIComponent).name == "heightNS")
		{
			for (set in _assetUIArray)
			{
				if(set.heightNS == event.currentTarget)
					cast(set.asset, starling.display.DisplayObject).height = cast(event.currentTarget, BNumericStepper).value;
			} // end for
		} // end if
		
		if (cast(event.currentTarget, BUIComponent).name == "scaleXNS")
		{
			for (set in _assetUIArray)
			{
				if(set.scaleXNS == event.currentTarget)
					cast(set.asset, starling.display.DisplayObject).scaleX = cast(event.currentTarget, BNumericStepper).value;
			} // end for
		} // end if
		
		if (cast(event.currentTarget, BUIComponent).name == "scaleYNS")
		{
			for (set in _assetUIArray)
			{
				if(set.scaleYNS == event.currentTarget)
					cast(set.asset, starling.display.DisplayObject).scaleY = cast(event.currentTarget, BNumericStepper).value;
			} // end for
		} // end if
		
		if (cast(event.currentTarget, BUIComponent).name == "pivotXNS")
		{
			for (set in _assetUIArray)
			{
				if(set.pivotXNS == event.currentTarget)
					cast(set.asset, starling.display.DisplayObject).pivotX = cast(event.currentTarget, BNumericStepper).value;
			} // end for
		} // end if
		
		if (cast(event.currentTarget, BUIComponent).name == "pivotYNS")
		{
			for (set in _assetUIArray)
			{
				if(set.pivotYNS == event.currentTarget)
					cast(set.asset, starling.display.DisplayObject).pivotY = cast(event.currentTarget, BNumericStepper).value;
			} // end for
		} // end if
		
		if (cast(event.currentTarget, BUIComponent).name == "rotationNS")
		{
			for (set in _assetUIArray)
			{
				if(set.rotationNS == event.currentTarget)
					cast(set.asset, starling.display.DisplayObject).rotation = BMath.degreesToRadians(cast(event.currentTarget, BNumericStepper).value);
			} // end for
		} // end if
		*/
		
		for (set in _assetUIArray)
		{
			if (set.nameTextInput == event.currentTarget)
				set.asset.name = cast(event.currentTarget, BTextInput).text;
			
			if(set.xNS == event.currentTarget)
				cast(set.asset, starling.display.DisplayObject).x = cast(event.currentTarget, BNumericStepper).value;
				
			if(set.yNS == event.currentTarget)
				cast(set.asset, starling.display.DisplayObject).y = cast(event.currentTarget, BNumericStepper).value;
			
			if(set.widthNS == event.currentTarget)
				cast(set.asset, starling.display.DisplayObject).width = cast(event.currentTarget, BNumericStepper).value;
			
			if(set.heightNS == event.currentTarget)
				cast(set.asset, starling.display.DisplayObject).height = cast(event.currentTarget, BNumericStepper).value;
					
			if(set.scaleXNS == event.currentTarget)
				cast(set.asset, starling.display.DisplayObject).scaleX = cast(event.currentTarget, BNumericStepper).value;
			
			if(set.scaleYNS == event.currentTarget)
				cast(set.asset, starling.display.DisplayObject).scaleY = cast(event.currentTarget, BNumericStepper).value;
			
			if(set.pivotXNS == event.currentTarget)
				cast(set.asset, starling.display.DisplayObject).pivotX = cast(event.currentTarget, BNumericStepper).value;
			
			if(set.pivotYNS == event.currentTarget)
				cast(set.asset, starling.display.DisplayObject).pivotY = cast(event.currentTarget, BNumericStepper).value;
			
			if(set.rotationNS == event.currentTarget)
				cast(set.asset, starling.display.DisplayObject).rotation = BMath.degreesToRadians(cast(event.currentTarget, BNumericStepper).value);
		} // end for
	} // end function
	
		
	//**************************************** FUNCTIONS ********************************************
	
	
	override private function positionAssets():Void
	{
		super.positionAssets();
		
		if (_objectNameTextInput != null) 
		{
			_objectNameTextInput.width = _width - 120;
			if(_objectNameTextInput.width < 50)
				_objectNameTextInput.width = 50;
		}
		if (_propCategoryAccordion != null) _propCategoryAccordion.width = _width - _padding * 2;
		if (_spritesAccordion != null) _spritesAccordion.width = _width - _padding * 2 - 30; 
		if (_componentsAccordion != null) _componentsAccordion.width = _width - _padding * 2 - 30; 
		
	} // end function
	
	
	public function update(scene:BScene):Void
	{
		if (_editor.selectedEntity != null)
		{
			function trimClassName(c:Class<Dynamic>):String
			{
				var name = Std.string(c);
				name = name.substring(6, name.length - 1);
				return name;
			} // end function
			
			_objectNameTextInput.text = if(_editor.selectedEntity.name != null) _editor.selectedEntity.name else "";
			_objectTypeLabel.text = "Type: " + trimClassName(Type.getClass(_editor.selectedEntity));
			
			_objectXPosNS.value = _editor.selectedEntity.x;
			_objectYPosNS.value = _editor.selectedEntity.y;
			_objectWidthNS.value = _editor.selectedEntity.width;
			_objectHeightNS.value = _editor.selectedEntity.height;
			_objectScaleXNS.value = _editor.selectedEntity.scaleX;
			_objectScaleYNS.value = _editor.selectedEntity.scaleY;
			_objectRotationNS.value = BMath.radiansToDegrees(_editor.selectedEntity.rotation);
			
			_spritesAccordion.removeAll();
			_componentsAccordion.removeAll();
			_assetUIArray = [];
			
			for (i in 0..._editor.selectedEntity.numChildren)
			{
				var child:starling.display.DisplayObject = _editor.selectedEntity.getChildAt(i);
				
				var name = trimClassName(Type.getClass(child));
				name += (if (child.name != null) "\t " + child.name else "");
				var details:BDetails = new BDetails(name);
				
				var nameLabel:BLabel = new BLabel(null, 0, 0, "Name: ");
				var xLabel:BLabel = new BLabel(null, 0, 30, "X:");
				var yLabel:BLabel = new BLabel(null, 200, 30, "Y:");
				var widthLabel:BLabel = new BLabel(null, 0, 60, "Width:");
				var heightLabel:BLabel = new BLabel(null, 200, 60, "Height:");
				var scaleXLabel:BLabel = new BLabel(null, 0, 90, "Scale X:");
				var scaleYLabel:BLabel = new BLabel(null, 200, 90, "Scale Y:");
				var pivotXLabel:BLabel = new BLabel(null, 0, 120, "Pivot X:");
				var pivotYLabel:BLabel = new BLabel(null, 200, 120, "Pivot Y:");
				var rotationLabel:BLabel = new BLabel(null, 0, 150, "Rotation:");
				
				var nameTextInput:BTextInput = new BTextInput(null, 100, 0, (if (child.name != null) child.name else ""));
				var xNS:BNumericStepper = new BNumericStepper(null, 100, 30);
				var yNS:BNumericStepper = new BNumericStepper(null, 300, 30);
				var widthNS:BNumericStepper = new BNumericStepper(null, 100, 60);
				var heightNS:BNumericStepper = new BNumericStepper(null, 300, 60);
				var scaleXNS:BNumericStepper = new BNumericStepper(null, 100, 90);
				var scaleYNS:BNumericStepper = new BNumericStepper(null, 300, 90);
				var pivotXNS:BNumericStepper = new BNumericStepper(null, 100, 120);
				var pivotYNS:BNumericStepper = new BNumericStepper(null, 300, 120);
				var rotationNS:BNumericStepper = new BNumericStepper(null, 100, 150);
				
				nameTextInput.name = "nameTextInput";
				xNS.name = "xNS";
				yNS.name = "yNS";
				widthNS.name = "widthNS";
				heightNS.name = "heightNS";
				scaleXNS.name = "scaleXNS";
				scaleYNS.name = "scaleYNS";
				pivotXNS.name = "pivotXNS";
				pivotYNS.name = "pivotYNS";
				rotationNS.name = "rotationNS";
				
				nameTextInput.addEventListener(Event.CHANGE, assetPropertyChangeHandler);
				xNS.addEventListener(Event.CHANGE, assetPropertyChangeHandler);
				yNS.addEventListener(Event.CHANGE, assetPropertyChangeHandler);
				widthNS.addEventListener(Event.CHANGE, assetPropertyChangeHandler);
				heightNS.addEventListener(Event.CHANGE, assetPropertyChangeHandler);
				scaleXNS.addEventListener(Event.CHANGE, assetPropertyChangeHandler);
				scaleYNS.addEventListener(Event.CHANGE, assetPropertyChangeHandler);
				pivotXNS.addEventListener(Event.CHANGE, assetPropertyChangeHandler);
				pivotYNS.addEventListener(Event.CHANGE, assetPropertyChangeHandler);
				rotationNS.addEventListener(Event.CHANGE, assetPropertyChangeHandler);
				
				_assetUIArray.push(
				{
					asset: child, 
					nameTextInput: nameTextInput, 
					xNS: xNS, 
					yNS: yNS, 
					widthNS: widthNS, 
					heightNS: heightNS, 
					scaleXNS: scaleXNS, 
					scaleYNS: scaleYNS,
					pivotXNS: pivotXNS,
					pivotYNS: pivotYNS,
					rotationNS: rotationNS
				});
				
				for (ns in [xNS, yNS, widthNS, heightNS, scaleXNS, scaleYNS, pivotXNS, pivotYNS])
				{
					ns.maximum = 10000;
					ns.minimum = -10000;
				} // end for
				
				rotationNS.maximum = 360;
				rotationNS.minimum = -180;
				
				xNS.value = child.x;
				yNS.value = child.y;
				widthNS.value = child.width;
				heightNS.value = child.height;
				scaleXNS.value = child.scaleX;
				scaleYNS.value = child.scaleY;
				rotationNS.value = BMath.radiansToDegrees(child.rotation);
				
				details.addItem(nameLabel);
				details.addItem(xLabel);
				details.addItem(yLabel);
				details.addItem(widthLabel);
				details.addItem(heightLabel);
				details.addItem(scaleXLabel);
				details.addItem(scaleYLabel);
				details.addItem(pivotXLabel);
				details.addItem(pivotYLabel);
				details.addItem(rotationLabel);
				
				details.addItem(xNS);
				details.addItem(yNS);
				details.addItem(widthNS);
				details.addItem(heightNS);
				details.addItem(scaleXNS);
				details.addItem(scaleYNS);
				details.addItem(pivotXNS);
				details.addItem(pivotYNS);
				details.addItem(rotationNS);
				
				
				_spritesAccordion.addDetails(details);
			} // end for
			
			for (i in 0..._editor.selectedEntity.numComponents)
			{
				var comp:BEntityComponent = _editor.selectedEntity.getComponentAt(i);
				
				var name = trimClassName(Type.getClass(comp));
				name += (if (comp.name != null) "\t " + comp.name else "");
				var details:BDetails = new BDetails(name);
				
				_componentsAccordion.addDetails(details);
			} // end for
			
		} // end if
		
	} // end function
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
} // end class


class LayersPanel extends LevelEditorPanel
{
	// assets
	private var _layersList:BList;
	
	private var _buttonContainer:BUIComponent;
	private var _addLayerButton:BButton;
	private var _delateLayerButton:BButton;
	private var _upLayerButton:BButton;
	private var _downLayerButton:BButton;
	
	
	private var _layers:Array<Dynamic>;
	
	
	
	public function new()
	{
		super("Layers");
		
		setSize(400, 300);
		
		
		var buttonWidth = 20;
		var buttonHeight = 20;
		
		_layersList = new BList(content, 0, 0);
		_layersList.autoSize = false;
		_layersList.width = width - 20;
		_layersList.height = 300;
		_layersList.rowHeight = 60;
		_layersList.itemClass = LevelEditorListItemClass;
		
		_buttonContainer = new BUIComponent(content, 0, 300);
		_buttonContainer.style.backgroundColor = 0x111111;
		_buttonContainer.setSize(width, 20);
		
		_addLayerButton = new BButton(_buttonContainer, 0, 0, "");
		_delateLayerButton = new BButton(_buttonContainer, 0, 0, "");
		_upLayerButton = new BButton(_buttonContainer, 0, 0, "");
		_downLayerButton = new BButton(_buttonContainer, 0, 0, "");
		
		var i = 0;
		for (button in [_addLayerButton, _delateLayerButton, _upLayerButton, _downLayerButton])
		{
			button.x = i * 20;
			button.y = 0;
			button.autoSize = false;
			button.setSize(buttonWidth, buttonHeight);
			button.labelPlacement = BPlacement.CENTER;
			//button.setIcon(new Bitmap(Assets.getBitmapData("graphics/add icon 010001.png")));
			button.iconPlacement = BPlacement.CENTER;
			i++;
		} // end for
		
		_addLayerButton.setIcon(new Bitmap(Assets.getBitmapData("graphics/add icon 010001.png")));
		_delateLayerButton.setIcon(new Bitmap(Assets.getBitmapData("graphics/trash can icon 010001.png")));
		_upLayerButton.setIcon(new Bitmap(Assets.getBitmapData("graphics/arrow left stroke icon 01 24x24.png")));
		_downLayerButton.setIcon(new Bitmap(Assets.getBitmapData("graphics/arrow right stroke icon 01 24x24.png")));
		_upLayerButton.setIconBounds(20, 0, 20, 20, 90);
		_downLayerButton.setIconBounds(20, 0, 20, 20, 90);
		
		
		// event handling
		_layersList.addEventListener(Event.CHANGE, listItemChangeHandler);
		_addLayerButton.addEventListener(MouseEvent.CLICK, addLayerHandler);
		_delateLayerButton.addEventListener(MouseEvent.CLICK, deleteLayerHandler);
		_upLayerButton.addEventListener(MouseEvent.CLICK, moveLayerIndexHandler);
		_downLayerButton.addEventListener(MouseEvent.CLICK, moveLayerIndexHandler);
	}
	
	
	
	
	
	//**************************************** HANDLERS *********************************************
	
	
	private function listItemChangeHandler(event:Event):Void 
	{
		_editor.selectedScene.currentLayer = cast(_layersList.selectedItem.data);
	} // end function
	
	
	private function addLayerHandler(event:MouseEvent):Void 
	{
		var layer:BLayer = new BLayer();
		_editor.selectedScene.addLayer(layer);
		
		_editor.selectedScene = _editor.selectedScene;
	} // end function
	
	
	private function deleteLayerHandler(event:MouseEvent):Void 
	{
		_editor.selectedScene.removeLayer(_editor.selectedScene.currentLayer);
		
		_editor.selectedScene = _editor.selectedScene;
	} // end function
	
	
	private function moveLayerIndexHandler(event:MouseEvent):Void 
	{
		/*switch(event.currentTarget)
		{
			case _upLayerButton:
				_editor.selectedScene.currentLayer.zIndex ++;
			
			case _downLayerButton:
				_editor.selectedScene.currentLayer.zIndex --;
		} // end switch 
		*/
		_editor.selectedScene = _editor.selectedScene;
	} // end function
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	override private function positionAssets():Void
	{
		super.positionAssets();
		
		if (_buttonContainer != null && _layersList != null)
		{
			_layersList.setSize(_width - _padding * 2, _height - _titleBarHeight - _padding * 2 - _buttonContainer.height);
			_buttonContainer.width = _width - _padding * 2;
			_buttonContainer.y = _height - _padding * 2 - _titleBarHeight - _buttonContainer.height;
		}
	} // end function
	
	
	public function update(scene:BScene):Void
	{
		_layersList.removeAll();
		for (i in 0...scene.numLayers)
		{
			var layer = scene.getLayerAt(i);
			
			_layersList.addItem({label: layer.name, data: layer });
		} // end for
		
	} // end function
	
	
	//**************************************** SET AND GET ******************************************
	
	
} // end class


class LevelEditorListItemClass extends BListItem
{
	// assets
	private var _paralaxXLabel:BLabel;
	private var _paralaxYLabel:BLabel;
	
	private var _paralaxXNumericStepper:BNumericStepper;
	private var _paralaxYNumericStepper:BNumericStepper;
	
	
	public function new(label:String = "", data:Dynamic = null)
	{
		super(label, data);
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	private function paralaxChangeHandler(event:Event):Void 
	{
		cast(_data, BLayer).paralaxX = _paralaxXNumericStepper.value;
		cast(_data, BLayer).paralaxY = _paralaxYNumericStepper.value;
		
	} // end function
	
		
	//**************************************** FUNCTIONS ********************************************
	
	
	override private function initialize():Void
	{
		super.initialize();
		
		_paralaxXLabel = new BLabel(this, 150, 0, "paralax X:");
		_paralaxYLabel = new BLabel(this, 150, 30, "paralax Y:");
		
		_paralaxXNumericStepper = new BNumericStepper(this, 230, 0);
		_paralaxXNumericStepper.buttonPlacement = BPlacement.HORIZONTAL;
		_paralaxXNumericStepper.maxChars = 4;
		_paralaxXNumericStepper.maximum = 1;
		_paralaxXNumericStepper.stepSize = 0.01;
		
		_paralaxYNumericStepper = new BNumericStepper(this, 230, 30);
		_paralaxYNumericStepper.buttonPlacement = BPlacement.HORIZONTAL;
		_paralaxYNumericStepper.maxChars = 4;
		_paralaxYNumericStepper.maximum = 1;
		_paralaxYNumericStepper.stepSize = 0.01;
		
		mouseChildren = true;
		
		setStateColors( -1, 0x333333, 0x222222, -1, -1, -1, -1, -1);
		
		
		//event handling
		_paralaxXNumericStepper.addEventListener(Event.CHANGE, paralaxChangeHandler);
		_paralaxYNumericStepper.addEventListener(Event.CHANGE, paralaxChangeHandler);
		
	} // end function
	
	
	
	override private function draw():Void
	{
		super.draw();
		
		if (_data != null)
		{
			_paralaxXNumericStepper.value = cast(_data, BLayer).paralaxX;
			_paralaxYNumericStepper.value = cast(_data, BLayer).paralaxY;
		} // end if
		
	} // end function
	
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
} // end class


class AssetsPanel extends LevelEditorPanel
{
	// assets
	private var _atlasAccordian:BAccordion;
	private var _scrollPane:BScrollPane;
	private var _flexbox:BFlexBox;
	
	
	private var _texture:BTexture;
	private var _textures:Array<BTexture> = [];
	
	private var _xml:Xml;
	private var _xmls:Array<Xml> = [];
	
	private var _textureAtlas:BTextureAtlas;
	private var _textureAtlases:Array<BTextureAtlas> = [];
	
	// other
	public var seletedAssetName:String = "";
	private var _assetPrevue:DisplayObject;
	
	
	public function new()
	{
		super("Assets");
		
		setSize(400, 300);
		
		_atlasAccordian = new BAccordion(content, 0, 0);
		
		
		_texture = BTexture.fromBitmapData(Assets.getBitmapData("graphics/Environment.png"));
		_xml = Xml.parse(Assets.getText("graphics/Environment.xml"));
		
		addTextureAtlas(_texture, _xml);
		addTextureAtlas(BTexture.fromBitmapData(Assets.getBitmapData("graphics/Effects.png")), Xml.parse(Assets.getText("graphics/Effects.xml")));
		addTextureAtlas(BTexture.fromBitmapData(Assets.getBitmapData("graphics/Enemy Sprites [FLCC]2.png")), Xml.parse(Assets.getText("graphics/Enemy Sprites [FLCC]2.xml")));
		addTextureAtlas(BTexture.fromBitmapData(Assets.getBitmapData("graphics/UI.png")), Xml.parse(Assets.getText("graphics/UI.xml")));
		/*addTextureAtlas(BTexture.fromBitmapData(Assets.getBitmapData("graphics/.png")), Xml.parse(Assets.getText("graphics/.xml")));
		addTextureAtlas(BTexture.fromBitmapData(Assets.getBitmapData("graphics/.png")), Xml.parse(Assets.getText("graphics/.xml")));
		addTextureAtlas(BTexture.fromBitmapData(Assets.getBitmapData("graphics/.png")), Xml.parse(Assets.getText("graphics/.xml")));
		*/
	}
	
	
	//**************************************** HANDLERS *********************************************
	
	
	private function assetSelectClickHandler(event:MouseEvent):Void 
	{
		var button:BButton = cast(event.currentTarget, BButton);
		seletedAssetName = button.name;
		
		var bitmap = new Bitmap(cast(button.getChildAt(button.numChildren - 2), Bitmap).bitmapData);
		
		
		if (_assetPrevue != null)
		{
			_assetPrevue.parent.removeChild(_assetPrevue);
			_assetPrevue = bitmap;
		} // end if
		else
			_assetPrevue = bitmap;
		
		//parent.addChild(_assetPrevue);
		//stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	} // end function
	
	
	private function mouseMoveHandler(event:MouseEvent):Void 
	{
		//_assetPrevue.x = event.stageX;
		//_assetPrevue.y = event.stageY;
		
	} // end function
	
	
	//**************************************** FUNCTIONS ********************************************
	
	
	override private function positionAssets():Void
	{
		super.positionAssets();
		
		//if (_atlasAccordian != null) _atlasAccordian.width = _width - _padding * 2;
		//if(_scrollPane != null) _scrollPane.setSize(_atlasAccordian.width - 20, _height - _titleBarHeight - _padding * 2 - 30);	
		
		
		if (_atlasAccordian != null) 
		{
			_atlasAccordian.width = _width - _padding * 2;
			
			var i = 1;
			for (details in _atlasAccordian.details)
			{
				var scrollPane:BScrollPane = cast(details.getItemAt(0), BScrollPane);
				
				//scrollPane.setSize(_atlasAccordian.width - 20, _height - _titleBarHeight - _padding * 2 - 30);
				scrollPane.setSize(_atlasAccordian.width - 20, _height - _titleBarHeight - _padding * 2 - 30 * i);
				i++;
			} // end for
		} // end if
		
		
		
	} // end function
	
	
	private function update():Void
	{
		
	} // end function
	
	
	/**
	 * 
	 * @param	size
	 */
	private function setDOSize(displayObject:DisplayObject, size:Float):Void
	{
		
		// scrollrectwidth/buttonwidth = 2;
		// bitapwidth / ratio
		
		if (displayObject.width > size || displayObject.height > size) 
		{
			// scale each icon so that it is not larger than size
			//var widthLonger = displayObject.width > displayObject.height ? true : false;
			//var heightLonger = displayObject.height > displayObject.width ? true : false;
			
			var widthLonger = displayObject.scrollRect.width > displayObject.scrollRect.height ? true : false;
			var heightLonger = displayObject.scrollRect.height > displayObject.scrollRect.width ? true : false;
			
			if (widthLonger) 
			{
				//displayObject.width = size;
				displayObject.width = displayObject.width / (displayObject.scrollRect.width/size);
				displayObject.scaleY = displayObject.scaleX;
			}
			else //if(heightLonger) // remove if part to make exact fit
			{
				//displayObject.height = size;
				displayObject.height = displayObject.height / (displayObject.scrollRect.height/size);
				displayObject.scaleX = displayObject.scaleY;
			}
			
		} // end if  
		
	} // end function
	
	/**
	 * 
	 * @param	texture
	 * @param	xml
	 */
	public function addTextureAtlas(texture:BTexture, xml:Xml):BTextureAtlas
	{
		var buttonWidth = 80;
		var buttonHeight = 80;
		
		_scrollPane = new BScrollPane(null, 0, 0);
		_scrollPane.setSize(200, 500);
		
		var textureAtlas = new BTextureAtlas(texture, xml);
		
		_textures.push(texture);
		_xmls.push(xml);
		_textureAtlases.push(textureAtlas);
		
		
		var i = 0;
		for (textureElement in xml.elementsNamed("TextureAtlas"))
		{
			var details:BDetails = new BDetails(textureElement.get("imagePath"));
			details.indent = 20;
			details.addItem(_scrollPane);
			_atlasAccordian.addDetails(details);
			
			_flexbox = new BFlexBox(BFlexBox.HORIZONTAL, _scrollPane.content, 0, 0);
			_flexbox.flexParent = this;
			_flexbox.justify = BFlexBox.START;
			//_flexbox.alignContent = BFlexBox.VERTICAL;
			//_flexbox.alignItems = BFlexBox.VERTICAL;
			_flexbox.wrap = BFlexBox.WRAP;
			_flexbox.horizontalSpacing = _flexbox.verticalSpacing = 10;
			
			
			var j = 0;
			for (subTextureElement in textureElement.elementsNamed("SubTexture"))
			{
				var bitmap = BTexture.createBitmap(textureAtlas.getTexture(subTextureElement.get("name")));
				setDOSize(bitmap, 64);
				
				//var button = new BButton(_scrollPane.content, (i * buttonWidth), (j * buttonHeight));
				var button = new BButton(null, 0, 0, subTextureElement.get("name"));
				button.setSize(buttonWidth, buttonHeight);
				button.addChild(bitmap);
				button.labelPlacement = BPlacement.BOTTOM;
				button.textField.setTextFormat(new TextFormat(null, 12, 0xFFFFFF));
				button.textField.multiline = true;
				button.textField.width = buttonWidth;
				button.name = subTextureElement.get("name");
				button.addEventListener(MouseEvent.CLICK, assetSelectClickHandler);
				
				_flexbox.addChild(button);
				
				j++;
			} // end for
			
			
			i++;
		} // end for
		
		return textureAtlas;
		
	} // end function
	
	
	
	//**************************************** SET AND GET ******************************************
	
	
} // end class



