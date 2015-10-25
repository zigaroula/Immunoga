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
			
			stage.addEventListener(MouseEvent.CLICK, _onStageMouseDown);
		}
		
		private function _onStageMouseDown(e:MouseEvent):void {	
			EntityFactory.createEntityXY(world.getEntityManager(), e.localX, e.localY);
		}
		
	}
	
}