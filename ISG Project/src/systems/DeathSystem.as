package systems {
	
	import com.ktm.genome.core.data.component.IComponent;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.family.matcher.anyOfGenes;
	import com.ktm.genome.core.entity.family.matcher.noneOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.lip6.genome.geography.move.component.TargetPos;
	
	import components.SystemeImmunitaire.LymphocyteB;
	import components.SystemeImmunitaire.LymphocyteBBacterien;
	import components.SystemeImmunitaire.LymphocyteBViral;
	import components.SystemeImmunitaire.LymphocyteT;
	import components.SystemeImmunitaire.Macrophage;
	import components.SystemeImmunitaire.CelluleStructure;
	import components.Intrus.Bacterie;
	import components.Infection;
	import components.SIEntity;
	
	public class DeathSystem extends System {
		
		private var infectedBacteries:Family;
		private var infectedDefenses:Family;
		private var notInfectedDefenses:Family;
		private var notInfectedBacteries:Family;
		private var siEntities:Family;
		
		private var transformMapper:IComponentMapper;
		private var siMapper:IComponentMapper;
		private var infectionMapper:IComponentMapper;
		
		private var x:int;
		private var y:int;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			notInfectedDefenses = entityManager.getFamily(anyOfGenes(CelluleStructure, Macrophage, LymphocyteB, LymphocyteBBacterien, LymphocyteBViral, LymphocyteT), noneOfGenes(Infection));
			infectedDefenses = entityManager.getFamily(anyOfGenes(CelluleStructure, Macrophage, LymphocyteB, LymphocyteBBacterien, LymphocyteBViral, LymphocyteT), allOfGenes(Infection));
			
			notInfectedBacteries = entityManager.getFamily(allOfGenes(Bacterie), noneOfGenes(Infection));
			infectedBacteries = entityManager.getFamily(allOfGenes(Bacterie, Infection));
			
			siEntities = entityManager.getFamily(allOfGenes(SIEntity));
			
			transformMapper = geneManager.getComponentMapper(Transform);
			siMapper = geneManager.getComponentMapper(SIEntity);
		}
		
		override protected function onProcess(delta:Number):void {
			deathTriggers(infectedDefenses, spawnDechets1);
			deathTriggers(infectedDefenses, spawnVirus);
			
			deathTriggers(infectedBacteries, spawnDechets2);
			deathTriggers(infectedBacteries, spawnVirus);
			
			deathTriggers(notInfectedDefenses, spawnDechets2);
			
			deathTriggers(notInfectedBacteries, spawnDechets1);
			
			killNegHp();
		}
		
		public function killNegHp():void {
			var familySize:int = siEntities.members.length;
			for (var i:int = 0; i < familySize; i++) {
				var e:IEntity = siEntities.members[i];
				var si:SIEntity = siMapper.getComponent(e);
				
				if (si.hp <= 0)
					entityManager.killEntity(e);
			}
		}
		
		public function deathTriggers(f:Family, callback:Function):void  {
			var familySize:int = f.members.length;
			for (var i:int = 0; i < familySize; i++) {
				var e:IEntity = f.members[i];
				
				var tr:Transform = transformMapper.getComponent(e);
				var si:SIEntity = siMapper.getComponent(e);
				
				if (si.hp <= 0) {
					//trace("death");
					x = tr.x + 15;
					y = tr.y + 15;
					
					callback(x, y);
				}
			}		
		}
	
		public function spawnDechets1(x:int, y:int):void {
			EntityFactory.createDechet(entityManager, x     , y - 11, x     , y - 11, 1);
			EntityFactory.createDechet(entityManager, x + 11, y     , x + 11, y     , 2);
			EntityFactory.createDechet(entityManager, x     , y + 11, x     , y + 11, 3);
			EntityFactory.createDechet(entityManager, x - 11, y     , x - 11, y     , 1);
			EntityFactory.createDechet(entityManager, x     , y     , x     , y     , 2);
		}
		
		public function spawnDechets2(x:int, y:int):void {
			EntityFactory.createDechet(entityManager, x     , y - 11, x     , y - 11, 1);
			EntityFactory.createDechet(entityManager, x + 11, y     , x + 11, y     , 2);
		}
		
		public function spawnVirus(x:int, y:int):void {
			EntityFactory.createVirus(entityManager, x, y, x     , y - 11);
			EntityFactory.createVirus(entityManager, x, y, x + 11, y     );
			EntityFactory.createVirus(entityManager, x, y, x     , y + 11);
			EntityFactory.createVirus(entityManager, x, y, x - 11, y     );
			EntityFactory.createVirus(entityManager, x, y, x     , y     );
		}
	}
}