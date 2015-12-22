package {
	import com.ktm.genome.core.BigBang;
	import com.ktm.genome.core.IWorld;
	import com.ktm.genome.core.logic.system.ISystemManager;
	import com.ktm.genome.render.system.RenderSystem;
	import com.ktm.genome.core.logic.process.ProcessPhase;
	import com.ktm.genome.resource.manager.ResourceManager;
	import com.lip6.genome.geography.move.system.MoveToSystem;
	import systems.CollisionSystem;
	import systems.RandomMovingSystem;
	import flash.display.Sprite;
	import flash.events.Event;	
	import systems.ControllerSystem;
	import systems.BackgroundSystem;
	import systems.SpawnSystem;
	import systems.BacterieSpawnSystem;
	import systems.HpSystem
	import systems.DeathSystem;
	import systems.LevelSystem;
	
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Main extends Sprite {
		
		private var world:IWorld;
		private var gameURL:String = 'xml/game.entityBundle.xml';
		private var level1:String = 'xml/level1.entityBundle.xml';
		
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
			sm.setSystem(SpawnSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(BackgroundSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(new ControllerSystem(stage)).setProcess(ProcessPhase.FRAME);
			sm.setSystem(RandomMovingSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(BacterieSpawnSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(HpSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(CollisionSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(DeathSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(LevelSystem).setProcess(ProcessPhase.FRAME);
			//start
			
			var level:int = 0;
			EntityFactory.createResourcedEntity(world.getEntityManager(), gameURL, "game");
			switch(level) {
				case 0:  EntityFactory.createResourcedEntity(world.getEntityManager(), level1, "level1");
					break;
				case 1: EntityFactory.createResourcedEntity(world.getEntityManager(), level1, "level1");
					break;
				default: break;
			}
		}
		
		
	}
	
}