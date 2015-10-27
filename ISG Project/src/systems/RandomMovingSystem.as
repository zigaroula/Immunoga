package systems {
import com.ktm.genome.core.data.component.IComponent;
import com.ktm.genome.core.logic.system.System;
import com.ktm.genome.core.entity.family.matcher.allOfGenes;
import com.ktm.genome.core.entity.family.matcher.noneOfGenes;
import com.ktm.genome.core.data.component.IComponentMapper;
import com.ktm.genome.core.entity.family.Family;
import com.ktm.genome.core.entity.IEntity;
import com.ktm.genome.render.component.Transform;
import com.lip6.genome.geography.move.component.TargetPos;
import components.Intrus.Bacterie;
import components.Game.Spawn;
	
	public class RandomMovingSystem extends System {
		
		private var movingEntities:Family;
		private var targetMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		private var speedMapper:IComponentMapper;
		private var elementMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			super.onConstructed();
			movingEntities = entityManager.getFamily(	allOfGenes(Transform, TargetPos, Bacterie), noneOfGenes(Spawn));
			
			transformMapper = geneManager.getComponentMapper(Transform);
			targetMapper = geneManager.getComponentMapper(TargetPos);
			elementMapper = geneManager.getComponentMapper(Bacterie);
			
		}
		
		override protected function onProcess(delta:Number):void {

			var familySize:int = movingEntities.members.length;
			for (var i:int = 0 ; i < familySize ; i++) {
				var e:IEntity = movingEntities.members[i];
				var tr:Transform = transformMapper.getComponent(e);
				var target:TargetPos = targetMapper.getComponent(e);
				var element:Bacterie = elementMapper.getComponent(e);
				
				if (tr.rotation != element.direction){
					if (Math.abs(tr.rotation - element.direction) < 3) {
						if (tr.rotation < element.direction) tr.rotation += 1;
						else tr.rotation -= 1;
					} else {
						if (tr.rotation < element.direction) tr.rotation += 3;
						else tr.rotation -= 3;
					}
				}
				
				if (target.x == tr.x && target.y == tr.y) {
					element.direction = Math.round(Math.random() * 90) + 45;
					
					var angleRad:Number = element.direction * Math.PI / 180;
					var tan:Number = Math.random() * 100;
					
					var newx:Number= target.x + tan * (Math.cos(angleRad));
					var newy:Number = target.y + tan * (Math.sin(angleRad));
					
					target.x = Math.min(Math.max(0, newx), 405 - 20);
					target.y = Math.min(Math.max(0, newy), 720 + 40);
				}
			}
		}
	}

}