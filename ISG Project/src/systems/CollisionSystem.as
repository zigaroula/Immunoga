package systems {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.logic.system.System;
	import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
	
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.family.matcher.noneOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.lip6.genome.geography.move.component.TargetPos;
	import com.ktm.genome.resource.component.TextureResource;
	import com.ktm.genome.render.component.Layered;
	
	import components.Game.Ship;
	import components.Game.Spawn;
	import components.Intrus.Bacterie;
	import components.Intrus.Dechet;
	import components.Intrus.Toxine;
	import components.Intrus.Virus;
	
	import components.SystemeImmunitaire.Macrophage;
	import components.SystemeImmunitaire.CelluleStructure;
	import components.SystemeImmunitaire.LymphocyteB;
	import components.SystemeImmunitaire.LymphocyteBBacterien;
	import components.SystemeImmunitaire.LymphocyteBViral;
	import components.SystemeImmunitaire.LymphocyteT;
	import components.SystemeImmunitaire.CelluleStructure;

	import components.SIEntity;
	import components.Infection;
	
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
		
		//game
		private var ships:Family;
		
		//infect
		private var infected:Family;
		private var celStruct:Family;
		private var celStructInf:Family;
		private var bactInf :Family;

		private var targetMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		private var siMapper:IComponentMapper;
		
		private var textureMapper:IComponentMapper;
		private var lymphbMapper:IComponentMapper;
		
		private var layerMapper:IComponentMapper;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			ships = entityManager.getFamily(allOfGenes(Ship));
			
			movingEntities= entityManager.getFamily(allOfGenes(Transform, TargetPos ),	noneOfGenes(Spawn));
			
			macrophages = entityManager.getFamily(noneOfGenes(Spawn, Infection), 	allOfGenes(Macrophage ));
		
			lymphB			=	entityManager.getFamily(noneOfGenes(Spawn, Infection), 	allOfGenes(LymphocyteB ));
			lymphBBact	=	entityManager.getFamily(noneOfGenes(Spawn, Infection), 	allOfGenes(LymphocyteBBacterien ));
			lymphBVir		=	entityManager.getFamily(noneOfGenes(Spawn, Infection), 	allOfGenes(LymphocyteBViral ));
		
			lymphT			=	entityManager.getFamily(noneOfGenes(Spawn, Infection), 	allOfGenes(LymphocyteT ));
		
			bacteries		=	entityManager.getFamily(noneOfGenes(Spawn, Infection), 	allOfGenes(Bacterie ));
			dechets			=	entityManager.getFamily(noneOfGenes(Spawn), 				allOfGenes(Dechet ));
			toxines			=	entityManager.getFamily(noneOfGenes(Spawn), 				allOfGenes(Toxine ));
			virus				=	entityManager.getFamily(noneOfGenes(Spawn), 				allOfGenes(Virus ));
			
			celStruct		=	entityManager.getFamily(noneOfGenes(Spawn, Infection), 	allOfGenes(CelluleStructure ));
		
			celStructInf    = entityManager.getFamily(noneOfGenes(Spawn), 					allOfGenes(CelluleStructure, Infection ));
			bactInf   		= entityManager.getFamily(noneOfGenes(Spawn), 					allOfGenes(CelluleStructure, Infection ));
			
			infected   		= entityManager.getFamily(noneOfGenes(Spawn, Layered), 	allOfGenes(Infection, TargetPos));
		
			transformMapper = geneManager.getComponentMapper(Transform);
			targetMapper 		= geneManager.getComponentMapper(TargetPos);
			siMapper 			= geneManager.getComponentMapper(SIEntity);

			textureMapper 	= geneManager.getComponentMapper(TextureResource);
			lymphbMapper 	= geneManager.getComponentMapper(LymphocyteB);
			layerMapper 		= geneManager.getComponentMapper(Layered);
		}
		
		public const windowx:int = 405;
		public const windowy:int = 720;
		override protected function onProcess(delta:Number):void
		{
			//borders
			var familySize:int = movingEntities.members.length;
			for (var i:int = 0 ; i < familySize ; i++) {
				var e:IEntity = movingEntities.members[i];
				
				var tr:Transform = transformMapper.getComponent(e);
				var target:TargetPos = targetMapper.getComponent(e);
				var si:SIEntity = siMapper.getComponent(e);
				
				if (tr.y == -50 || tr.y > windowy+10 || tr.x < - 10 || tr.x > windowx+50)
					entityManager.killEntity(e);
			}
			
			fixTextures(infected);
			
			processCollisions(0, 25, macrophages, bacteries, aDamagesB, 49);
			processCollisions(0, 25, macrophages, toxines, aDamagesB, 100);
			processCollisions(0, 25, macrophages, dechets, aDamagesB, 100);
			processCollisions(0, 25, macrophages, dechets, aDamagesB, 100);
			
			processCollisions(20, 25, lymphB, bacteries, aSpecializes, Global.LYMPHBBACT);
			processCollisions(20, 25, lymphB, virus, aSpecializes, Global.LYMPHBVIR);
			
			processCollisions(20, 25, lymphBBact, bacteries, aDamagesB, 80);
			processCollisions(20, 25, lymphBVir, virus, aDamagesB, 80);
			
			processCollisions(0, 0, lymphT, celStructInf, aDamagesB, 100);
			processCollisions(0, 25, lymphT, bactInf, aDamagesB, 1);
			
			processCollisions(0, 25, toxines, celStruct, aDamagesB, 1);
			
			processCollisions(20, 0, virus, bacteries, aInfectsB, Global.BACTERIE);
			processCollisions(20, -25, virus, macrophages, aInfectsB, Global.MACROPHAGE);
			processCollisions(20, -25, virus, lymphT, aInfectsB, Global.LYMPHOCYTET);
			processCollisions(20, -25, virus, celStruct, aInfectsB, Global.CELSTRUCT);
			processCollisions(20, -25, virus, lymphBBact, aInfectsB, Global.LYMPHBBACT);
			
			processCollisions(0, -25, toxines, celStruct, aDamagesB, 1);
			processCollisions(0, -25, toxines, lymphB, aDamagesB, 10);
			processCollisions(0, -50, toxines, lymphBBact, aDamagesB, 10);
			processCollisions(0, 25, toxines, lymphBVir, aDamagesB, 10);			
		}
		
		private function fixTextures(f1:Family):void {
			var n1:int = f1.members.length;
			for (var i:int = 0 ; i < n1 ; i++) {
				var a:IEntity = f1.members[i];
				//trace("fixing");				
				var t:TargetPos = targetMapper.getComponent(a);
				var tr:Transform = transformMapper.getComponent(a);
				
				if(t.x==tr.x && t.y==tr.y)
					t.x = tr.x + 1;
				
				entityManager.addComponent (a, Layered, { layerId:"gameLayer" } );
			}
		}
 
		//family f1 interacts with family f2 according to interaction function
		private function processCollisions(range:int, offset:int, f1:Family, f2:Family, interaction:Function, attr:int):void {
			var n1:int = f1.members.length;
			var n2:int = f2.members.length;
			
			for (var i:int = 0 ; i < n1 ; i++) {
				var a:IEntity = f1.members[i];
				var ta:Transform = transformMapper.getComponent(a);
				
				for (var j:int = 0; j < n2 ; j++) {
					var b:IEntity = f2.members[j];
					var tb:Transform = transformMapper.getComponent(b);
					if (collision(range, offset, ta, tb)) {
						interaction(a, b, attr);
					}
				}
			}
		}
		
		//returns "ta is in range of tb"
		static private var deltax:Number = 25;
		static private var deltay:Number = 5;			
		private function collision(range:int, offsetx:int, ta:Transform, tb:Transform):Boolean {
			//trace("COMPARING" + ta.x + tb.x + "  " + ta.y + tb.y );
			var x1:int = ta.x + offsetx;
			var y1:int = ta.y + offsetx;
			
			var x2:int = tb.x ;
			var y2:int = tb.y ;
			return ( (Math.abs(x1 - x2) < (deltax+range)) && (Math.abs(y1 - y2) < (deltay+range)) );
		}
		
		private function aDamagesB(a:IEntity, b:IEntity, dmg:int) :void{
			var si:SIEntity = siMapper.getComponent(b);
				//entityManager.killEntity(a);
				
				si.hp -= dmg;
				if(si.hp < 0)
					entityManager.killEntity(b);
		}
		
		private function aSpecializes(a:IEntity, b:IEntity, type:int) :void {
			var tr:Transform	= transformMapper.getComponent(a);
			
			var x:int = tr.x;
			var y:int = tr.y;
				
			entityManager.killEntity(a);
			EntityFactory.createEntityOfType(entityManager, x-25, y+10, type);	
		}
		
		private function aInfectsB(a:IEntity, b:IEntity, type:int) :void {
			//trace("infect " + type);
			entityManager.killEntity(a);
			entityManager.addComponent(b, Infection, { } );
			
			entityManager.removeComponent(b, textureMapper.gene);
			
			switch(type) {
				case Global.MACROPHAGE:
					entityManager.addComponent (b, TextureResource, { source:"pictures/macro_infected.png", id:"macrophageInf" } );
					break;
				case Global.BACTERIE:
					entityManager.addComponent (b, TextureResource, { source:"pictures/bactery_infected.png", id:"bactInf" } );
					break;
				case Global.LYMPHOCYTET:
					entityManager.addComponent (b, TextureResource, { source:"pictures/tCell_infected.png", id:"macrophage" } );
					break;
				case Global.CELSTRUCT:
					entityManager.addComponent (b, TextureResource, { source:"pictures/structCell_infected.png", id:"macrophage" } );
					break;
				case Global.LYMPHBBACT:
					entityManager.addComponent (b, TextureResource, { source:"pictures/lymphBBact_infected.png", id:"macrophage" } );
					break;
			}
			entityManager.removeComponent(b, layerMapper.gene);
		}
	}
}