package {
	import com.ktm.genome.core.BigBang;
	import com.ktm.genome.core.IWorld;
	import com.ktm.genome.core.logic.system.ISystemManager;
	import com.ktm.genome.render.system.RenderSystem;
	import com.ktm.genome.core.logic.process.ProcessPhase;
	import com.ktm.genome.resource.manager.ResourceManager;
	import com.lip6.genome.geography.move.system.MoveToSystem;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
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

	public class Main extends Sprite {
		
		private var world:IWorld;
		private var gameURL:String = 'xml/game.entityBundle.xml';
		
		public function Main() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			world = BigBang.createWorld(stage);
			var sm:ISystemManager = world.getSystemManager();
			//set systems
			sm.setSystem(ResourceManager).setProcess(ProcessPhase.TICK, int.MAX_VALUE);
			sm.setSystem(new RenderSystem(this)).setProcess(ProcessPhase.FRAME);
			sm.setSystem(MoveToSystem).setProcess(ProcessPhase.FRAME);
			//start
			EntityFactory.createResourcedEntity(world.getEntityManager(), gameURL, "game");
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _keyPressedDown);
			stage.addEventListener(MouseEvent.CLICK, _onStageMouseDown);
		}
		
		private function _onStageMouseDown(e:MouseEvent):void {	
			EntityFactory.createEntityXY(world.getEntityManager(), e.localX, e.localY);
		}
		
		private function _keyPressedDown(e:KeyboardEvent):void {
			//TODO: with Ship gene
			var ships:Family = world.getEntityManager().getFamily(allOfGenes(Transform, TargetPos));
			
			var geneManager:GeneManager = world.getGeneManager();
			var transformMapper:IComponentMapper = geneManager.getComponentMapper(Transform);
			if (ships.members.length > 0) {
				var s:IEntity = ships.members[0];
				trace(s);					
	
				var tr:Transform = transformMapper.getComponent(s);			
				var speed = 10;
			
				var key:uint = e.keyCode;
					var step:uint = 5
					switch (key) {
						case Keyboard.LEFT :
							tr.x = tr.x - speed;
							break;
						case Keyboard.RIGHT :
							tr.x = tr.x + speed;
							break;
						/*case Keyboard.UP :
							break;
						case Keyboard.DOWN :
							break;*/
						case Keyboard.SPACE:
							EntityFactory.createEntityXY(world.getEntityManager(), tr.x, tr.y);
					}	
			}
		}
	}
	
}