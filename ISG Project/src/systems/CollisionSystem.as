package systems {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.logic.system.System;
	import components.Game.Ship;
	import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
	
	public class CollisionSystem extends System {
		private var movingEntities:Family;
		
		//def
		private var macrophages:Family;
		
		private var acBact:Family;
		private var acVir:Family;
		
		private var lymphB:Family;
		private var lymphBBact:Family;
		private var lymphBVir:Family;
		
		private var lymphT:Family;
		
		//intrus
		private var bacteries:Family;
		private var dechets:Family;
		private var toxines:Family;
		private var virus:Family;
		
		//
		private var ships:Family;
		
		//infect
		private var celStruct:Family;
		private var celStructInf:Family;
		private var bactInf :Family;

		private var targetMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		private var siMapper:IComponentMapper;
		
		private var textureMapper:IComponentMapper;
		private var lymphbMapper:IComponentMapper;
		
		import com.ktm.genome.core.entity.family.matcher.allOfGenes;
		import com.ktm.genome.core.entity.family.matcher.noneOfGenes;
		import com.ktm.genome.core.data.component.IComponentMapper;
		import com.ktm.genome.core.entity.family.Family;
		import com.ktm.genome.core.entity.IEntity;
		import com.ktm.genome.core.logic.system.System;
		import com.ktm.genome.render.component.Transform;
		import com.lip6.genome.geography.move.component.TargetPos;
		import com.ktm.genome.resource.component.TextureResource;
		
		import components.Game.Ship;
		import components.Game.Spawn;
		import components.Intrus.Bacterie;
		import components.Intrus.Dechet;
		import components.Intrus.Toxine;
		import components.Intrus.Virus;
		
		import components.SystemeImmunitaire.Macrophage;
		import components.SystemeImmunitaire.AnticorpsBacterien;
		import components.SystemeImmunitaire.AnticorpsViral;
		import components.SystemeImmunitaire.CelluleStructure;
		import components.SystemeImmunitaire.LymphocyteB;
		import components.SystemeImmunitaire.LymphocyteBBacterien;
		import components.SystemeImmunitaire.LymphocyteBViral;
		import components.SystemeImmunitaire.LymphocyteT;
		import components.SystemeImmunitaire.CelluleStructure;

		import components.SIEntity;
		import components.Infection;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			ships = entityManager.getFamily(allOfGenes(Ship));
			
			movingEntities	= entityManager.getFamily(allOfGenes(	Transform, TargetPos ),		noneOfGenes(Spawn));
			
			macrophages = entityManager.getFamily(noneOfGenes(Spawn), 	allOfGenes(Macrophage ));
		
			acBact			=	entityManager.getFamily(noneOfGenes(Spawn), 	allOfGenes(AnticorpsBacterien ));
			acVir				=	entityManager.getFamily(noneOfGenes(Spawn), 	allOfGenes(AnticorpsViral ));
		
			lymphB			=	entityManager.getFamily(noneOfGenes(Spawn), 	allOfGenes(LymphocyteB ));
			lymphBBact	=	entityManager.getFamily(noneOfGenes(Spawn), 	allOfGenes(LymphocyteBBacterien ));
			lymphBVir		=	entityManager.getFamily(noneOfGenes(Spawn), 	allOfGenes(LymphocyteBViral ));
		
			lymphT			=	entityManager.getFamily(noneOfGenes(Spawn), 	allOfGenes(LymphocyteT ));
		
			bacteries		=	entityManager.getFamily(noneOfGenes(Spawn), 	allOfGenes(Bacterie ));
			dechets			=	entityManager.getFamily(noneOfGenes(Spawn), 	allOfGenes(Dechet ));
			toxines			=	entityManager.getFamily(noneOfGenes(Spawn), 	allOfGenes(Toxine ));
			virus				=	entityManager.getFamily(noneOfGenes(Spawn), 	allOfGenes(Virus ));
			
			celStruct		=	entityManager.getFamily(noneOfGenes(Spawn, Infection), 	allOfGenes(CelluleStructure ));
		
			celStructInf    = entityManager.getFamily(noneOfGenes(Spawn), 		allOfGenes(CelluleStructure, Infection ));
			bactInf   		= entityManager.getFamily(noneOfGenes(Spawn), 		allOfGenes(CelluleStructure, Infection ));

			transformMapper = geneManager.getComponentMapper(Transform);
			targetMapper = geneManager.getComponentMapper(TargetPos);
			siMapper = geneManager.getComponentMapper(SIEntity);

			textureMapper = geneManager.getComponentMapper(TextureResource);
			lymphbMapper = geneManager.getComponentMapper(LymphocyteB);
		}
		
		override protected function onProcess(delta:Number):void
		{
			var familySize:int = movingEntities.members.length;
			for (var i:int = 0 ; i < familySize ; i++) {
				var e:IEntity = movingEntities.members[i];
				
				var tr:Transform = transformMapper.getComponent(e);
				var target:TargetPos = targetMapper.getComponent(e);
				var si:SIEntity = siMapper.getComponent(e);
				
				//top border->kill
				if (tr.y == -50 || tr.y > 730 || tr.x < - 10 || tr.x > 500)
					entityManager.killEntity(e);
			}
			
			processCollisions(macrophages, bacteries, aDamagesB, 49);
			processCollisions(macrophages, toxines, aDamagesB, 100);
			processCollisions(macrophages, dechets, aDamagesB, 100);
			processCollisions(macrophages, dechets, aDamagesB, 100);
			
			processCollisions(lymphB, bacteries, aSpecializes, Global.LYMPHBBACT);
			processCollisions(lymphB, virus, aSpecializes, Global.LYMPHBVIR);
			
			processCollisions(lymphBBact, bacteries, aDamagesB, 100);
			processCollisions(lymphBVir, virus, aDamagesB, 100);
			
			processCollisions(lymphT, celStructInf, aDamagesB, 100);
			processCollisions(lymphT, bactInf, aDamagesB, 1);
			
			processCollisions(toxines, celStruct, aDamagesB, 1);
			
			processCollisions(virus, bacteries, aInfectsB, 1);
			processCollisions(virus, macrophages, aInfectsB, 1);
			processCollisions(virus, lymphT, aInfectsB, 1);
			processCollisions(virus, celStruct, aInfectsB, 1);
			processCollisions(virus, lymphBBact, aInfectsB, 1);
			
			processCollisions(toxines, celStruct, aDamagesB, 1);
			processCollisions(toxines, lymphB, aDamagesB, 10);
			processCollisions(toxines, lymphBBact, aDamagesB, 10);
			processCollisions(toxines, lymphBVir, aDamagesB, 10);			
		}
 
		//f1-f2 -> delete f2
		private function processCollisions( f1:Family, f2:Family, interaction:Function, attr:int):void {
			var n1:int = f1.members.length;
			var n2:int = f2.members.length;
			
			for (var i:int = 0 ; i < n1 ; i++) {
				var a:IEntity = f1.members[i];
				var ta:Transform = transformMapper.getComponent(a);
				
				for (var j:int = 0; j < n2 ; j++) {
					var b:IEntity = f2.members[j];
					var tb:Transform = transformMapper.getComponent(b);
					if (collision(ta, tb)) {
						interaction(a, b, attr);
					}
				}
			}
		}
		
		static private var deltax:Number = 25;
		static private var deltay:Number = 5;			
		private function collision(ta:Transform, tb:Transform):Boolean {
			//trace("COMPARING" + ta.x + tb.x + "  " + ta.y + tb.y );
			var x1:int = ta.x + 50 / 2;
			var y1:int = ta.y + 50 / 2;
			
			var x2:int = tb.x ;
			var y2:int = tb.y ;
			return ( (Math.abs(x1 - x2) < deltax) && (Math.abs(y1 - y2) < deltay) );
		}
		
		private function aDamagesB(a:IEntity, b:IEntity, dmg:int) :void{
			var si:SIEntity = siMapper.getComponent(b);
				entityManager.killEntity(a);
				
				si.hp -= dmg;
				if(si.hp < 0)
					entityManager.killEntity(b);
		}
		
		private function aSpecializes(a:IEntity, b:IEntity, type:int) :void {
			var tr:Transform	= transformMapper.getComponent(a);
			
			var x:int = tr.x;
			var y:int = tr.y;
				
			entityManager.killEntity(a);
			EntityFactory.createEntityOfType(entityManager, x-25, y, type);	
		}
		
		private function aInfectsB(a:IEntity, b:IEntity, dmg:int) :void{
			entityManager.addComponent(b, Infection, { } );
		}
	}
}