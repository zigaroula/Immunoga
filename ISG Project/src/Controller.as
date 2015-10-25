package  
{
	import com.ktm.genome.core.IWorld;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.render.component.Transform;
	import com.lip6.genome.geography.move.component.TargetPos;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.gene.GeneManager;
	import com.ktm.genome.core.data.component.IComponentMapper;
	
	public class Controller 
	{
		static private var speed:Number = 10;

		static public function ControlShip(e:KeyboardEvent, world:IWorld) :void {
			//TODO: with Ship gene
			var ships:Family = world.getEntityManager().getFamily(allOfGenes(Transform, TargetPos));
			
			var geneManager:GeneManager = world.getGeneManager();
			var transformMapper:IComponentMapper = geneManager.getComponentMapper(Transform);
			
			if (ships.members.length < 1)
				return;
				
			var s:IEntity = ships.members[0];	
			var tr:Transform = transformMapper.getComponent(s);
			
			var key:uint = e.keyCode;
			var step:uint = 5;
				
			switch (key) {
				case Keyboard.LEFT :
					tr.x = tr.x - speed;
					break;
				case Keyboard.RIGHT :
					tr.x = tr.x + speed;
					break;
				case Keyboard.UP :
					tr.y = tr.y - speed;
					break;
				case Keyboard.DOWN :
					tr.y = tr.y + speed;
					break;
				case Keyboard.SPACE:
					EntityFactory.createEntityXY(world.getEntityManager(), tr.x, tr.y);
			}
				
		}
		
		/* ---- ALTERNATIVE MOVEMENTS ---- */
		
		static private var hash:Object = { };
		static private var cpt:Number = 0;
		
		static public function keyHandleUp(event:KeyboardEvent):void {
			delete hash[event.keyCode];
		}
		
		static public function keyHandleDown(event:KeyboardEvent):void {
			hash[event.keyCode] = 1;
		}
		
		static public function isKeyDown(code:int):Boolean {
			return hash[code] !== undefined;
		}
		
		static public function ControlShipAlt(world:IWorld) :void {
			//TODO: with Ship gene
			var ships:Family = world.getEntityManager().getFamily(allOfGenes(Transform, TargetPos));
			
			var geneManager:GeneManager = world.getGeneManager();
			var transformMapper:IComponentMapper = geneManager.getComponentMapper(Transform);
			
			if (ships.members.length < 1)
				return;
				
			var s:IEntity = ships.members[0];	
			var tr:Transform = transformMapper.getComponent(s);
			
			if (isKeyDown(Keyboard.LEFT)) {
				tr.x = tr.x - speed;
			}
			
			if (isKeyDown(Keyboard.RIGHT)) {
				tr.x = tr.x + speed;
			}
			
			if (isKeyDown(Keyboard.UP)) {
				tr.y = tr.y - speed;
			}
			
			if (isKeyDown(Keyboard.DOWN)) {
				tr.y = tr.y + speed;
			}
			
			if (isKeyDown(Keyboard.A)) {
				if (cpt>=5) {
					EntityFactory.createEntityXY(world.getEntityManager(), tr.x, tr.y);
					cpt = 0;
				}
				cpt++;
			}
				
		}
		
	}
}