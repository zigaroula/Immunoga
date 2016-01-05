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
	import components.SIEntity;
	
	
	public class HpSystem extends System {
		private var hpEntities:Family;
		
		private var transformMapper:IComponentMapper;
		private var siMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			hpEntities = entityManager.getFamily(allOfGenes(SIEntity));
			
			transformMapper = geneManager.getComponentMapper(Transform);
			siMapper = geneManager.getComponentMapper(SIEntity);
		}
		
		override protected function onProcess(delta:Number):void
		{
			var familySize:int = hpEntities.members.length; 
			for (var i:int = 0 ; i < familySize ; i++) {
				var e:IEntity = hpEntities.members[i];
				
				var tr:Transform = transformMapper.getComponent(e);
				var si:SIEntity = siMapper.getComponent(e);
				tr.visible
				tr.alpha = si.hp / 100;
			}
		}
	}
}
