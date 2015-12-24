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
	import components.Intrus.Virus;
	import components.Intrus.Toxine;
	import components.Intrus.Dechet;
	import components.Game.Spawn;
	
	public class RandomMovingSystem extends System {
		
		private var movingBacteries:Family;
		private var movingVirus:Family;
		private var movingToxines:Family;
		private var movingDechets:Family;
		
		private var targetMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		private var speedMapper:IComponentMapper;
		private var elementMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			super.onConstructed();
			movingBacteries = entityManager.getFamily(	allOfGenes(Transform, TargetPos, Bacterie), noneOfGenes(Spawn));
			movingVirus = entityManager.getFamily(	allOfGenes(Transform, TargetPos, Virus), noneOfGenes(Spawn));
			movingToxines = entityManager.getFamily(	allOfGenes(Transform, TargetPos, Toxine), noneOfGenes(Spawn));
			movingDechets = entityManager.getFamily(	allOfGenes(Transform, TargetPos, Dechet), noneOfGenes(Spawn));
			transformMapper = geneManager.getComponentMapper(Transform);
			targetMapper = geneManager.getComponentMapper(TargetPos);
			
		}
		
		override protected function onProcess(delta:Number):void {
			//Bacteries
			var familySize:int = movingBacteries.members.length;
			for (var i:int = 0 ; i < familySize ; i++) {
				var e:IEntity = movingBacteries.members[i];
				var tr:Transform = transformMapper.getComponent(e);
				var target:TargetPos = targetMapper.getComponent(e);
				
				elementMapper = geneManager.getComponentMapper(Bacterie);
				var bacterie:Bacterie = elementMapper.getComponent(e);
				
				if (tr.rotation != bacterie.direction){
					if (Math.abs(tr.rotation - bacterie.direction) < 3) {
						if (tr.rotation < bacterie.direction) tr.rotation += 1;
						else tr.rotation -= 1;
					} else {
						if (tr.rotation < bacterie.direction) tr.rotation += 3;
						else tr.rotation -= 3;
					}
				}
				
				if (target.x == tr.x && target.y == tr.y) {
					bacterie.direction = Math.round(Math.random() * 90) + 45;
					
					var angleRad:Number = bacterie.direction * Math.PI / 180;
					var tan:Number = Math.random() * 100;
					
					var newx:Number= target.x + tan * (Math.cos(angleRad));
					var newy:Number = target.y + tan * (Math.sin(angleRad));
					
					target.x = Math.min(Math.max(0, newx), Global.windowx - 20);
					target.y = Math.min(Math.max(0, newy), Global.windowy + 40);
				}
			}
			
			
			//Virus
			familySize = movingVirus.members.length;
			for (i = 0 ; i < familySize ; i++) {
				e = movingVirus.members[i];
				tr = transformMapper.getComponent(e);
				target = targetMapper.getComponent(e);
				
				elementMapper = geneManager.getComponentMapper(Virus);
				var virus:Virus = elementMapper.getComponent(e);
				
				if (tr.rotation != virus.direction){
					if (Math.abs(tr.rotation - virus.direction) < 3) {
						if (tr.rotation < virus.direction) tr.rotation += 1;
						else tr.rotation -= 1;
					} else {
						if (tr.rotation < virus.direction) tr.rotation += 3;
						else tr.rotation -= 3;
					}
				}
				
				if (target.x == tr.x && target.y == tr.y) {
					
					var angle:Number = Math.round(Math.random() * 60);
					if (Math.random() < 0.5) virus.direction = 90 + angle;
					else virus.direction = 90 - angle;
					
					angleRad = virus.direction * Math.PI / 180;
					tan = Math.random() * 200;
					
					newx = target.x + tan * (Math.cos(angleRad));
					newy = target.y + tan * (Math.sin(angleRad));
					
					target.x = Math.min(Math.max(0, newx), Global.windowx);
					target.y = Math.min(Math.max(0, newy), Global.windowy);
				}
			}
			
			
			//Toxines
			familySize = movingToxines.members.length;
			for (i = 0 ; i < familySize ; i++) {
				e = movingToxines.members[i];
				tr = transformMapper.getComponent(e);
				target = targetMapper.getComponent(e);
				
				elementMapper = geneManager.getComponentMapper(Toxine);
				var toxine:Toxine = elementMapper.getComponent(e);
				
				if (target.x == tr.x && target.y == tr.y) {
					
					angle = Math.round(Math.random() * 20);
					if (Math.random() < 0.5) toxine.direction = 90 + angle;
					else toxine.direction = 90 - angle;
					
					angleRad = toxine.direction * Math.PI / 180;
					tan = Math.random() * 100;
					
					newx = target.x + tan * (Math.cos(angleRad));
					newy = target.y + tan * (Math.sin(angleRad));
					
					target.x = Math.min(Math.max(0, newx), Global.windowx - 20);
					target.y = Math.min(Math.max(0, newy), Global.windowy + 40);
				}
			}
			
			
			//Dechets
			familySize = movingDechets.members.length;
			for (i = 0 ; i < familySize ; i++) {
				e = movingDechets.members[i];
				tr = transformMapper.getComponent(e);
				target = targetMapper.getComponent(e);
				
				elementMapper = geneManager.getComponentMapper(Dechet);
				var dechet:Dechet = elementMapper.getComponent(e);
				
				if (target.x == tr.x && target.y == tr.y) {
					
					angle = Math.round(Math.random() * 10);
					if (Math.random() < 0.5) dechet.direction = 90 + angle;
					else dechet.direction = 90 - angle;
					
					angleRad = dechet.direction * Math.PI / 180;
					tan = Math.random() * 200;
					
					newx = target.x + tan * (Math.cos(angleRad));
					newy = target.y + tan * (Math.sin(angleRad));
					
					target.x = Math.min(Math.max(0, newx), Global.windowx - 20);
					target.y = Math.min(Math.max(0, newy), Global.windowy + 40);
				}
			}
		}
	}

}