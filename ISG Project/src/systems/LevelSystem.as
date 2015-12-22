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
	import flash.events.MouseEvent;
	
	import components.Game.Ship;
	import components.Game.Spawn;
	import components.SIEntity;
	import components.Game.Level;
	import components.Game.MenuButton;
	import components.Infection;
	import components.SystemeImmunitaire.CelluleStructure;
	
	
	public class LevelSystem extends System {
		private var levels:Family;
		private var menuButtons:Family;
		private var celStruct:Family;
		private var siEntities:Family;
		private var curLevel:Level;
		
		private var levelMapper:IComponentMapper;
		private var siMapper:IComponentMapper;
		private var menuButtonMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		
		public function LevelSystem(stage:Stage) {
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			levels = entityManager.getFamily(allOfGenes(Level));
			menuButtons = entityManager.getFamily(allOfGenes(MenuButton));
			celStruct = entityManager.getFamily(allOfGenes(CelluleStructure), noneOfGenes(Infection));
			siEntities = entityManager.getFamily(allOfGenes(SIEntity));
			
			levelMapper = geneManager.getComponentMapper(Level);
			siMapper = geneManager.getComponentMapper(SIEntity);
			menuButtonMapper = geneManager.getComponentMapper(MenuButton);
			transformMapper = geneManager.getComponentMapper(Transform);
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
			var n:int = siEntities.members.length;
			var i:int = 0
			var e:IEntity;
			for (i=0 ; i < n ; i++) {
				e = siEntities.members[i];
				entityManager.killEntity(e);
			}
			n =levels.members.length;
			for (i=0 ; i < n ; i++) {
				e = levels.members[i];
				entityManager.killEntity(e);
			}
			n = menuButtons.members.length;
			for (i = 0 ; i < n ; i++) {
				e = menuButtons.members[i];
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
		}
		
		public function win():void {
			trace("win");
		}
		
		public function lose():void {
			trace("lose");
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
				} else if (x >= tr.x && x <= tr.x + 100 && y >= tr.y && y <= tr.y + 50 && mB.level == 0) {
					loadMenu();
				}
			}
		}
	}
}
