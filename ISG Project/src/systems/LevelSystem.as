package systems {
	
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.family.matcher.noneOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.lip6.genome.geography.move.component.TargetPos;
	
	import components.Game.Ship;
	import components.Game.Spawn;
	import components.SIEntity;
	import components.Game.Level;
	import components.Infection;
	import components.SystemeImmunitaire.CelluleStructure;
	
	
	public class LevelSystem extends System {
		private var levels:Family;
		private var celStruct:Family;
		private var siEntities:Family;
		private var curLevel:Level;
		
		private var levelMapper:IComponentMapper;
		private var siMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			levels = entityManager.getFamily(allOfGenes(Level));
			celStruct = entityManager.getFamily(allOfGenes(CelluleStructure), noneOfGenes(Infection));
			siEntities = entityManager.getFamily(allOfGenes(SIEntity));
			
			levelMapper = geneManager.getComponentMapper(Level);
			siMapper = geneManager.getComponentMapper(SIEntity);
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
		}
		
		public function loadLevel(n:int):void {
			clearLevel();
			EntityFactory.createResourcedEntity(world.getEntityManager(), 'xml/level1.entityBundle.xml', "level1");
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
	}
}
