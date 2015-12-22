package systems {
	
	import com.ktm.genome.core.data.gene.GeneManager;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.logic.system.System;
	import flash.display.Stage;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.lip6.genome.geography.move.component.TargetPos;
	import components.Game.Ship;
	import components.Game.Level;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class ControllerSystem extends System {
		
		private var ships:Family;
		private var levels:Family;
		private var transformMapper:IComponentMapper;
		private var speed:Number = 10;			
		private var hash:Object = { };
		private var cpt:Number = 0;
		private var type:int = Global.MACROPHAGE;
		
		public function ControllerSystem(stage:Stage) {
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandleUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandleDown);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		}
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			ships = entityManager.getFamily(allOfGenes(Ship));
			levels = entityManager.getFamily(allOfGenes(Level));
			transformMapper = geneManager.getComponentMapper(Transform);
		}
		
		override protected function onProcess(delta:Number):void {
			if (ships.members.length < 1)
				return;
				
			var s:IEntity = ships.members[0];	
			var tr:Transform = transformMapper.getComponent(s);
			
			if (isKeyDown(Keyboard.LEFT))
				tr.x = Math.min(Math.max(0, tr.x - speed), 405 - 40);
				
			if (isKeyDown(Keyboard.RIGHT))
				tr.x = Math.min(Math.max(0, tr.x + speed), 405 - 40);
			
			if (isKeyDown(Keyboard.UP))
				tr.y = Math.min(Math.max(0, tr.y - speed), 720 - 40);
			
			if (isKeyDown(Keyboard.DOWN))
				tr.y = Math.min(Math.max(0, tr.y + speed), 720 - 40);
			
			if (isKeyDown(Keyboard.SPACE) && levels.members.length != 0) {
				if (cpt>=5) {
					EntityFactory.createEntityOfType(entityManager, tr.x, tr.y, type);
					cpt = 0;
				}
				cpt++;
			}
		}
		
		private function keyHandleUp(event:KeyboardEvent):void {
			delete hash[event.keyCode];
		}
		
		private function keyHandleDown(event:KeyboardEvent):void {
			hash[event.keyCode] = 1;
		}
		
		private function isKeyDown(code:int):Boolean {
			return hash[code] !== undefined;
		}
		
		private function keyPressed(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case Keyboard.F1:
					type = Global.MACROPHAGE;
					break;
				case Keyboard.F2:
					type = Global.LYMPHOCYTEB;
					break;
				case Keyboard.F3:
					type = Global.LYMPHOCYTET;
					break;
			}
		}
	}

}