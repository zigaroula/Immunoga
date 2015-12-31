package systems {
	
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.lip6.genome.geography.move.component.TargetPos;

	import components.Game.Ship;
	import components.Game.Spawn;
	
	public class SpawnSystem extends System {
		private var spawningEntities:Family;
		
		private var spawnMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			spawningEntities = entityManager.getFamily(allOfGenes(Spawn));
			
			spawnMapper = geneManager.getComponentMapper(Spawn);
			transformMapper = geneManager.getComponentMapper(Transform);
		}
		
		override protected function onProcess(delta:Number):void
		{
			var familySize:int = spawningEntities.members.length; 
			for (var i:int = 0 ; i < familySize ; i++) {
				var e:IEntity = spawningEntities.members[i];
				
				var tr:Transform = transformMapper.getComponent(e);
				var sp:Spawn = spawnMapper.getComponent(e);
				
				
				if(sp.timer >= 0) {
					sp.timer -= delta;
										
					if (sp.timer < 0) {
						entityManager.removeComponent(e, spawnMapper.gene);
						tr.visible = true;
					}
				}
				else {
					sp.timer += delta;
					
					tr.alpha = Math.min (1,  -1 * sp.timer / 300);
					
					if (sp.timer >= 0) {
						entityManager.killEntity(e);
					}
				}
			}
		}
	}
	
}