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
		private var infectedCells:Family;
		private var curLevel:Level;
		
		private var url:String;
		private var name:String;
		
		private var toMarkLevels:Boolean = false;
		
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
			infectedCells = entityManager.getFamily(allOfGenes(Infection));
			
			levelMapper = geneManager.getComponentMapper(Level);
			siMapper = geneManager.getComponentMapper(SIEntity);
			menuButtonMapper = geneManager.getComponentMapper(MenuButton);
			transformMapper = geneManager.getComponentMapper(Transform);
			
			// Load save
			saveDataObject = SharedObject.getLocal("lul");
			if (saveDataObject.data.completedLevels == null) {
				completedLevels = new Array(2, 0, 0, 0, 0, 0); //0,1,2 = locked, completed, unlocked
				saveDataObject.data.completedLevels = completedLevels;
				saveDataObject.flush();
			} else {
				completedLevels = saveDataObject.data.completedLevels;
			}
			loadMenu();
		}
		
		override protected function onProcess(delta:Number):void
		{
			markCompletedLevels();
			
			if (levels.members.length > 0)
				curLevel = levelMapper.getComponent(levels.members[0]);
			else
				curLevel = null;
			
			if(curLevel != null) {
				curLevel.duration -= delta;
				
				if (curLevel.duration < 0) {
					if (infectedCells.members.length == 0) {
						win();
					} else {
						lose();
					}
					loadMenu();
				}
				
				if (celStruct.members.length == 0) {
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
			if(completedLevels[n-1] != 0) {
				clearLevel();
				url = 'xml/level' + n + '.entityBundle.xml';
				name = 'level' + n;
				EntityFactory.createResourcedEntity(world.getEntityManager(), url, name);
			}
		}
		
		public function loadMenu():void {
			clearLevel();
			trace("loading menu");
			EntityFactory.createResourcedEntity(world.getEntityManager(), 'xml/menu.entityBundle.xml', "menu");
			toMarkLevels = true;
		}
		
		public function markCompletedLevels():void {
			if(toMarkLevels) {
				saveDataObject.data.completedLevels = completedLevels;
				saveDataObject.flush();
				
				var n:int = menuButtons.members.length;
				if(n==completedLevels.length) {
					for (var i:int = 0 ; i < n ; i++) {
						var e:IEntity = menuButtons.members[i];
						var tr:Transform = transformMapper.getComponent(e);
						var mB:MenuButton = menuButtonMapper.getComponent(e);
						
						markLevel(tr.x, tr.y, completedLevels[mB.level - 1]);
					}
					toMarkLevels = false;
				}
			}
		}
		
		public function addUI(_x:int, _y:int, _source:String, _id:String):void {
			var e:IEntity = entityManager.create();
			entityManager.addComponent (e, UI, { } );
			entityManager.addComponent (e, Transform,  {x:_x, y:_y} );
			entityManager.addComponent (e, Layered, { layerId:"gameLayer" } );
			entityManager.addComponent (e, TextureResource, { source:_source, id:_id } );
		}
		
		public function markLevel(xL:int, yL:int, unlocked:int):void {
			if(unlocked==1)
				addUI(xL, yL, "pictures/complete.png", "complete");
			else if(unlocked==0)
				addUI(xL, yL, "pictures/lock.png", "lock");
		}
		
		public function win():void {
			addUI(150, 90, "pictures/win.png", "win");
			
			var number:int = (levelMapper.getComponent(levels.members[0])).number;
			completedLevels[number - 1] = 1;
			
			//unlock next level
			if (number < completedLevels.length) {
				if (completedLevels[number] != 1) {
					completedLevels[number] = 2;
				}
			}
			
			trace("win level " + number);
		}
		
		public function lose():void {
			addUI(150, 90, "pictures/lose.png", "lose");
		}
		
		
		private function loadLevelXY(x:int, y:int):void {
			var n:int = menuButtons.members.length;
			for (var i:int = 0 ; i < n ; i++) {
					var e:IEntity = menuButtons.members[i];
					var tr:Transform = transformMapper.getComponent(e);
					var mB:MenuButton = menuButtonMapper.getComponent(e);
					if (x >= tr.x && x <= tr.x + Global.buttonsize && y >= tr.y && y <= tr.y + Global.buttonsize && mB.level != 0) {
						loadLevel(mB.level);
						return;
					}
			}
		}
		
		private function clickHandler(event:MouseEvent):void {
			var x:int = event.localX;
			var y:int = event.localY;
			loadLevelXY(x, y);
		}
		
		private function keyHandler(event:KeyboardEvent):void {
			//back to menu
			if (event.keyCode == Keyboard.ESCAPE) {
				loadMenu();
				return;
			}
			//select level with ship
			if (event.keyCode == Keyboard.SPACE) {
				var tr:Transform = transformMapper.getComponent(ships.members[0]);
				loadLevelXY(tr.x + Global.shipsize / 2, tr.y);
			}
			//reset progression
			if (event.keyCode == Keyboard.DELETE) {
				completedLevels = new Array(2, 0, 0, 0, 0, 0);
				saveDataObject.data.completedLevels = completedLevels;
				saveDataObject.flush();
				loadMenu();
			}
		}
	}
}
