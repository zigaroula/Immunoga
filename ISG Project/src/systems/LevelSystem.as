package systems {
	
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.family.matcher.noneOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.lip6.genome.geography.move.component.TargetPos;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	
	import components.Game.Ship;
	import components.Game.Spawn;
	import components.SIEntity;
	import components.Game.Level;
	import components.Game.MenuButton;
	import components.Infection;
	import components.SystemeImmunitaire.CelluleStructure;
	import components.Game.UI;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.resource.component.TextureResource;
	
	
	public class LevelSystem extends System {
		private var levels:Family;
		private var menuButtons:Family;
		private var celStruct:Family;
		private var siEntities:Family;
		private var ships:Family;
		private var ui:Family;
		private var curLevel:Level;
		
		private var levelMapper:IComponentMapper;
		private var siMapper:IComponentMapper;
		private var menuButtonMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		
		private var completedLevels:Array;
		private var saveDataObject:SharedObject;
		
		public function LevelSystem(stage:Stage) {
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			levels = entityManager.getFamily(allOfGenes(Level));
			menuButtons = entityManager.getFamily(allOfGenes(MenuButton));
			celStruct = entityManager.getFamily(allOfGenes(CelluleStructure), noneOfGenes(Infection));
			siEntities = entityManager.getFamily(allOfGenes(SIEntity));
			ships = entityManager.getFamily(allOfGenes(Ship));
			ui =  entityManager.getFamily(allOfGenes(UI));
			
			levelMapper = geneManager.getComponentMapper(Level);
			siMapper = geneManager.getComponentMapper(SIEntity);
			menuButtonMapper = geneManager.getComponentMapper(MenuButton);
			transformMapper = geneManager.getComponentMapper(Transform);
			
			// Load save
			saveDataObject = SharedObject.getLocal("test");
			if (saveDataObject.data.completedLevels == null) {
				completedLevels = new Array(0, 0, 0, 0, 0, 0);
				saveDataObject.data.completedLevels = completedLevels;
				saveDataObject.flush();
			} else {
				completedLevels = saveDataObject.data.completedLevels;
			}
			loadMenu();
		}
		
		override protected function onProcess(delta:Number):void
		{
			if (levels.members.length > 0) {
				curLevel = levelMapper.getComponent(levels.members[0]);
			}
			else {
				curLevel = null;
			}
			
			if(curLevel != null) {
				curLevel.duration -= delta;
				
				if (curLevel.duration < 0) {
					win();
					loadMenu();
				}
				
				if (curLevel.nCelStruct > celStruct.members.length) {
					lose();
					loadMenu();
				}	
			}
		}
		
		public function clearLevel():void {
			trace("clearing level");
			killFamily(siEntities);
			killFamily(levels);
			killFamily(menuButtons);
			killFamily(ui);
		}
		
		public function killFamily(f:Family):void {
			var n:int = f.members.length;
			var i:int = 0
			var e:IEntity;
			for (i=0 ; i < n ; i++) {
				e = f.members[i];
				entityManager.killEntity(e);
			}
		}
		
		public function loadLevel(n:int):void {
			clearLevel();
			var url:String = 'xml/level' + n + '.entityBundle.xml';
			var name:String = 'level' + n;
			EntityFactory.createResourcedEntity(world.getEntityManager(), url, name);
		}
		
		public function loadMenu():void {
			clearLevel();
			trace("loading menu");
			EntityFactory.createResourcedEntity(world.getEntityManager(), 'xml/menu.entityBundle.xml', "menu");
			markCompletedLevels();
		}
		
		public function markCompletedLevels() {
			saveDataObject.data.completedLevels = completedLevels;
			saveDataObject.flush();
			for (var i:int = 0 ; i < completedLevels.length ; i++) {
				if (completedLevels[i] == 1) {
					markLevel(25 + (i % 3) * 125, Math.floor(i/3) * 125 + 200);
				}
			}
		}
		
		public function markLevel(xL:int, yL:int) {
			var e:IEntity = entityManager.create();
			entityManager.addComponent (e, UI, { } );
			entityManager.addComponent (e, Transform,  {x:xL, y:yL} );
			entityManager.addComponent (e, Layered, { layerId:"gameLayer" } );
			entityManager.addComponent (e, TextureResource, { source:"pictures/win.png", id:"win" } );
		}
		
		public function win():void {
			var e:IEntity = entityManager.create();
			entityManager.addComponent (e, UI, { } );
			entityManager.addComponent (e, Transform,  {x:150, y:30} );
			entityManager.addComponent (e, Layered, { layerId:"gameLayer" } );
			entityManager.addComponent (e, TextureResource, { source:"pictures/win.png", id:"win" } );
			var number:int = (levelMapper.getComponent(levels.members[0])).number;
			completedLevels[number-1] = 1;
			trace("win level " + number);
		}
		
		public function lose():void {
			var e:IEntity = entityManager.create();
			entityManager.addComponent (e, UI, { } );
			entityManager.addComponent (e, Transform,  {x:150, y:30} );
			entityManager.addComponent (e, Layered, { layerId:"gameLayer" } );
			entityManager.addComponent (e, TextureResource, { source:"pictures/lose.png", id:"lose" } );
			trace("win");
		}
		
		private function clickHandler(event:MouseEvent):void {
			var x:int = event.localX;
			var y:int = event.localY;
			var n:int = menuButtons.members.length;
			for (var i:int = 0 ; i < n ; i++) {
				var e:IEntity = menuButtons.members[i];
				var tr:Transform = transformMapper.getComponent(e);
				var mB:MenuButton = menuButtonMapper.getComponent(e);
				if (x >= tr.x && x <= tr.x + 100 && y >= tr.y && y <= tr.y + 100 && mB.level != 0) {
					loadLevel(mB.level);
					return;
				}
			}
		}
		
		private function keyHandler(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ESCAPE) {
				loadMenu();
				return;
			}
			if (event.keyCode == Keyboard.SPACE) {
				var ship:IEntity = ships.members[0];
				var x:int = (transformMapper.getComponent(ship)).x;
				var y:int = (transformMapper.getComponent(ship)).y;
				var n:int = menuButtons.members.length;
				for (var i:int = 0 ; i < n ; i++) {
					var e:IEntity = menuButtons.members[i];
					var tr:Transform = transformMapper.getComponent(e);
					var mB:MenuButton = menuButtonMapper.getComponent(e);
					if (x >= tr.x && x <= tr.x + 100 && y >= tr.y && y <= tr.y + 100 && mB.level != 0) {
						loadLevel(mB.level);
						return;
					}
				}
			}
			if (event.keyCode == Keyboard.DELETE) {
				completedLevels = new Array(0, 0, 0, 0, 0, 0);
				saveDataObject.data.completedLevels = completedLevels;
				saveDataObject.flush();
				loadMenu();
			}
		}
	}
}
