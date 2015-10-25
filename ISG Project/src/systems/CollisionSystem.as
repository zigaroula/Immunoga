package systems {
	
	import com.ktm.genome.core.logic.system.System;
	
	public class CollisionSystem extends System {
		private var movingEntities:Family;
		private var targetMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		import com.ktm.genome.core.entity.family.matcher.allOfGenes;
		import com.ktm.genome.core.data.component.IComponentMapper;
		import com.ktm.genome.core.entity.family.Family;
		import com.ktm.genome.core.entity.IEntity;
		import com.ktm.genome.core.logic.system.System;
		import com.ktm.genome.render.component.Transform;
		import com.lip6.genome.geography.move.component.TargetPos;
		
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			movingEntities = entityManager.getFamily(allOfGenes(Transform, TargetPos));

			transformMapper = geneManager.getComponentMapper(Transform);
			targetMapper = geneManager.getComponentMapper(TargetPos);
		}
		
		override protected function onProcess(delta:Number):void
		{
			var familySize:int = movingEntities.members.length; 
			for (var i:int = 0 ; i < familySize ; i++) {
				var e:IEntity = movingEntities.members[i];
				
				var tr:Transform = transformMapper.getComponent(e);
				var target:TargetPos = targetMapper.getComponent(e);
				
				//top border->kill
				if (tr.y == 0)
					entityManager.killEntity(e);
					
				
			}
		}
	}	

}