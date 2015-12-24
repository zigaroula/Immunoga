package systems {
	
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;	
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.render.component.Transform;
	import com.lip6.genome.geography.move.component.TargetPos;
	
	import components.Game.Background;
	
	public class BackgroundSystem extends System {
		private var backgrounds:Family;
		
		private var targetMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			backgrounds = world.getEntityManager().getFamily(allOfGenes(Background));
			
			transformMapper = geneManager.getComponentMapper(Transform);
			targetMapper = geneManager.getComponentMapper(TargetPos);
		}
		
		private var speed:int = 3;
		override protected function onProcess(delta:Number):void
		{
			for (var i:int = 0 ; i < backgrounds.members.length ; i++) {
				var e:IEntity = backgrounds.members[i];
				
				var t:Transform = transformMapper.getComponent(e);
				
				t.y = t.y + speed;
				if (t.y > Global.windowy)
					t.y = -1 * Global.windowy/2;
			}
		}
	}
}