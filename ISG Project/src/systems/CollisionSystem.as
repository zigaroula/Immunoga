package systems {
	
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.logic.system.System;
	import components.Game.Ship;
	
	public class CollisionSystem extends System {
		private var movingEntities:Family;
		private var macrophages:Family;
		private var bacteries:Family;
		private var ships:Family;
		
		private var targetMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		
		import com.ktm.genome.core.entity.family.matcher.allOfGenes;
		import com.ktm.genome.core.entity.family.matcher.noneOfGenes;
		import com.ktm.genome.core.data.component.IComponentMapper;
		import com.ktm.genome.core.entity.family.Family;
		import com.ktm.genome.core.entity.IEntity;
		import com.ktm.genome.core.logic.system.System;
		import com.ktm.genome.render.component.Transform;
		import com.lip6.genome.geography.move.component.TargetPos;
		
		import components.Game.Ship;
		import components.Game.Spawn;
		import components.SystemeImmunitaire.Macrophage;
		import components.Intrus.Bacterie;
		
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			ships = entityManager.getFamily(allOfGenes(Ship));
			
			movingEntities	= entityManager.getFamily(allOfGenes(	Transform, TargetPos ),	noneOfGenes(Spawn));
			
			macrophages	= entityManager.getFamily(allOfGenes(	Macrophage ),						noneOfGenes(Spawn));
			bacteries			= entityManager.getFamily(allOfGenes(	Bacterie	),								noneOfGenes(Spawn));

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
				if (tr.y == -50)
					entityManager.killEntity(e);	
			}

			processCollisions(macrophages, bacteries);
			//macrophage bacterie			
			
		}
 
		//f1-f2 -> delete f2
		private function processCollisions( f1:Family, f2:Family):void {
			var n1:int = f1.members.length;
			var n2:int = f2.members.length;
						
			for (var i:int = 0 ; i < n1 ; i++) {
				var a:IEntity = f1.members[i];
				var ta:Transform = transformMapper.getComponent(a);

				for (var j:int = 0; j < n2 ; j++) {
					var b:IEntity = f2.members[j];
					var tb:Transform = transformMapper.getComponent(b);
					if (collision(ta, tb))
						entityManager.killEntity(b);
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
	}
}