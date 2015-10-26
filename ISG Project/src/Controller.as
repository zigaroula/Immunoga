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
	import flash.events.Event;
	import flash.display.Stage;
	import components.SystemeImmunitaire.Macrophage;
	import components.Game.Ship;
	
	public class Controller 
	{
		static private var speed:Number = 10;			
		static private var hash:Object = { };
		static private var cpt:Number = 0;
		
		static private var world:IWorld;
		static private var stage:Stage;
		
		
		public static function init(_stage:Stage, _world:IWorld):void {
			stage = _stage;
			world = _world;
			
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandleUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandleDown);
			stage.addEventListener(Event.ENTER_FRAME, ControlShip);
		}		
		
		static private function keyHandleUp(event:KeyboardEvent):void {
			delete hash[event.keyCode];
		}
		
		static private function keyHandleDown(event:KeyboardEvent):void {
			hash[event.keyCode] = 1;
		}
		
		static public function isKeyDown(code:int):Boolean {
			return hash[code] !== undefined;
		}
		
		static public function ControlShip(event:Event) :void {
			var ships:Family = world.getEntityManager().getFamily(allOfGenes(Ship));
			
			var geneManager:GeneManager = world.getGeneManager();
			var transformMapper:IComponentMapper = geneManager.getComponentMapper(Transform);
			
			if (ships.members.length < 1)
				return;
				
			var s:IEntity = ships.members[0];	
			var tr:Transform = transformMapper.getComponent(s);
			
			if (isKeyDown(Keyboard.LEFT))
				tr.x = tr.x - speed;
			
			if (isKeyDown(Keyboard.RIGHT))
				tr.x = tr.x + speed;
			
			if (isKeyDown(Keyboard.UP))
				tr.y = tr.y - speed;
			
			if (isKeyDown(Keyboard.DOWN))
				tr.y = tr.y + speed;
			
			if (isKeyDown(Keyboard.SPACE)) {
				if (cpt>=5) {
					EntityFactory.createEntityXY(world.getEntityManager(), tr.x, tr.y);
					cpt = 0;
				}
				cpt++;
			}
		}
	}
	
}