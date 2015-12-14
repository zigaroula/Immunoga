package systems {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.logic.system.System;
	import components.Game.Ship;
	import components.Game.Spawn;
	
	public class BacterieSpawnSystem extends System {
		private var bacterieEntities:Family;
		
		private var bacterieMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		
		import com.ktm.genome.core.entity.family.matcher.allOfGenes;
		import com.ktm.genome.core.data.component.IComponentMapper;
		import com.ktm.genome.core.entity.family.Family;
		import com.ktm.genome.core.entity.IEntity;
		import com.ktm.genome.core.logic.system.System;
		import com.ktm.genome.render.component.Transform;
		import com.lip6.genome.geography.move.component.TargetPos;
		
		import components.Intrus.Bacterie;
		
		override protected function onConstructed():void {
			super.onConstructed();
			bacterieEntities = entityManager.getFamily(allOfGenes(Bacterie));
			bacterieMapper = geneManager.getComponentMapper(Bacterie);
			transformMapper = geneManager.getComponentMapper(Transform);
		}
		
		override protected function onProcess(delta:Number):void {
			
			var familySize:int = bacterieEntities.members.length;
			
			for (var i:int = 0 ; i < familySize ; i++) {
				var e:IEntity = bacterieEntities.members[i];
				
				var tr:Transform = transformMapper.getComponent(e);
				var b:Bacterie = bacterieMapper.getComponent(e);
				
				if (tr.visible) {
					b.timer -= delta;
				}
				
				if (b.timer < 0) {
					b.timer = b.maxTimer;
					EntityFactory.createToxine(entityManager, tr.x, tr.y, tr.x, tr.y + 150		  );
					EntityFactory.createToxine(entityManager, tr.x, tr.y, tr.x + 150, tr.y       );
					EntityFactory.createToxine(entityManager, tr.x, tr.y, tr.x       , tr.y - 150);
					EntityFactory.createToxine(entityManager, tr.x, tr.y, tr.x - 150, tr.y       );
					EntityFactory.createToxine(entityManager, tr.x, tr.y, tr.x + 150, tr.y + 150);
					EntityFactory.createToxine(entityManager, tr.x, tr.y, tr.x + 150, tr.y - 150);
					EntityFactory.createToxine(entityManager, tr.x, tr.y, tr.x - 150, tr.y - 150);
					EntityFactory.createToxine(entityManager, tr.x, tr.y, tr.x - 150, tr.y + 150);
				}
				
			}

		}
	}
}