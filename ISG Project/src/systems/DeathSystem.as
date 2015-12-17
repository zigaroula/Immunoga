package systems {
	
	import com.ktm.genome.core.data.component.IComponent;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.lip6.genome.geography.move.component.TargetPos;
	
	import components.SystemeImmunitaire.CelluleStructure;
	import components.SIEntity;
	
	public class DeathSystem extends System {
		
		private var cellEntities:Family;
		
		private var transformMapper:IComponentMapper;
		private var siMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			cellEntities = entityManager.getFamily(allOfGenes(CelluleStructure));
			
			transformMapper = geneManager.getComponentMapper(Transform);
			siMapper = geneManager.getComponentMapper(SIEntity);
		}
		
		override protected function onProcess(delta:Number):void {
			
			var familySize:int = cellEntities.members.length;
			for (var i:int = 0; i < familySize; i++) {
				var e:IEntity = cellEntities.members[i];
				
				var tr:Transform = transformMapper.getComponent(e);
				var si:SIEntity = siMapper.getComponent(e);
				
				
				if (si.hp < 0) {
					var x:int = tr.x + 15;
					var y:int = tr.y + 15;
					
					entityManager.killEntity(e);
					
					EntityFactory.createDechet(entityManager, x - 11, y - 11, x - 11, y - 11, 1);
					EntityFactory.createDechet(entityManager, x + 11, y - 11, x + 11, y - 11, 2);
					EntityFactory.createDechet(entityManager, x     , y + 11, x     , y + 11, 3);
					
				}
			}
			
		}
		
	}

}